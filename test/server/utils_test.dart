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
    expect(true, containsByOverlay(values['YO'], params));
  });
  
  test('test contains negative', () {
    expect(false, containsByOverlay(values['YO'], params2));
  });
  
  test('test query map', () {
    Map queryResult = queryMap(values, params2);
    expect(2, queryResult.length);
    expect("Uber", queryResult['Uber']['name']);
  });
  
  test('test query map with params null', () {
      Map queryResult = queryMap(values, null);
      expect(values.length, queryResult.length);
      expect("Uber", queryResult['Uber']['name']);
  });
}