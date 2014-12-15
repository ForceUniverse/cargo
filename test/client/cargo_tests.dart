import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_client.dart';

import '../logic/collection_tests.dart';
import '../logic/normal_tests.dart';
import '../logic/async_tests.dart';

void main() {
  MemoryCargo storageMem = new Cargo(MODE: CargoMode.MEMORY);
  Cargo storage = new Cargo(MODE: CargoMode.LOCAL);
  
  Cargo storageIndexDB = new Cargo(MODE: CargoMode.INDEXDB);

  group('memory_normal', () {    
    run(storageMem, "memory");
  });
  
  group('localstorage_normal', () {
    run(storage, "localstorage");
  });
  
  group('indexdb_normal', () {
    runAsync(storageIndexDB, "indexdb");
  });
  
  group('memory', () {    
    runCollection(storageMem, "memory");
  });
    
  group('localstorage', () {
    runCollection(storage, "localstorage");
  });
  
  /*group('indexdb', () {
    runCollection(storage, "indexdb");
  });*/
}