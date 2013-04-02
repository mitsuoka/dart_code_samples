/* 階乗計算（関数リテラル） */
var factorial;
main() {
  factorial = (n){if (n<=1) {return 1;} else {return n * factorial(n-1);}};
  print(factorial(5));
}
/*
120
*/