Iterable naturalsTo(n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
main(){
  var it = naturalsTo(7).iterator;
  while (it.moveNext()) {
    print(it.current);
  }
}