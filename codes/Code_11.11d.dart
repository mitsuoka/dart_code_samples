Iterable naturalsDownFrom(n) sync* {
  if (n > 0) {
    yield n;
    for (int i in naturalsDownFrom(n-1)) { yield i; }
  }
}
main(){
  var it = naturalsDownFrom(7).iterator;
  while (it.moveNext()) {
    print(it.current);
  }
}