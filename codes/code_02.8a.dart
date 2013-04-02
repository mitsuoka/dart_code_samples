import 'dart:math';
num numval = PI;
main() {
  int intval = numval + 5; // Error in checked mode: double is not assignable to int
  print(intval);
}
/*
8.141592653589793
*/