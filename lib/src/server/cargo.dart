part of cargo_server;

abstract class Cargo extends CargoBase {
  /// Create a new cargo storage
  factory Cargo({CargoModeHolder MODE: CargoMode.MEMORY, String path: null}) {
    print("Initiating a cargo storage with ${MODE} backend");
    
    switch(MODE) {
      case CargoMode.MEMORY:
        return new MemoryBackend();
      case CargoMode.FILE:
        return new FileBackend(path);
      default:
        Logger.root.warning("Error: Unsupported storage backend \"${MODE}\", supported backends on server is: ${CargoMode.MEMORY} and ${CargoMode.FILE}");
    }
  }
}

