import 'package:unittest/unittest.dart';
import 'package:cargo/cargo.dart';

main() {  
  // First tests!  
  Storage storage = new Storage(path: "store/");
  
  storage.start().then((_) {
    test('test basic json storage access', () {
           storage.clear();  
           storage["someValue"] = {"value": "go"};
         
           expect(storage["someValue"], {"value": "go"});
           expect(storage.length(), 1);
       }); 
  });
  
  
}