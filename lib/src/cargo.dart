part of cargo;

abstract class CargoBase {
  Completer _completer;

  /// Get an item synchronously
  dynamic getItemSync(String key);

  /// Get an item asynchronously
  Future getItem(String key);

  /// Set/update an item synchronously
  void setItem(String key, data);
  
  /// Add item synchronously
  void add(String key, data);

  /// Remove/delete an item synchronously
  void removeItem(String key);

  /// Clear cargo storage
  void clear();

  /// Get the total number of items in cargo storage
  int length();

  void operator []=(String key, value) {
    setItem(key, value);
  }

  dynamic operator [](String key){
    return getItemSync(key);
  }

  Future start() => _completer.future;
}

