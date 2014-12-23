library normal_tests;

import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_base.dart';

void run(CargoBase storage, String name) {
  setUp(() {
            schedule(() {
                return storage.start().then((_) { 
                  return storage.clear();
                });
            });
   }); 
  
   test('[$name] test basic json storage', () {
         schedule(() {
           storage.setItem("normal", {"data": "data"});
     
           var data = storage.getItemSync("normal");
           expect(data["data"], "data");
           
           return storage.length().then((int count) => expect(count, 1));
         });
   });

   test('[$name] test async storage', () {
       schedule(() {
           Map asyncData = {"as": "go"};
           storage["async_t"] = asyncData;
     
           return storage.getItem("async_t").then((value) 
             => expect(value, asyncData)
           );
       });
   });
   
}