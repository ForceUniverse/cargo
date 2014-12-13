part of cargo_server;

class FileCargo extends Cargo {
  Completer _completer;
  final Logger log = new Logger('JsonStorage');
  String pathToStore;
  String baseDir;
  
  List<String> keys = new List<String>();

  FileCargo(this.baseDir) : super._() {
    _setNewStoreDir();
    _completer = new Completer();

    _readInKeys(_completer);
  }
  
  void _setNewStoreDir() {
    String dir = baseDir;
    if (collection!= "") {
      dir = "$dir/$collection/";
    } else {
      dir = "$dir/";
    }
    pathToStore = Platform.script.resolve(dir).toFilePath();
    
    if (!_exists(pathToStore)) {
      Directory directory = new Directory(dir);
      directory.createSync();
    }
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

      file.exists().then((bool exist) {
        // Need to convert it to json!
        if (exist) {
          file.readAsString().then((String fileValues) {
            complete.complete(JSON.decode(fileValues));
          });
        } else {
          _setDefaultValue(key, defaultValue);
          complete.complete(defaultValue);
        }
      });
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

  void setItem(String key, data) {
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
        }
      }
    });
    keys.clear();
  }

  Future<int> length() {
      Completer complete = new Completer();
      int count = 0;
      Directory dir = new Directory(pathToStore);
      dir.list(recursive: true, followLinks: false).listen((FileSystemEntity entity) {
         count++;
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
