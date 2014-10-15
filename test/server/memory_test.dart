import 'package:unittest/unittest.dart';
import 'package:cargo/cargo_server.dart';

void main() {
  // First tests!
  MemoryCargo storage = new Cargo(MODE: CargoMode.MEMORY);
  FileCargo fileStorage = new Cargo(MODE: CargoMode.FILE, conf: {"path": "./"});

  storage.start().then((_) {
    test('test basic memory storage', () {
      storage.setItem("data", {
        "data": "data"
      });

      var data = storage.getItemSync("data");
      expect(data["data"], "data");
      expect(storage.length(), 1);
    });

    test('test memory save to file', () {
      storage.add("data2", "value");
      storage.copyTo(fileStorage);
    });

    test('test loading from saved memory storage', () => expect(fileStorage.getItemSync("data2"), [["value"]]));

    test('test memory export to file', () {
      Cargo exported = storage.exportToFileStorage("./");
      expect(exported.getItemSync("data2"), [["value"]]);
    });

    fileStorage.clear(); // because no one wants temporary files from tests
  });
}
