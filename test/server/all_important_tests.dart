import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_server.dart';

import '../logic/collection_tests.dart';
import '../logic/normal_tests.dart';

void main() {
  MemoryCargo storageMem = new Cargo(MODE: CargoMode.MEMORY);
  FileCargo storage = new Cargo(MODE: CargoMode.FILE, conf: {"path": "../store"});

  group('memory_normal', () {    
    run(storageMem, "memory");
  });
  
  group('file_normal', () {
    run(storage, "file");
  });
  
  group('memory', () {    
    runCollection(storageMem, "memory");
  });
    
  group('file', () {
    runCollection(storage, "file");
  });
}