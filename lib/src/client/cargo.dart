part of cargo_client;

/// Cargo storage backends for client
const String CARGO_MODE_LOCAL = "localstorage";

abstract class Cargo extends CargoBase {
  Cargo._();
  /// Create a new cargo storage
  factory Cargo({CargoModeHolder MODE: CargoMode.MEMORY, Map path, String collection: ""}) {
    print("Initiating a cargo storage with ${MODE} backend");

    switch (MODE) {
      case CargoMode.MEMORY:
        return new MemoryCargo(collection: collection);
      case CargoMode.LOCAL:
        return new LocalstorageCargo(window.localStorage, collection: collection);
      case CargoMode.SESSION:
        return new LocalstorageCargo(window.sessionStorage, collection: collection);
      case CargoMode.INDEXDB:
        if (collection=="") {
            collection = "storeName";
        }
        if (IndexDbCargo.supported) {
          return new IndexDbCargo("dbName", collection);
        }
        return new LocalstorageCargo(window.localStorage, collection: collection);
      default:
        Logger.root.warning("Error: Unsupported storage backend \"${MODE}\", supported backends on server is: ${CargoMode.MEMORY} and ${CargoMode.LOCAL}");
    }
  }
}
