part of cargo_client;

class LocalstorageCargo extends Cargo {
  Completer _completer;
  Storage values;
 
  LocalstorageCargo(this.values) : super._() {
    _completer = new Completer();
    _completer.complete();
  }

  dynamic getItemSync(String key) {
    return values[key];
  }

  Future getItem(String key) {
    Completer complete = new Completer();
    complete.complete(values[key]);
    return complete.future;
  }

  void setItem(String key, data) {
    values[key] = data;
    
    dispatch(key, data);
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

  Future start() => _completer.future;
}

