library export_options_tests;

import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_base.dart';

import 'dart:async';

var date1 = {'day': 19, 'month': 12, 'year': 2014};
var date2 = {'day': 21, 'month': 12, 'year': 2014};

void runExports(CargoBase storage, String name) {
   setUp(() {
          schedule(() {
              return storage.start().then((_) { 
                return storage.clear();
              });
          });
   });
   
   var yoData =  {'name': 'Yo', 'url': 'http://www.justyo.co/', 'point': 2, 'date': date1};
   var uberData = {'name': 'Uber', 'url': 'http://www.uber.com/', 'point': 1, 'date': date2};
   var snapChatData = {'name': 'SnapChat', 'url': 'https://www.snapchat.com/', 'point': 3, 'date': date2};
   var facebookData = {'name': 'Facebook', 'url': 'https://www.facebook.com/', 'point': 1, 'date': date2};  
   var mediumData = {'name': 'Medium', 'url': 'https://www.medium.com/', 'point': 1, 'date': date1};
   
   test('[$name] test export of the storage', () {
       schedule(() {
           Map params = new Map();
           params['point'] = 1;
           params['date'] = date2;
           
           wrapFuture(Future.wait([storage.setItem("YO", yoData),
                                       storage.setItem("Uber", uberData),
                                       storage.setItem("SnapChat", snapChatData),
                                       storage.setItem("Facebook", facebookData),
                                       storage.setItem("Medium", mediumData)])).then((_) {
             
                      return storage.export(params: params).then((Map results) {
                             expect(results.length, 2);
                             expect(results['Uber']['name'], "Uber");
                             return new Future.value();
                      });
           });
       });
   });
   
   test('[$name] test options export of the storage', () {
         schedule(() {
                Options options = new Options(limit: 3);
                
                wrapFuture(Future.wait([storage.setItem("YO", yoData),
                                            storage.setItem("Uber", uberData),
                                            storage.setItem("SnapChat", snapChatData),
                                            storage.setItem("Facebook", facebookData),
                                            storage.setItem("Medium", mediumData)])).then((_) {
                  
                           return storage.export(options: options).then((Map results) {
                                  print(results);     
                                  expect(results.length, 3);
                                  return new Future.value();
                           });
                });
         });
   });
   
   test('[$name] test options export of the storage', () {
            schedule(() {
                Options options = new Options(limit: 2, revert: true);
                
                wrapFuture(Future.wait([storage.setItem("YO", yoData),
                                            storage.setItem("Uber", uberData),
                                            storage.setItem("SnapChat", snapChatData),
                                            storage.setItem("Facebook", facebookData),
                                            storage.setItem("Medium", mediumData)])).then((_) {
                  
                           return storage.export(options: options).then((Map results) {    
                                  expect(results.length, 2);
                                  expect(results['Medium']['name'], "Medium");
                                  return new Future.value();
                           });
                });
            });
        });
   
}