part of cargo_server;

abstract class Cargo extends CargoBase with CargoDispatch {
  Cargo._();
  /// Create a new cargo storage
  factory Cargo({CargoModeHolder MODE: CargoMode.MEMORY, conf}) {
    print("Initiating a cargo storage with ${MODE} backend");

    switch(MODE) {
      case CargoMode.MEMORY:
        return new MemoryCargo();
      case CargoMode.FILE:
        return new FileCargo(conf!=null ? conf["path"] : "");
      default:
        Logger.root.warning("Error: Unsupported storage backend \"${MODE}\", supported backends on server is: ${CargoMode.MEMORY} and ${CargoMode.FILE}");
    }
  }
}

