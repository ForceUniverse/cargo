import 'package:unittest/unittest.dart';
import 'package:cargo/cargo_server.dart';

void main() {
  // First tests!
  Cargo storage = new Cargo(MODE: CargoMode.FILE, conf: { "path" : "../store/"});

  storage.start().then((_) {
    test('test basic json storage', () {
        storage.clear();
        storage.setItem("data", {"data": "data"});

        var data = storage.getItemSync("data");
        expect(data["data"], "data");
        expect(storage.length(), 1);
    });

    Map asyncData = {"as": "go"};
    storage["async"] = asyncData;

    storage.getItem("async").then((value) {
      test('test async storage', () {
        expect(value, asyncData);
      });
    });
  });
}

