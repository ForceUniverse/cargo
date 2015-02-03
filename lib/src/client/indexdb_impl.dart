part of cargo_client;

class IndexDbCargo extends Cargo {
  String dbName;
  
  bool _isOpen;

  int count = 0;

  Set<String> keys = new Set<String>();

  /// Returns true if IndexedDB is supported on this platform.
  static bool get supported => IdbFactory.supported;

  static Map<String, Database> _databases = new Map<String, Database>();

  IndexDbCargo(this.dbName, storeName) : super._() {
    this.collection = storeName;
  }
  
  CargoBase instanceWithCollection(String collection) {
    return new IndexDbCargo(this.dbName, collection);
  }

  dynamic getItemSync(String key, {defaultValue}) {
    throw new UnsupportedError('IndexedDB is not supporting synchronous retrieval of data, we will add this feature when await key is available in Dart');
  }

  Future getItem(String key, {defaultValue}) {
    Completer complete = new Completer();
    
    _doCommand((ObjectStore store) {
      store.getObject(key).then((obj) {
        if (obj == null) {
           if (defaultValue != null) {
              setItem(key, defaultValue);
           }
           return complete.complete(defaultValue);
        } else {
          complete.complete(obj);
        }
      });
    }, 'readonly');
    
    return complete.future;
  }

  Future setItem(String key, data) {
    return _doCommand((ObjectStore store) {
      dispatch(key, data);
      this.keys.add(key);
      return store.put(data, key);
    });

  }

  void add(String key, data) {
    _doCommand((ObjectStore store) {
      store.getObject(key).then((obj) {
        if (obj is List) {
          List list = obj;
          list.add(data);

          dispatch(key, list);
          return store.put(key, list);
        }

      }, onError: (e) {
        List list = new List();
        list.add(data);

        dispatch(key, list);
        this.keys.add(key);
        return store.put(key, list);
      });
    });

  }

  void removeItem(String key) {
    _doCommand((ObjectStore store) {
      store.delete(key);
      this.keys.remove(key);
      
      dispatch_removed(key); 
    });
  }

  Future clear() {
    return _doCommand((ObjectStore store) {
      store.clear();
      this.keys.clear();
    });
  }

  Future<int> length() {
    Future<int> future;
    _doCommand((ObjectStore store) {
          future = store.count();
        });
    return future;
  }

  Future _doCommand(Future requestCommand(ObjectStore store), [String txnMode = 'readwrite']) {
    var completer = new Completer();
    var trans = _db.transaction(collection, txnMode);
    var store = trans.objectStore(collection);
    var future = requestCommand(store);
    return trans.completed.then((_) => future);
  }
  
  Future withCollection(collection) {
    //print("Newly opened db $dbName has version ${db.version} and stores ${db.objectStoreNames}");
    this.collection = collection;
    return start();
  }

  Future start() {
    if (!supported) {
          return new Future.error(
            new UnsupportedError('IndexedDB is not supported on this platform'));
        }
        
        if (_db != null) {
          _db.close();
        }
        
        return window.indexedDB.open(dbName)
        .then((Database db) {
          //print("Newly opened db $dbName has version ${db.version} and stores ${db.objectStoreNames}");
          if (!db.objectStoreNames.contains(collection)) {
            db.close();
            //print('Attempting upgrading $storeName from ${db.version}');
            return window.indexedDB.open(dbName, version: db.version + 1,
              onUpgradeNeeded: (e) {
                print('Upgrading db $dbName to ${db.version + 1}');
                Database d = e.target.result;
                d.createObjectStore(collection);
              }
            );
          } else {
            //print('The store $storeName exists in $dbName');
            return db;
          }
        })
        .then((db){
          _databases[dbName] = db;
          _isOpen = true;
          return true;
        });
  }

  Map exportSync({Map params, Options options}) {
    Map values = new Map();
    Set<String> keysSortedOut = sortOutKeys(options);
    for (var key in keysSortedOut) {
      var value = getItemSync(key);
      values = _filter(values, params, key, value);
    }
    return values;
  }
  
  Iterable sortOutKeys(Options options) {
     if (options != null && options.limit!=-1) {
         return keys.take(options.limit);
     } 
     return keys;
  }
  
  Future<Map> export({Map params, Options options}) {
    Completer complete = new Completer();
    Map values = new Map();
    _doCommand((ObjectStore store) {
          Stream<CursorWithValue> openCursor = store.openCursor();
          if (options!=null && options.hasLimit()) {
              openCursor = openCursor.take(options.limit);
          }
          
          openCursor.listen((CursorWithValue cwv) {
            values = _filter(values, params, cwv.key, cwv.value);
          }).onDone(() {
            complete.complete(values);
          });;
        });
    return complete.future;
  }
  
  Map _filter(Map values, Map params, key, value) {
     if (value is Map) {
         Map examen_value = value;
                 
         if (containsByOverlay(examen_value, params)) {
             values[key] = value;
         }
     } else {
       values[key] = value;
     }
     return values;
   }

  Database get _db => _databases[dbName];
}
