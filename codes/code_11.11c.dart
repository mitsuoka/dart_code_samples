import 'dart:async';
Stream asynchronousNaturalsTo(n) async* {
  int k = 0;
  while (k < n) yield k++;
}
main(){
  asynchronousNaturalsTo(7)
      .listen((v) => print(v),
      onError: (err) => print("An error occured: $err"),
      onDone: () => print("The stream was closed"));
}