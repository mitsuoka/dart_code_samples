main() {
  // 絶対値
  print((-4).abs() == 4);

  // 切り上げときり下げ
  print(3.14.ceil() == 4.0);
  print(3.14.floor() == 3.0);

  // 四捨五入
  print(3.14.round() == 3);
  print(3.54.round() == 4);
  print(3.5.round() == 4);
  print(3.49.round() == 3);

  // 切り捨て
  print(3.141592.truncate() == 3.0);

  // doubleからintへの変換
  print(3.14.toInt() == 3);
}

/*
  総てtrue
*/
