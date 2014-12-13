import 'package:unittest/unittest.dart';
import 'package:cargo/cargo_base.dart';

void run(CargoBase storage, String name) {
  storage.start().then((_) {
    test('test basic $name storage', () {
      storage.setItem("data", {"data": "data"});

      var data = storage.getItemSync("data");
      expect(data["data"], "data");
      storage.length().then((int count) {
              expect(count, 1);
            });
    });

    test('test $name collection switch', () {
      storage.withCollection("coll");
      
      storage.setItem("around", "world");
      
      var data = storage.getItemSync("data");
      expect(data, null);
      var around = storage.getItemSync("around");
      expect(around, "world");
      
      storage.length().then((int count) {
                    expect(count, 1);
                  });
    });

    test('test $name come back to collection switch', () {
          storage.withCollection("another");
          
          storage.setItem("bla", "bla");
          storage.setItem("bla2", "data");
          
          storage.length().then((int count) {
                        expect(count, 2);
                      });
          storage.withCollection("coll");      
          storage.length().then((int count) {
                              expect(count, 1);
                            });
        });
    
  });
}