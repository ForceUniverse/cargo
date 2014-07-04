part of cargo_client;

/// Cargo storage backends for client
const String CARGO_MODE_LOCAL = "localstorage";

abstract class Cargo extends CargoBase {
  /// Create a new cargo storage
  factory Cargo({String backend: CARGO_MODE_LOCAL, String path: null}) {
    print("Initiating a cargo storage with $backend backend");

    switch(backend) {
      case CARGO_MODE_LOCAL:
        return new LocalstorageBackend();
      default:
        Logger.root.warning("Error: Unsupported storage backend \"${backend}\", supported backends on server is: ${CARGO_MODE_LOCAL}");
    }
  }
}

