library cargo_client;

import 'package:logging/logging.dart' show Logger, Level, LogRecord;
import 'dart:html';
import 'dart:async';
import 'dart:indexed_db';

import 'package:cargo/cargo_base.dart';

part 'src/client/cargo.dart';
part 'src/client/storage_impl.dart';
part 'src/client/memory_impl.dart';
part 'src/client/cargo_mode.dart';
part 'src/client/indexdb_impl.dart';

