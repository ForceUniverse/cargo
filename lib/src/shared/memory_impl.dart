part of cargo;

class MemoryImpl extends CargoBase with CargoDispatch {
  Completer _completer;
  Map values = new Map();

  MemoryImpl() {
    _completer = new Completer();
    _completer.complete();
  }

  dynamic getItemSync(String key, {defaultValue}) {
    if (values[key]==null && defaultValue!=null) {
      values[key]=defaultValue;
    }
    return values[key];
  }

  Future getItem(String key, {defaultValue}) {
    Completer complete = new Completer();
    complete.complete(getItemSync(key, defaultValue: defaultValue));
    return complete.future;
  }

  void setItem(String key, data) {
    values[key] = data;
    
    dispatch(key, data);
  }
  
  void add(String key, data) {
    List list = new List(); 
    if (values.containsKey(key)) {
      if (values[key] is List) {
        list = values[key];
      }
    }
    _add(list, key, data);
   }
  
  void _add(List list, String key, data) {
      list.add(data);
      
      dispatch(key, list);
      values[key] = list;
  }

  void removeItem(String key) {
    values.remove(key);
  }

  void clear() {
    values.clear();
  }

  Future<int> length() {
    Completer complete = new Completer();
    complete.complete(values.length);
    return complete.future;
  }
  
  Map exportSync() {
    return values;
  } 
  
  Future<Map> export() {
    Completer complete = new Completer();
    complete.complete(values);
    return complete.future;
  }

  Future start() => _completer.future;
}

