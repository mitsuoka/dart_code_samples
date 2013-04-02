main() {
// 単行文字列（注意：+記号は不要となった）
  String a = "abcde" 'fghijk';
// 複行文字列（注意：+記号は不要となった）
  String b = """QWERTY
qwerty"""  '''AIUEO
aiueo''';
  print('a: $a');
  print('b:$b');
}
/*
a: abcdefghijk
b:QWERTY
qwertyAIUEO
aiueo
*/