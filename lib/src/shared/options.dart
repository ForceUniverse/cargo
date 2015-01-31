part of cargo;

class Options {
  int limit = -1;
  
  Options(this.limit);
  
  bool hasLimit() => limit != -1;
}