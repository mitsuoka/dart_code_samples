import 'dart:io';

main() {
  print('ファイル読み出し開始');
  var file = new File('testData.txt');
  file.readAsString().then((String contents) {
    print(contents); // ファイルが読みだされたときに出力
    print('読み出し完了');
  });
}
