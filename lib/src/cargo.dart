part of cargo;

abstract class CargoBase extends Object with CargoDispatch {
  Completer _completer;

  String collection = "";
  
  Future withCollection(String collection) {
    this.collection = collection;
    return new Future.value();
  }
  
  CargoBase instanceWithCollection(String collection);
  
  /// Get an item synchronously
  dynamic getItemSync(String key, {defaultValue});

  /// Get an item asynchronously
  Future getItem(String key, {defaultValue});

  /// Set/update an item synchronously
  Future setItem(String key, data);

  /// Add item synchronously
  void add(String key, data);

  /// Remove/delete an item synchronously
  void removeItem(String key);

  /// Clear cargo storage
  void clear();

  /// Get the total number of items in cargo storage
  Future<int> length();

  void operator []=(String key, value) {
    setItem(key, value);
  }

  dynamic operator [](String key) {
    return getItemSync(key);
  }

  Map exportSync();
  
  Future<Map> export();

  CargoBase copyTo(CargoBase storage) {
    this.exportSync().forEach((key, value) => storage.add(key, value));
    return storage;
  }

  Future start() => _completer.future;
}
