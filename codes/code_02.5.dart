getConst() => const [1, 2];
main() {
  var a = getConst();
  var b = getConst();
  print(identical(a, b)); // true
}