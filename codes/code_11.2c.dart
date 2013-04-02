main() {
  var callbacks = [];
  for (var i = 0; i < 2; i++) {
//    var j = i;
//    callbacks.add(() => print(j));
    callbacks.add(() => print(i));
  }
  callbacks.forEach((c) => c());
}
/*
0
1
*/