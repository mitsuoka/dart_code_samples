Iterable naturalsDownFrom(n) sync* {
  if ( n > 0) {
    yield n;
    yield* naturalsDownFrom(n-1);
  }
}
main(){
  var it = naturalsDownFrom(7).iterator;
  while (it.moveNext()) {
    print(it.current);
  }
}