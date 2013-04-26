class Singleton {
  static final Singleton _singleton = new Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}

//You can construct it with new

main() {
  var s1 = new Singleton();
  var s2 = new Singleton();
  print(identical(s1, s2));  // true
  print(s1 == s2);           // true
}