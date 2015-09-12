abstract class A {
  A._();
  factory A() => new B();
  foo() => 'method of A';
  bar();
}

class B extends A {
  B() : super._();
  bar() => 'method of B';
}

main() {
  print(new A().bar());
  print(new B().foo());
}
