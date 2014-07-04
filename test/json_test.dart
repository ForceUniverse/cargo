import 'package:unittest/unittest.dart';
import 'package:cargo/cargo.dart';

main() {  
  // First tests!  
  Storage storage = new Storage(path: "store/");
  
  storage.start().then((_) {
    
    test('test basic json storage', () {
        storage.clear();  
        storage.setItem("data", {"data": "data"});
      
        var data = storage.getItemSync("data");
        expect(data["data"], "data");
        expect(storage.length(), 1);
    });
    
    storage["async"] = {"as": "go"};
    storage.getItem("async").then((value) {
      test('test async storage', () {
        expect(value, storage["async"]);
      });
    });
  });
  
  
}