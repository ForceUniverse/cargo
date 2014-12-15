part of cargo_server;

class FileCargo extends Cargo {
  Completer _completer;
  final Logger log = new Logger('JsonStorage');
  String pathToStore;
  String baseDir;
  
  Map<String, Future> readStreams = new Map<String, Future>();
  
  List<String> keys = new List<String>();

  FileCargo(this.baseDir, {collection: ""}) : super._() {
    this.collection = collection;
    
    _setNewStoreDir();
    _completer = new Completer();

    _readInKeys(_completer);
  }
  
  Future withCollection(collection) {
      this.collection = collection;
      _setNewStoreDir();
      
      // reset keys
      keys.clear();
      Completer completer = new Completer();
      _readInKeys(completer);
      
      return completer.future;
  }
  
  CargoBase instanceWithCollection(String collection) {
    return new FileCargo(this.baseDir, collection: collection);
  }
  
  void _setNewStoreDir() {
    String dir = baseDir;
    if (collection!= "") {
      dir = "$dir/$collection/";
    } else if (!dir.endsWith("/")) {
      dir = "$dir/";
    }
    pathToStore = Platform.script.resolve(dir).toFilePath();
    
    if (!_exists(pathToStore)) {
      Directory directory = new Directory(dir);
      directory.createSync();
    }
  }

  bool _exists(dir) {
    try {
      if (!new Directory(dir).existsSync()) {
        log.severe("The '$dir' directory was not found.");
        return false;
      }
    } on FileSystemException {
      log.severe("The '$dir' directory was not found.");
    }
    return true;
  }

  dynamic getItemSync(String key, {defaultValue}) {
    if (keys.contains(key)) {
      var uriKey = new Uri.file(pathToStore).resolve("$key.json");
      var file = new File(uriKey.toFilePath());

      if (file.existsSync()) {
        // need to convert it to json!
        return JSON.decode(file.readAsStringSync());
      }
    }
    _setDefaultValue(key, defaultValue);
    return defaultValue;
  }

  Future getItem(String key, {defaultValue}) {
    Completer complete = new Completer();

    if (keys.contains(key)) {
      var uriKey = new Uri.file(pathToStore).resolve("$key.json");
      var file = new File(uriKey.toFilePath());

      // Need to convert it to json!
      if (file.existsSync()) {
          Stream stream = file.openRead();
          
          // create completer to close stream
          Completer readStreamCompleter = new Completer();
          readStreams[key] = readStreamCompleter.future;
          stream
              .transform(UTF8.decoder) // use a UTF8.decoder
              .listen((String data) => complete.complete(JSON.decode(data)), // output the data
              onDone: () { 
                readStreamCompleter.complete();
                print("Finished reading data");
              });
      } else {
          _setDefaultValue(key, defaultValue);
          complete.complete(defaultValue);
      }
    } else {
      _setDefaultValue(key, defaultValue);
      complete.complete(defaultValue);
    }

    return complete.future;
  }

  void _setDefaultValue(String key, defaultValue) {
    if (defaultValue != null) {
      setItem(key, defaultValue);
    }
  }

  Future setItem(String key, data) {
    var uriKey = new Uri.file(pathToStore).resolve("$key.json");
    var file = new File(uriKey.toFilePath());

    if (file.existsSync()) {
      _writeFile(file, key, data);
    } else {
      file.createSync();
      _writeFile(file, key, data);
    }
    if (!keys.contains(key)) {
      keys.add(key);
    }
    dispatch(key, data);
    return new Future.value();
  }

  void add(String key, data) {
    List list = new List();
    if (keys.contains(key)) {
      Object obj = getItem(key).then((obj) {
        if (obj is List) {
          list = obj;
          _add(list, key, data);
        }
      });
    } else {
      _add(list, key, data);
    }
  }

  void _add(List list, String key, data) {
    list.add(data);

    setItem(key, list);
  }

  void _writeFile(File file, key, data) {
    file.writeAsStringSync(JSON.encode(data));
  }

  void removeItem(String key) {
    var uriKey = new Uri.file(pathToStore).resolve("$key.json");
    var file = new File(uriKey.toFilePath());

    file.delete().then((File file) {
      dispatch_removed(key);
      log.info("item $key deleted successfully");
    });
  }

  Map exportSync() {
    Map values = new Map();
    for (var key in keys) {
      values[key] = getItemSync(key);
    }
    return values;
  }
  
  Future<Map> export() {
        Completer complete = new Completer();
        
        Map values = new Map();
        
        Directory dir = new Directory(pathToStore);
        dir.list(recursive: true, followLinks: false).listen((FileSystemEntity entity) {
          var path = entity.path;

          if (path.indexOf(".json") > 1) {
            var fileName = path.split('\\').last;
            fileName = fileName.replaceAll(".json", '');
            var key = fileName.toString();
            
            values[key] = getItemSync(key);
          }
        }).onDone(() {
          complete.complete(values);
        });
        return complete.future;
    }

  void clear() {
    Directory dir = new Directory(pathToStore);

    dir.list(recursive: true, followLinks: false).listen((FileSystemEntity entity) {
      var path = entity.path;
      if (path.indexOf(".json") > 1) {
        log.info("deleting $path");
        var file = new File(path);
        try {
          file.deleteSync();
        } on Exception catch (e) {
          print('Unknown exception: $e');
          var fileName = path.split('\\').last;
          fileName = fileName.replaceAll(".json", '');
          readStreams[fileName].then((_) => file.deleteSync());
        }
      }
    });
    keys.clear();
  }

  Future<int> length() {
      Completer complete = new Completer();
      int count = 0;
      Directory dir = new Directory(pathToStore);
      dir.list(recursive: false, followLinks: false).listen((FileSystemEntity entity) {
        var path = entity.path;
        if (path.indexOf(".json") > 1) { 
            count++;
        }
      }).onDone(() {
         complete.complete(count);
      });
      return complete.future;
    }

  void _readInKeys(Completer complete) {
    Directory dir = new Directory(pathToStore);
    dir.list(recursive: true, followLinks: false).listen((FileSystemEntity entity) {
      var path = entity.path;

      if (path.indexOf(".json") > 1) {
        var fileName = path.split('\\').last;
        fileName = fileName.replaceAll(".json", '');
        keys.add(fileName.toString());
      }
    }).onDone(() {
      complete.complete();
    });
  }

  Future start() => _completer.future;
}
