var x = 1;
int y = 1;
double z = 1.0;
String p;
var q = '';
main() {
  try{
    print(x == y);   // true
    print(identical(x, y));  // true
    print(x != y);   // false
    print(x == z);   // true
    print(identical(x, z));  // false
    print(x == y);   // true
    print(y == z);   // true
    print(identical(y, z));  // false
    print(x == '1'); // false
    print(p == q);   // false
    print(identical(p, q));  // false
    print(p == null);// true
    p = "";
    print(p == null);// false
    print(p == q);   // true
    print(identical(p, q));  // true
    print(identical(p, q)); // true
  } on Exception catch(e){
    print(e);
  }
}