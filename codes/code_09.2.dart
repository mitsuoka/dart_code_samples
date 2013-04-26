import 'package:meta/meta.dart';

class A {
  doThis() => print('doThis');
  doThat() => print('doThat');
  doNothing() {}
}

class B extends A {
  @override doThis() => print('Do this other thing');
  @override dothat() => print('Do that other thing');
  doNothing() {}
}