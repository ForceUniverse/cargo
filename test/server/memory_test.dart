import 'package:unittest/unittest.dart';
import 'package:cargo/cargo_server.dart';

void main() {
  // First tests!
  Cargo storage = new Cargo(backend: CARGO_MODE_MEM);

  storage.start().then((_) {
    test('test basic memory storage', () {
        storage.setItem("data", {"data": "data"});

        var data = storage.getItemSync("data");
        expect(data["data"], "data");
        expect(storage.length(), 1);
    });
  });
}

