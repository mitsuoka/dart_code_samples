var a;
void test(){ print(a); } // これはok
//var b=new c().d; // これはエラーだった
//var test = (){print('hi');}; // これもエラーだった
class c{
//  static var staticVariable = a; // これはエラー
  var d='hello';
}
main() {
  a='hi';
  print(a);
  test();
  var b=new c().d;
  print(b);
}
/*
hi
hi
hello
*/