part of cargo;

class JsonStorage extends Storage {
  
  String path;

  JsonStorage (String this.path) : super._();
  
  dynamic getItem(String key) {
    return null;
  }
  
  void setItem(String key, data) {
    
  }
  
  void removeItem(String key) {
     
  }
  
  void clear() {
    
  }
  
  int length() {
    return 0;
  }
}