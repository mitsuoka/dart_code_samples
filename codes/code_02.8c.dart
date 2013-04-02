main() {
  double x = double.NAN;
  double y = 1.0;
  print("${x.isNaN}, ${y.isNaN}");
  double z = 0/0;
  print("$z, ${z.isNaN}");
  var p = 1/0;
  var q = -1/0;
  print("$p, $q");
}
/*
true, false
NaN, true
Infinity, -Infinity
*/
