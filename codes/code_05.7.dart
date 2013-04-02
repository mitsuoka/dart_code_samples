class Symbol {
  final String name;
  static Map<String, Symbol> _cache;

  factory Symbol(String name) {
    if (_cache == null) {
      _cache = {};
    }

    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      final symbol = new Symbol._internal(name);
      _cache[name] = symbol;
      return symbol;
    }
  }

   Symbol._internal(this.name);
}