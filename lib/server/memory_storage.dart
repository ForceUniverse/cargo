part of cargo;

class MemoryStorage extends Storage {
  
  Map values = new Map();
  
  MemoryStorage () : super._() {
    _completer = new Completer();
    _completer.complete();
  }
  
  dynamic getItem(String key) {
    return values[key];
  }
  
  void setItem(String key, data) {
    values[key] = data;
  }
  
  void removeItem(String key) {
      values.remove(key);
  }
  
  void clear() {
    values.clear();
  }
  
  int length() {
    return values.length;
  }
}