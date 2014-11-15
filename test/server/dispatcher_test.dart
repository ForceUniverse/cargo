import 'package:unittest/unittest.dart';
import 'package:cargo/cargo_server.dart';

void main() {
  // First tests!
  MemoryCargo storage = new Cargo(MODE: CargoMode.MEMORY);
 
  storage.start().then((_) {
    test('test dispatch all', () {
      storage.onAll((de) => expect("key", de.key));
      storage.setItem("key", "data");
    });

    test('test dispatch', () {
          storage.on("key", (de) => expect("data", de.data));
          storage.setItem("key", "data");
        });
    
  });
}
