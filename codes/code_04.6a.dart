/* 階乗計算（関数） */
factorial(n){if (n<=1) {return 1;} else {return n * factorial(n-1);}}
main() {
  print(factorial(5));
}
/*
120
*/