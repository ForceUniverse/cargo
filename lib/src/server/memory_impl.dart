part of cargo_server;

class MemoryCargo extends MemoryImpl implements Cargo {

  Cargo exportToFileStorage(String path) {
    Cargo storage = new Cargo(MODE: CargoMode.FILE, conf: {"path": path});
    storage = copyTo(storage);

    return storage;
  }

}
