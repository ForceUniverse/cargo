part of cargo_client;

class CargoMode {
  /// all the cargo modes for the client implementations
  static const MEMORY = const CargoModeHolder('Memory');
  static const LOCAL = const CargoModeHolder('Local');
  static const SESSION = const CargoModeHolder('Session');
  static const INDEXDB = const CargoModeHolder('INDEXDB');
}
