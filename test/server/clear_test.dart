import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_server.dart';

import '../logic/clear_tests.dart';

void main() {
  MemoryCargo storageMem = new Cargo(MODE: CargoMode.MEMORY);
  FileCargo storage = new Cargo(MODE: CargoMode.FILE, conf: {"path": "../store"});

  group('memory', () {    
    runClear(storageMem, "memory");
  });
      
  group('file', () {
    runClear(storage, "file");
  });
}