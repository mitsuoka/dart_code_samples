/* 挨拶 */
greeting([String salutation = 'Hello ']) => (String name) => "$salutation$name!";
main() {
  final greeting1 = greeting();
  final greeting2 = greeting('Hi ');
  print(greeting1('Tom'));
  print(greeting2('Jim'));
}
/*
Hello Tom!
Hi Jim!
*/