var x = 1;
int i = 1;
double d = 1.23;
String s =  '1';
main() {
  print(x is int);    // true
  print(x is num);    // true
  print(x is double); // false
  print(i is num);    // true
  print(i is int);    // true
  print(i is double); // false
  print(i is num);    // true
  print(d is int);    // false
  print(s is num);    // false
  print(s is String); // true
}