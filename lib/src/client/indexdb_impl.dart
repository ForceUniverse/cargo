part of cargo_client;

class IndexDbCargo extends Cargo {
  String dbName;
  String storeName;
  
  bool _isOpen;
  
  int count = 0;
 
  /// Returns true if IndexedDB is supported on this platform.
  static bool get supported => IdbFactory.supported;
  
  static Map<String, Database> _databases = new Map<String, Database>();
  
  IndexDbCargo(this.dbName, this.storeName) : super._();

  dynamic getItemSync(String key) {
    throw new UnsupportedError('IndexedDB is not supporting synchronous retrieval of data');
  }

  Future getItem(String key) {
    return _doCommand((ObjectStore store) => store.delete(key));
  }

  void setItem(String key, data) {
    _doCommand((ObjectStore store) {
       return store.put(key, data);
    });
    
    dispatch(key, data);
  }

  void removeItem(String key) {
    _doCommand((ObjectStore store) => store.delete(key));
  }

  void clear() {
    _doCommand((ObjectStore store) => store.clear());
  }

  int length() {
    throw new UnsupportedError('IndexedDB is not supporting length retrieval synchronously');
  }
  
  Future _doCommand(Future requestCommand(ObjectStore store),
               [String txnMode = 'readwrite']) {
      var completer = new Completer();
      var trans = _db.transaction(storeName, txnMode);
      var store = trans.objectStore(storeName);
      var future = requestCommand(store);
      return trans.completed.then((_) => future);
  }

  Future start() {
    if (!supported) {
        return new Future.error(
        new UnsupportedError('IndexedDB is not supported on this platform'));
    }
        
    return window.indexedDB.open(dbName)
        .then((Database db) {
          //print("Newly opened db $dbName has version ${db.version} and stores ${db.objectStoreNames}");
          if (!db.objectStoreNames.contains(storeName)) {
            db.close();
            //print('Attempting upgrading $storeName from ${db.version}');
            return window.indexedDB.open(dbName,
              onUpgradeNeeded: (e) {
                //print('Upgrading db $dbName to ${db.version + 1}');
                Database d = e.target.result;
                d.createObjectStore(storeName);
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
  
  Database get _db => _databases[dbName];
}