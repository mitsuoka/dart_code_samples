import 'dart:math' as Math;
class D2Vector {
  // fields
  num abs, arg;
  // constructor
  D2Vector(this.abs, this.arg);
  // xVal setter / getter
  num get xVal => abs * Math.cos(arg);
  set xVal(num x) {
    num y = abs * Math.sin(arg);
    abs = Math.sqrt(x * x + y * y);
    arg = Math.atan(y / x);
  }
  // yVal setter / getter
  num get yVal => abs * Math.sin(arg);
  set yVal(num y) {
    num x = abs * Math.cos(arg);
    abs = Math.sqrt(x * x + y * y);
    arg = Math.atan(y / x);
  }
}
main(){
  D2Vector myVec = new D2Vector(1, 0);
  print('abs: ${myVec.abs} arg: ${myVec.arg} xVal: ${myVec.xVal} yVal: ${myVec.yVal}');
  myVec.yVal = 1;
  print('abs: ${myVec.abs} arg: ${myVec.arg} xVal: ${myVec.xVal} yVal: ${myVec.yVal}');
}
/*
abs: 1 arg: 0 xVal: 1 yVal: 0
abs: 1.4142135623730951 arg: 0.7853981633974483 xVal: 1.0000000000000002 yVal: 1
*/