import 'package:unittest/unittest.dart';
import 'package:cargo/cargo_client.dart';

void main() {
  // First tests!
  MemoryCargo storage = new Cargo(MODE: CargoMode.MEMORY);

  storage.start().then((_) {
    test('test basic memory storage', () {
      storage.setItem("data", {"data": "data"});

      var data = storage.getItemSync("data");
      expect(data["data"], "data");
      storage.length().then((int count) {
        expect(count, 1);
      });
    });
  });
}
