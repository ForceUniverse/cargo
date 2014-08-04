part of cargo_client;

class LocalstorageCargo extends Cargo {
  Completer _completer;
  Storage values;
 
  LocalstorageCargo(this.values) : super._() {
    _completer = new Completer();
    _completer.complete();
  }

  dynamic getItemSync(String key) {
    return JSON.decode(values[key]);
  }

  Future getItem(String key) {
    Completer complete = new Completer();
    complete.complete(JSON.decode(values[key]));
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

  Future start() => _completer.future;
}

