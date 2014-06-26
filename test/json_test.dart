import 'package:unittest/unittest.dart';
import 'package:cargo/cargo.dart';

main() {  
  // First tests!  
  Storage storage = new Storage(path: "store/");
  
  storage.start().then((_) {
    test('test basic memory storage', () {
        storage.clear();
        
        storage.setItem("data", {"data": "data"});
      
        var data = storage.getItem("data");
        expect(data["data"], "data");
        expect(storage.length(), 1);
    });
  });
}