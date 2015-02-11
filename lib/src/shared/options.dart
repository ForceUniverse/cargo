part of cargo;

class Options {
  int limit = -1;
  bool revert = false;
  
  Options({this.limit, this.revert: false});
  
  bool hasLimit() => limit != -1;
}