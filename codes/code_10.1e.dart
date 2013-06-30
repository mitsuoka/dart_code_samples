main() {
  var a = true;
  bool b = true;
  bool c = false;
  bool d = null;
  String s = 'abc';
  if (a) print('a is $a');
  if (b) print('b is $b');
  if (c == false) print('c is $c');
  if (d == null) print('d is $d');
  if (d == false) print('d is $d');
  if (s != true) print ('s is $s');
  }

/*
a is true
b is true
c is false
d is null
s is abc
*/