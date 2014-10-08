import "dart:convert";
var jsonObj = {"language":"DART",
               "targets":["dartium","javascript","Android?"],
               "website":{"homepage":"www.dartlang.org","api":"api.dartlang.org"}};
main() {
  String jsonStr = JSON.encode(jsonObj);
  print(jsonStr);
}
/**
{"language":"DART",
"targets":["dartium","javascript","Android?"],
"website":{"homepage":"www.dartlang.org","api":"api.dartlang.org"}}
*/