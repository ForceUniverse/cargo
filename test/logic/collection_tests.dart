library collection_tests;

import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_base.dart';

void runCollection(CargoBase storage, String name) {
   setUp(() {
          schedule(() {
            return storage.start().then((_) => storage.clear());
          });
   }); 
  
   test('test basic $name storage', () {
      schedule(() {
        storage.setItem("data", {"data": "data"});
  
        var data = storage.getItemSync("data");
        expect(data["data"], "data");
        
        return storage.length().then((int count) 
            => expect(count, 1));
      });
    });

    test('test $name collection switch', () {
      schedule(() {
        storage.withCollection("coll");
        
        storage.setItem("around", "world");
        
        var data = storage.getItemSync("data");
        expect(data, null);
        var around = storage.getItemSync("around");
        expect(around, "world");
        
        return storage.length().then((int count) => expect(count, 1));
      });
    });

    test('test $name come back to collection switch', () {
      schedule(() {
          storage.withCollection("coll");  
          storage.setItem("around", "world");  
        
          storage.withCollection("another");
          storage.setItem("bla", "bla");
          storage.setItem("bla2", "data");
          
          storage.length().then((int count) => expect(count, 2));
          
          storage.withCollection("coll");      
          
          return storage.length().then((int count) => expect(count, 1));
        });
    });
}