part of cargo;

class CargoModeHolder {
  final String _type;

  const CargoModeHolder(this._type);

  String toString() => _type;
  
  String name() =>_type; 
}