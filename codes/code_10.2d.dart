main() {
  StringBuffer sb = new StringBuffer();

  sb
  ..write("Use a StringBuffer")
  ..writeAll(["for ", "efficient ", "string ", "creation "])
  ..write("if you are ")
  ..write("building lots of strings");

  String fullString = sb.toString();
 // 但しprintするだけならprint(sb);だけで可、print(sb)はsb.toString()を印刷する
  print(fullString);
 // 結果：Use a StringBufferfor efficient string creation if you are building lots of strings
}