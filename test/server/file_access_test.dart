import 'package:unittest/unittest.dart';
import 'package:cargo/cargo_server.dart';

void main() {
  // First tests!
  Cargo storage = new Cargo(MODE: CargoMode.FILE, conf: {"path": "./"});

  storage.start().then((_) {
    test('test basic json storage access', () {
      storage.clear();
      storage["someValue"] = {"value": "go"};

      expect(storage["someValue"], {"value": "go"});
      expect(storage.length(), 1);
    });
  });
}
