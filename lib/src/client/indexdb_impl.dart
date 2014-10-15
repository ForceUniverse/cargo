part of cargo_client;

class IndexDbCargo extends Cargo {
  String dbName;
  String storeName;

  bool _isOpen;

  int count = 0;

  List<String> keys = new List<String>();

  /// Returns true if IndexedDB is supported on this platform.
  static bool get supported => IdbFactory.supported;

  static Map<String, Database> _databases = new Map<String, Database>();

  IndexDbCargo(this.dbName, this.storeName) : super._();

  dynamic getItemSync(String key, {defaultValue}) {
    throw new UnsupportedError('IndexedDB is not supporting synchronous retrieval of data, we will add this feature when await key is available in Dart');
  }

  Future getItem(String key, {defaultValue}) {
    return _doCommand((ObjectStore store) {
      var obj = store.getObject(key);
      if (obj == null) {
        if (defaultValue != null) {
          setItem(key, defaultValue);
        }
        return defaultValue;
      }
    }, 'readonly');
  }

  void setItem(String key, data) {
    _doCommand((ObjectStore store) {
      dispatch(key, data);
      this.keys.add(key);
      return store.put(key, data);
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
    });
  }

  void clear() {
    _doCommand((ObjectStore store) {
      store.clear();
      this.keys.clear();
    });
  }

  int length() {
    throw new UnsupportedError('IndexedDB is not supporting length retrieval synchronously');
  }

  Future _doCommand(Future requestCommand(ObjectStore store), [String txnMode = 'readwrite']) {
    var completer = new Completer();
    var trans = _db.transaction(storeName, txnMode);
    var store = trans.objectStore(storeName);
    var future = requestCommand(store);
    return trans.completed.then((_) => future);
  }

  Future start() {
    if (!supported) {
      return new Future.error(new UnsupportedError('IndexedDB is not supported on this platform'));
    }

    return window.indexedDB.open(dbName).then((Database db) {
      //print("Newly opened db $dbName has version ${db.version} and stores ${db.objectStoreNames}");
      if (!db.objectStoreNames.contains(storeName)) {
        db.close();

        print('Attempting upgrading $storeName from ${db.version}');

        return window.indexedDB.open(dbName, version: 1, onUpgradeNeeded: (e) {
          //print('Upgrading db $dbName to ${db.version + 1}');
          Database d = e.target.result;
          d.createObjectStore(storeName);
        });
      } else {
        //print('The store $storeName exists in $dbName');
        return db;
      }
    }).then((db) {
      _databases[dbName] = db;
      _isOpen = true;
      return true;
    });
  }

  Map export() {
    Map values = new Map();
    for (var key in keys) {
      values[key] = getItemSync(key);
    }
    return values;
  }

  Database get _db => _databases[dbName];
}
