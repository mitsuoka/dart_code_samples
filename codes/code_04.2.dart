main() {
  var balance = 0;

var deposit = (amount) { balance += amount; };  // 預金1：関数リテラル
//  deposit(amount) { balance += amount; }          // 預金2：関数定義
var withdraw = (amount) { balance -= amount; }; // 引き出し1：関数リテラル
//  withdraw(amount){balance -= amount; }           // 引き出し2：関数定義

  deposit(1000);  // 預金呼び出し
  withdraw(100);  // 引き出し呼び出し

  print(balance);
}
