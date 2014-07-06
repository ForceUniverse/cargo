part of cargo_client;

/// Cargo storage backends for client
const String CARGO_MODE_LOCAL = "localstorage";

abstract class Cargo extends CargoBase with CargoDispatch {
  Cargo._();
  /// Create a new cargo storage
  factory Cargo({CargoModeHolder MODE: CargoMode.MEMORY, String path: null}) {
      print("Initiating a cargo storage with ${MODE} backend");
      
      switch(MODE) {
        case CargoMode.MEMORY:
          return new MemoryClient();
        case CargoMode.LOCAL:
          return new LocalstorageBackend(window.localStorage);
        case CargoMode.SESSION:
          return new LocalstorageBackend(window.sessionStorage);
        default:
          Logger.root.warning("Error: Unsupported storage backend \"${MODE}\", supported backends on server is: ${CargoMode.MEMORY} and ${CargoMode.LOCAL}");
      }
    }
}

