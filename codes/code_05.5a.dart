class A {
  final a1;
  final a2;
  const A(var x): a1=6, a2 = x + 5;
  String toString(){return "class A object";}
}

int main(){
  var x = const A(5);
  print('a: ${x.toString()}, a1: ${x.a1}, a2: ${x.a2}');
}

/*
a: class A object, a1: 6, a2: 10
*/