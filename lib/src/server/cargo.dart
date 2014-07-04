part of cargo_server;

/// Cargo storage backends for server
const String CARGO_MODE_MEM   = "memory";
const String CARGO_MODE_FILE  = "file";

abstract class Cargo extends CargoBase {
  /// Create a new cargo storage
  factory Cargo({String backend: CARGO_MODE_MEM, String path: null}) {
    print("Initiating a cargo storage with $backend backend");

    switch(backend) {
      case CARGO_MODE_MEM:
        return new MemoryBackend();
      case CARGO_MODE_FILE:
        return new FileBackend(path);
      default:
        Logger.root.warning("Error: Unsupported storage backend \"${backend}\", supported backends on server is: ${CARGO_MODE_MEM} and ${CARGO_MODE_FILE}");
    }
  }
}

