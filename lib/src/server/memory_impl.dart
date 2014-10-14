part of cargo_server;

class MemoryCargo extends MemoryImpl implements Cargo {
  Cargo exportToFileStorage(String path) {
    Cargo storage = new Cargo(MODE: CargoMode.FILE, conf: {"path": path});
    this.values.forEach((key, value) => storage.add(key, value));

    return storage;
  }

  void saveToFileStorage(Cargo storage) => this.values.forEach((key, value) => storage.add(key, value));
}
