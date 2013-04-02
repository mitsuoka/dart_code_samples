main() {
  print('\\ " ');
  print("\\ ' ");
  print('abc\ndef');             // エスケープ改行
  print(r'abc\ndef');            // 生文字列
  print('\a\c\d\e\g');           // 非エスケープ文字
  print('\x43\x72\x65\x73\x63'); // ASCII 1バイト文字
  print('\u{43}\u{72}\u{65}\u{73}\u{63}');
  print('\u30AF\u30EC\u30B9');   // Unicode 2バイト文字
  print('\u{30af}\u{30ec}\u{30b9}');
}
/*
\ "
\ '
abc
def
abc\ndef
acdeg
Cresc
Cresc
クレス
クレス
*/