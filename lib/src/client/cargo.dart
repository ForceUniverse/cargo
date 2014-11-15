part of cargo_client;

/// Cargo storage backends for client
const String CARGO_MODE_LOCAL = "localstorage";

abstract class Cargo extends CargoBase {
  Cargo._();
  /// Create a new cargo storage
  factory Cargo({CargoModeHolder MODE: CargoMode.MEMORY, Map path}) {
    print("Initiating a cargo storage with ${MODE} backend");

    switch (MODE) {
      case CargoMode.MEMORY:
        return new MemoryCargo();
      case CargoMode.LOCAL:
        return new LocalstorageCargo(window.localStorage);
      case CargoMode.SESSION:
        return new LocalstorageCargo(window.sessionStorage);
      case CargoMode.INDEXDB:
        if (IndexDbCargo.supported) {
          return new IndexDbCargo("dbName", "storeName");
        }
        return new LocalstorageCargo(window.localStorage);
      default:
        Logger.root.warning("Error: Unsupported storage backend \"${MODE}\", supported backends on server is: ${CargoMode.MEMORY} and ${CargoMode.LOCAL}");
    }
  }
}
