library async_tests;

import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_base.dart';

void runAsync(CargoBase storage, String name) {
  setUp(() {
            schedule(() {
                return storage.start().then((_) { 
                  return storage.clear();
                });
            });
   }); 
  
   test('[$name] test async storage', () {
       schedule(() {
           Map asyncData = {"as": "go"};

           return storage.setItem("async_t", asyncData).then((_) {
             return storage.getItem("async_t").then((value) 
               => expect(value, asyncData)
             );
           });
       });
   });
}