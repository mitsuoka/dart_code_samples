import 'dart:math';
main() {
  List myList = ['pi is ' , PI, ', and cos pi is ', cos(PI)];
  String s = '';
  for(int i = 0; i < myList.length; i++) {
    s = "$s${myList[i].toString()}";
  }
  print(s);
}
/*
pi is 3.141592653589793, and cos pi is -1
*/