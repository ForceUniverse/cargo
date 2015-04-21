part of cargo_server;

class FileCargo extends Cargo {
  final Logger log = new Logger('JsonStorage');
  String pathToStore;
  String baseDir;
  
  Map<String, Future> readStreams = new Map<String, Future>();
  
  Set<String> keys = new Set<String>();

  FileCargo(this.baseDir, {collection: ""}) : super._() {
    this.collection = collection;
    
    _setNewStoreDir();
  }
  
  Future withCollection(collection) async {
      this.collection = collection;
      _setNewStoreDir();
      
      return await _readInKeys();
  }
  
  CargoBase instanceWithCollection(String collection) {
    return new FileCargo(this.baseDir, collection: collection);
  }
  
  void _setNewStoreDir() {
    String dir = baseDir;
    if (collection!= "") {
      dir = "$dir/$collection/";
    } 
    if (!dir.endsWith("/")) {
      dir = "$dir/";
    }
    pathToStore = Platform.script.resolve(dir).toFilePath();
    
    if (!_exists(pathToStore)) {
      Directory directory = new Directory(pathToStore);
      directory.createSync();
    }
    log.info("new path to store $pathToStore");
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
          var encodedPath = Uri.encodeComponent("$key.json");
          var uriKey = new Uri.file("$pathToStore$encodedPath");
          var file = new File(uriKey.toFilePath());

          if (file.existsSync()) {
            // need to convert it to json!
            return JSON.decode(file.readAsStringSync());
          }
     }
     _setDefaultValue(key, defaultValue);
     return defaultValue;
  }

  Future _getItem(String key, {defaultValue}) async {
    var result;
    
    if (keys.contains(key)) {
      var encodedPath = Uri.encodeComponent("$key.json");
      var uriKey = new Uri.file("$pathToStore$encodedPath");
      var file = new File(uriKey.toFilePath());

      // Need to convert it to json!
      if (file.existsSync()) {
          Stream stream = file.openRead();
          
          // create completer to close stream
          await for (String data in stream
              .transform(UTF8.decoder))  {
            result = JSON.decode(data);
          } // output the data
      } else {
          _setDefaultValue(key, defaultValue);
      }
    } else {
      _setDefaultValue(key, defaultValue);
    }

    return result;
  }
  
  Future getItem(String key, {defaultValue}) {
    Future value = _getItem(key, defaultValue: defaultValue);
    readStreams[key] = value;
    return value;
  }

  void _setDefaultValue(String key, defaultValue) {
    if (defaultValue != null) {
      setItem(key, defaultValue);
    }
  }

  Future setItem(String key, data) {
    var encodedPath = Uri.encodeComponent("$key.json");
    var uriKey = new Uri.file("$pathToStore$encodedPath");

    _writeFileWithCheck(new File(uriKey.toFilePath()), data);
    _addToKeys(key);
    
    dispatch(key, data);
    
    return new Future.value();
  }
  
  _addToKeys(key) {
    keys.add(key);
    
    // save keys
    _writeFileWithCheck(_keys_of_collection_file(), keys.toList());
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

  void _writeFileWithCheck(File file, data) {
    if (file.existsSync()) {
       _writeFile(file, data);
    } else {
       if (file.parent.existsSync()) {
         file.parent.createSync();
       }
       file.createSync();
       _writeFile(file, data);
    }
  }
  
  void _writeFile(File file, data) {
    file.writeAsStringSync(JSON.encode(data));
  }

  void removeItem(String key) {
    var encodedPath = Uri.encodeComponent("$key.json");
    var uriKey = new Uri.file("$pathToStore$encodedPath");
    var file = new File(uriKey.toFilePath());

    file.delete().then((File file) {
      dispatch_removed(key);
      log.info("item $key deleted successfully");
    });
  }

  Map exportSync({Map params, Options options}) {
    Map values = new Map();
    Iterable keysSortedOut = sortOutKeys(options);
    for (var key in keysSortedOut) {
      var value = getItemSync(key);
      values = _filter(values, params, key, value);
    }
    return values;
  }
  
  Future<Map> export({Map params, Options options}) {
    // TODO: look at a sync approach, fix this with the await feature!
    return new Future.sync(() => exportSync(params: params, options: options));
  }

  Map _filter(Map values, Map params, key, value) {
    if (value is Map) {
        Map examen_value = value;
                
        if (containsByOverlay(examen_value, params)) {
            values[key] = value;
        }
    } else {
      values[key] = value;
    }
    return values;
  }
  
  Iterable sortOutKeys(Options options) {
      Iterable retKeys = keys.toList();
      if (options != null) { 
        if (options.revert) {
          retKeys = keys.toList().reversed;
        }
        if (options.hasLimit()) {
          retKeys = retKeys.take(options.limit);
        }
      } 
      return retKeys.toSet();
    }
  
  Future clear() async {
    Directory dir = new Directory(pathToStore);
    bool exists = await dir.exists();
    if (exists) {
        await for (FileSystemEntity entity in dir.list(recursive: false, followLinks: false)) {
          if (entity.existsSync()) { 
            try {
                await entity.delete(recursive: true);
             } catch (e) {
                var fileName = entity.path.split('\\').last;
                fileName = fileName.replaceAll(".json", '');
                if (readStreams[fileName] != null) {
                  await readStreams[fileName];
                  await entity.delete();
                }
             }
          }
        }
    }
    
    keys.clear();
    // _writeFileWithCheck(_keys_of_collection_file(), keys.toList());
  }

  Future<int> length() async {
      Stream files = _files();
      return await files.length;
  }
  
  Stream<FileSystemEntity> _files() async* {
    try {
      Directory dir = new Directory(pathToStore);
      bool exists = await dir.exists();
      if (exists) {
        await for (FileSystemEntity entity in dir.list(recursive: false, followLinks: false)) {
            var path = entity.path;
            if (path.indexOf(".json") > 1) {
                yield entity;
            }
        }
      }
    } catch (e) { }
  }

  Future _readInKeys() async {
    var file = _keys_of_collection_file();
    
    // reset keys
    keys.clear();

    // Need to convert it to json!
    if (file.existsSync()) {
        Stream stream = file.openRead();
              
        await for(String data in stream
                  .transform(UTF8.decoder)) {
                List dataKeys = JSON.decode(data); // output the data
                keys = dataKeys.toSet();
        }
    }
    return keys;
  }

  File _keys_of_collection_file() {
    var encodedPath = Uri.encodeComponent("keys_of_collection.index");
    var uriKey = new Uri.file("$pathToStore$encodedPath");
    return new File(uriKey.toFilePath());
  }
  
  Future start() async {
    return await _readInKeys();
  }
}
