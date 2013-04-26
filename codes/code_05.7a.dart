abstract class A {
  A._();
  factory A() => new B();
  foo() => 42;
}

class B extends A {
  B() : super._();
}

main() {
  print(new B().foo());
}