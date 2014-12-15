part of cargo_client;

class LocalstorageCargo extends Cargo {
  Completer _completer;
  Storage values;

  LocalstorageCargo(this.values) : super._() {
    _completer = new Completer();
    _completer.complete();
  }

  dynamic getItemSync(String key, {defaultValue}) {
    key = "$collection$key";
    
    _checkDefault(key, defaultValue: defaultValue);
    return values[key] is String ? JSON.decode(values[key]) : values[key];
  }

  void _checkDefault(String key, {defaultValue}) {
    key = "$collection$key";
    
    if (values[key] == null && defaultValue != null) {
      setItem(key, defaultValue);
    }
  }

  Future getItem(String key, {defaultValue}) {
    key = "$collection$key";
    
    return new Future.value(getItemSync(key, defaultValue: defaultValue));
  }

  Future setItem(String key, data) {
    key = "$collection$key";
    
    _setItem(key, data);
    return new Future.value();
  }

  void _setItem(String key, data) {
    values[key] = JSON.encode(data);

    dispatch(key, data);
  }


  void add(String key, data) {
    List list = new List();
    if (values.containsKey(key)) {
      Object obj = JSON.decode(values[key]);
      if (obj is List) {
        list = JSON.decode(values[key]);
      }
    }
    _add(list, key, data);
  }

  void _add(List list, String key, data) {
    list.add(data);

    _setItem(key, list);
  }

  void removeItem(String key) {
    key = "$collection$key";
        
    _removeItem(key);
  }
  
  void _removeItem(String key) {
    values.remove(key);
    dispatch_removed(key);
  }

  void clear() {
    values.clear();
  }

  Future<int> length() {
    int count = 0;
    if (collection=="") {
      count = values.length;
    } else {
      values.forEach((key, value) {
        if (key.startsWith(collection)) {
          count++;
        }
      });
    }
    return new Future.sync(() => count);
  }

  Map exportSync() {
    return values;
  }
  
  Future<Map> export() {
    return new Future.sync(() => values);
  }

  Future start() => _completer.future;
}
