part of cargo;

typedef DataChangeListener(DataEvent de);

class DataType {
  final String _type;

  const DataType(this._type);

  static const CHANGED = const DataType('Changed');
  static const REMOVED = const DataType('Removed');

  toString() => "$_type";
}

class DataEvent {
  dynamic key;
  dynamic data;
  DataType type;
  
  DataEvent(this.key, this.data, this.type);
  
}

class CargoDispatch {
  
  Map<String, List<DataChangeListener>> mapping = new Map<String, List<DataChangeListener>>();
  
  DataChangeListener _cargoDataChange;
  
  on(String key, DataChangeListener cargoDataChange) {
    List<DataChangeListener> cargoDataChangerList = new List<DataChangeListener>();
    if (mapping[key]!=null) {
      cargoDataChangerList = mapping[key];
    } else {
      mapping[key] = cargoDataChangerList;
    }
    cargoDataChangerList.add(cargoDataChange);
  }
  
  onAll(DataChangeListener cargoDataChange) => this._cargoDataChange = cargoDataChange;
  
  off(String key, DataChangeListener cargoDataChange) {
    if (mapping[key]!=null) {
        mapping[key].remove(cargoDataChange);
    }
  }
  
  offAll(String key) {
    mapping.remove(key);
  }
   
  dispatch(String key, value) {
    DataEvent dataEvent = new DataEvent(key, value, DataType.CHANGED);
    
    this._innerDispatch(dataEvent, key);
  }
  
  dispatch_removed(String key) {
      DataEvent dataEvent = new DataEvent(key, null, DataType.REMOVED);
      
      this._innerDispatch(dataEvent, key);
  }
  
  _innerDispatch(DataEvent dataEvent, key) {
    if (mapping[key]!=null) {
          List<DataChangeListener> cargoDataChangerList = mapping[key];
          
          for (DataChangeListener dataChangeListener in cargoDataChangerList) {
            dataChangeListener(dataEvent);
          }
     }
     if (this._cargoDataChange!=null) this._cargoDataChange(dataEvent);
  }
  
}