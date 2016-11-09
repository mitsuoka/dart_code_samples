import 'dart:async';
Stream asynchronousNaturalsTo(n) async* {
  int k = 0;
  while (k < n) yield k++;
}
main(){
  asynchronousNaturalsTo(7).listen((i) => print(i));
}