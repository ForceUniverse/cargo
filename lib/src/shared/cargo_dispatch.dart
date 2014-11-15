part of cargo;

typedef DataChangeListener(DataEvent de);

class DataEvent {
  dynamic key;
  dynamic data;
  
  DataEvent(this.key, this.data);
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
    if (mapping[key]!=null) {
      List<DataChangeListener> cargoDataChangerList = mapping[key];
      
      DataEvent dataEvent = new DataEvent(key, value);
      for (DataChangeListener dataChangeListener in cargoDataChangerList) {
        dataChangeListener(dataEvent);
      }
      if (this._cargoDataChange!=null) this._cargoDataChange(dataEvent);
    }
  }
  
}