library clear_tests;

import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_base.dart';

void runClear(CargoBase storage, String name) {
  setUp(() {
            schedule(() {
                storage.withCollection("");
                return storage.start().then((_) { 
                  return storage.clear();
                });
            });
   }); 
  
   test('[$name] test clear functionaliteit', () {
         schedule(() {
           return storage.clear().then((_) {
             storage.setItem("normal", {"data": "data"});
             storage.setItem("normal2", {"data2": "data"}); 
             
             return storage.length().then((int count) { 
                  expect(count, 2);
                  
                  return storage.clear().then((_) {
                      return storage.length().then((int count) => expect(count, 0));
                  });
               });
         });
        }); 
   });

   
}