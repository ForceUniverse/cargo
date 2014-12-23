import 'package:scheduled_test/scheduled_test.dart';
import 'package:cargo/cargo_server.dart';

import '../logic/special_tests.dart';
import '../logic/normal_tests.dart';
 
void main() {

  FileCargo storage = new Cargo(MODE: CargoMode.FILE, conf: {"path": "../store"});
  
  group('file exports', () {
    runSpecial(storage, "file");
  });
  
  group('file_normal', () {
    run(storage, "file");
  });
  
}