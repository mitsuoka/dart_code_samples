Function adder(num n) {
  return (num i) => n + i; // 関数を返す関数定義
}

main() {
  var addByTwo = adder(2); // 2を加算する関数をaddByTwoという変数として扱う
  print(addByTwo(3));      // 5を出力
}
