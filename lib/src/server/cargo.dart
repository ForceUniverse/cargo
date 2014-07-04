part of cargo_server;

/// Cargo storage backends for server
const String CARGO_MODE_MEM   = "memory";
const String CARGO_MODE_FILE  = "file";

abstract class Cargo extends CargoBase {
  /// Create a new cargo storage
  factory Cargo({String MODE: CARGO_MODE_MEM, String path: null}) {
    print("Initiating a cargo storage with $MODE backend");

    switch(MODE) {
      case CARGO_MODE_MEM:
        return new MemoryBackend();
      case CARGO_MODE_FILE:
        return new FileBackend(path);
      default:
        Logger.root.warning("Error: Unsupported storage backend \"${MODE}\", supported backends on server is: ${CARGO_MODE_MEM} and ${CARGO_MODE_FILE}");
    }
  }
}

