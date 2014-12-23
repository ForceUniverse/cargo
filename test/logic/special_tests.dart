library special_tests;

import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_base.dart';

void runSpecial(CargoBase storage, String name) {
  setUp(() {
            schedule(() {
                return storage.start().then((_) { 
                  return storage.clear();
                });
            });
   }); 
   
   test('[$name] test special chars', () {
          schedule(() {
              Map asyncData = {"as": "go"};
              storage["\test"] = asyncData;
              
              return storage.getItem("\test").then((value) 
                           => expect(value, asyncData)
                         );
          });
      });
}