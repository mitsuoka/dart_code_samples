main() {
  try {
    var x = 1;
    var y = 1;
    if(x-y == 0) print(x - y);
    if(x - y) print(x - y);
  } on Exception catch(e){print(e);}
}
/*
0
Unhandled exception:
type 'int' is not a subtype of type 'bool' of 'boolean expression'.
*/