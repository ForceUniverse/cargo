import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_base.dart';

void main() {
  // First tests!
  
  var date1 = {'day': 19, 'month': 12, 'year': 2014};
  var date2 = {'day': 21, 'month': 12, 'year': 2014};
  
  Map values = new Map();
  
  values['YO'] = {'name': 'Yo', 'url': 'http://www.justyo.co/', 'point': 2, 'date': date1};
  values['Uber'] = {'name': 'Uber', 'url': 'http://www.uber.com/', 'point': 1, 'date': date2};
  values['Snapchat'] = {'name': 'SnapChat', 'url': 'https://www.snapchat.com/', 'point': 3, 'date': date2};
  values['Facebook'] = {'name': 'Facebook', 'url': 'https://www.facebook.com/', 'point': 1, 'date': date2};  
  values['Medium'] = {'name': 'Medium', 'url': 'https://www.medium.com/', 'point': 1, 'date': date1};
  
  Map params = new Map();
  params['date'] = date1;
  
  Map params2 = new Map();
  params2['point'] = 1;
  params2['date'] = date2;
  
  test('test contains positive', () {
    expect(containsByOverlay(values['YO'], params), true);
  });
  
  test('test contains negative', () {
    expect(containsByOverlay(values['YO'], params2), false);
  });
  
  test('test query map', () {
    Map queryResult = queryMap(values, params2);
    expect(queryResult.length, 2);
    expect(queryResult['Uber']['name'], 'Uber');
  });
  
  test('test query map with params null', () {
      Map queryResult = queryMap(values, null);
      expect(queryResult.length, values.length);
      expect(queryResult['Uber']['name'], 'Uber');
  });
  
  Map map = new Map();
  map["qsdf"] = "bla";
  map["qsdf2"] = "bla\n\n";
  map["qsdf3"] = "";
  
  test('test query map with params null', () {
        Map queryResult = queryMap(map, null);
        expect(queryResult.length, map.length);
    });
}