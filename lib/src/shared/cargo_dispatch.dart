part of cargo;

typedef DataChangeListener(DataEvent de);

class DataEvent {
  dynamic data;
  
  DataEvent(this.data);
}

class CargoDispatch {
  
  Map<String, List<DataChangeListener>> mapping = new Map<String, List<DataChangeListener>>();
  
  on(String key, DataChangeListener cargoDataChange) {
    List<DataChangeListener> cargoDataChangerList = new List<DataChangeListener>();
    if (mapping[key]!=null) {
      cargoDataChangerList = mapping[key];
    } else {
      mapping[key] = cargoDataChangerList;
    }
    cargoDataChangerList.add(cargoDataChange);
  }
  
  dispatch(String key, value) {
    if (mapping[key]!=null) {
      List<DataChangeListener> cargoDataChangerList = mapping[key];
      
      for (DataChangeListener dataChangeListener in cargoDataChangerList) {
        dataChangeListener(new DataEvent(value));
      }
    }
  }
}