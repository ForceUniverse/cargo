part of cargo;

abstract class Storage {
  
  Completer _completer;
  
  // For subclasses
  Storage._();
  
  factory Storage({String path: null}) {
   print("choose a storage implementation");
   if (path!=null) {
     return new JsonStorage(path);
   } else {
     return new MemoryStorage();
   }
  }
  
  dynamic getItemSync(String key);
  Future getItem(String key);
  void setItem(String key, data);
  void removeItem(String key);
  void clear();
  int length();
  
  void operator []=(String key, value) {
      setItem(key, value);
  }
  dynamic operator [](String key){
    return getItemSync(key);
  }
  
  
  Future start() => _completer.future;
}