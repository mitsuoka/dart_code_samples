class Original {
  var a = 1;
  var b;
}

main() {
  var original = new Original();
  final copy = original;
  copy.b = 2;
  print('original.a = ${original.a}');
  print('original.b = ${original.b}');
}
/*
original.a = 1
original.b = 2
 */

