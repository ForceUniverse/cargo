part of cargo;

Map queryMap(Map values, Map params) {
  Map newValues = new Map();
  
  for ( var key in values.keys) {
        var value = values[key];
    if (value is String) {
      value = JSON.decode(value);
    }
        
    if (value is Map) {
      Map examen_value = value;
      
      if (containsByOverlay(examen_value, params)) {
         newValues[key] = value;
      }
    } else {
      // use mirrors in the future
      newValues[key] = value;
    }
  }
  return newValues;
}

Map lookAtOptions(Map map, Options options) {
    Map returnValues = new Map();
    if (options != null) {
      if (options.revert) {
        map = revertMap(map);
      }
      if (options.hasLimit()) {
        var keys = map.keys.take(options.limit);
        for (var key in keys) {
          returnValues[key] = map[key];
        }
      }
    } else {
      returnValues = map;
    }
    return returnValues;
}

Map revertMap(Map map) {
  Map revertedMap = new Map();
  var keys = map.keys;
  for (var j=map.length; j>=0; j--){
    var key = keys.elementAt(j);
    revertedMap[key] = map[key];
  }
  return revertedMap;
}

bool containsByOverlay(Map examen_values, Map params) {
     bool maps_correct = true; 
     
     if (params!=null) {
       for ( var key in params.keys) {
         var value = params[key];
         if (examen_values[key]!=null) {
             if (examen_values[key] is Map && value is Map) {
               if (!containsByOverlay(examen_values[key], value)) {
                 return false;
               }
             } else {
               if (examen_values[key]!=value) {
                 return false;
               }
             }
         } 
       }
     }
     return maps_correct;
}

Map filterCollection(Map coll, collection) {
    if (collection!=null) {
      Map newValues = new Map();
      for ( var key in coll.keys) {
            var value = coll[key];
            if (key.startsWith(collection)) {
                String newKey = key.replaceAll(collection, '');
                newValues[newKey] = value;
            } 
      }
      return newValues;
    } else {
      return coll;
    }
}