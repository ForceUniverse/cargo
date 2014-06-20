part of cargo;

class JsonStorage extends Storage {
  final Logger log = new Logger('JsonStorage');
  String pathToStore;
  
  JsonStorage (String dir) : super._() {
    pathToStore = Platform.script.resolve(dir).toFilePath();
 
    _exists(pathToStore);
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
    var uriKey = new Uri.file(pathToStore).resolve("$key.json");
    var file = new File(uriKey.toFilePath());
        
    if (file.existsSync()) {
      // need to convert it to json!
      return JSON.decode(file.readAsStringSync());
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
          log.info("deleting $path");
          var file = new File(path);
          file.deleteSync();
        });
  }
  
  int length() {
    // TODO: find good implementation
    return 0;
  }
}