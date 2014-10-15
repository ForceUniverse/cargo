part of cargo_client;

class LocalstorageCargo extends Cargo {
  Completer _completer;
  Storage values;

  LocalstorageCargo(this.values) : super._() {
    _completer = new Completer();
    _completer.complete();
  }

  dynamic getItemSync(String key, {defaultValue}) {
    _checkDefault(key, defaultValue: defaultValue);
    return values[key] is String ? JSON.decode(values[key]) : values[key];
  }

  void _checkDefault(String key, {defaultValue}) {
    if (values[key] == null && defaultValue != null) {
      setItem(key, defaultValue);
    }
  }

  Future getItem(String key, {defaultValue}) {
    Completer complete = new Completer();
    complete.complete(getItemSync(key, defaultValue: defaultValue));
    return complete.future;
  }

  void setItem(String key, data) {
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

    setItem(key, list);
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

  Map export() {
    return values;
  }

  Future start() => _completer.future;
}
