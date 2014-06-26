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
  
  String getItem(String key);
  void setItem(String key, data);
  void removeItem(String key);
  void clear();
  int length();
  
  Future start() => _completer.future;
}