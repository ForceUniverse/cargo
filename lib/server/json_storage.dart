part of cargo;

class JsonStorage extends Storage {
  final Logger log = new Logger('JsonStorage');
  String pathToStore;

  List<String> keys = new List<String>();
  
  JsonStorage (String dir) : super._() {
    pathToStore = Platform.script.resolve(dir).toFilePath();
    _completer = new Completer();
    
    _exists(pathToStore);
    
    _readInKeys();
  }
  
  void _exists(dir) {
      try {
        if (!new Directory(dir).existsSync()) {
           log.severe("The '$dir' directory was not found.");
        }
      } on FileSystemException {
        log.severe("The '$dir' directory was not found.");
      }
    }
  
  dynamic getItem(String key) {
    if (keys.contains(key)) {
      var uriKey = new Uri.file(pathToStore).resolve("$key.json");
      var file = new File(uriKey.toFilePath());
          
      if (file.existsSync()) {
        // need to convert it to json!
        return JSON.decode(file.readAsStringSync());
      }
    }
    return null;
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
    keys.add(key);
  }
  
  void _writeFile (File file, key, data) {
    file.writeAsStringSync(JSON.encode(data));
  }
  
  void removeItem(String key) {
    var uriKey = new Uri.file(pathToStore).resolve("$key.json");
    var file = new File(uriKey.toFilePath());
    
    file.delete().then((File file) {
      log.info("item $key deleted successfully");
    });
  }
  
  void clear() {
    Directory dir = new Directory(pathToStore);
    dir.list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
          var path = entity.path;
          if (path.indexOf(".json") > 1) {
            log.info("deleting $path");
            var file = new File(path);
            file.deleteSync();
          }
        });
  }
  
  int length() {
    return keys.length;
  }
  
  void _readInKeys() {
    Directory dir = new Directory(pathToStore);
        dir.list(recursive: true, followLinks: false)    
        .listen((FileSystemEntity entity) {
              var path = entity.path;
              if (path.indexOf(".json") > 1) {
                keys.add(path);
              }
            }).onDone(() {
                _completer.complete();         
            });
  }
}