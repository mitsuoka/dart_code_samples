import 'dart:convert';
main() {
  var string = 'Dart言語';
  List<int> bytes = [];
  bytes.addAll(new Utf8Codec().encode(string));
  print(bytes);
}
// [68, 97, 114, 116, 232, 168, 128, 232, 170, 158]