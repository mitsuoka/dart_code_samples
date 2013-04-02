final String c = 'Time: '; // トップ・レベル定数
var v;                     // トップ・レベル変数
void f(String p) {         // トップ・レベル関数
  print(p);
}

main() {            // トップ・レベルのmain関数
  C myC = new C();
  v = new DateTime.now();
  f(myC.m());
}

class C {           // クラス宣言
  String m() {      // メソッド
    return '$c $v'; // トップ・レベルの要素へのアクセス
  }
}