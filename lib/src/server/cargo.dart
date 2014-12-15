part of cargo_server;

abstract class Cargo extends CargoBase {
  Cargo._();
  /// Create a new cargo storage
  factory Cargo({CargoModeHolder MODE: CargoMode.MEMORY, conf, String collection: ""}) {
    print("Initiating a cargo storage with ${MODE} backend");

    switch (MODE) {
      case CargoMode.MEMORY:
        return new MemoryCargo(collection: collection);
      case CargoMode.FILE:
        return new FileCargo(conf != null ? conf["path"] : "", collection: collection);
      default:
        Logger.root.warning("Error: Unsupported storage backend \"${MODE}\", supported backends on server is: ${CargoMode.MEMORY} and ${CargoMode.FILE}");
    }
  }
}
