import 'package:unittest/unittest.dart';
import 'package:cargo/cargo_server.dart';

import 'collection_tests.dart';

void main() {
  // MemoryCargo storageMem = new Cargo(MODE: CargoMode.MEMORY);
   
  // run(storageMem, "memory");
  MemoryCargo storageMem = new Cargo(MODE: CargoMode.MEMORY);
  FileCargo storage = new Cargo(MODE: CargoMode.FILE, conf: {"path": "../store"});

  group('memory', () {    
    run(storageMem, "memory");
  });
  
  /*group('file', () {
    run(storage, "file");
  });*/
}