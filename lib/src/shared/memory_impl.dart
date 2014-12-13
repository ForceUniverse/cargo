part of cargo;

class MemoryImpl extends CargoBase with CargoDispatch {
  Completer _completer;
  Map global = new Map();
  Map values = new Map();

  MemoryImpl() {
    _completer = new Completer();
    _completer.complete();
    
    collection = "base";
    global["base"] = values;
  }
  
  Future withCollection(collection) {
    if (global[collection]==null) {
      global[collection] = new Map();
    }
    values = global[collection]; 
    return new Future.value();
  }

  dynamic getItemSync(String key, {defaultValue}) {
    if (values[key]==null && defaultValue!=null) {
      values[key]=defaultValue;
    }
    return values[key];
  }

  Future getItem(String key, {defaultValue}) {
    return new Future.sync(getItemSync(key, defaultValue: defaultValue));
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
    dispatch_removed(key); 
  }

  void clear() {
    values.clear();
  }

  Future<int> length() {
    return new Future.sync(() => values.length);
  }
  
  Map exportSync() {
    return values;
  } 
  
  Future<Map> export() {
    return new Future.sync(() => values);
  }

  Future start() => _completer.future;
}

