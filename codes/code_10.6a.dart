Map original = {};

main(){
  original["a"]=3.14;
  original["b"]=1.414;
  print("original : $original");
  final copy = original;
  copy["c"] = "Hello copy!";
  print("copy : $copy");
  print("original : $original");
}
/*
original : {a: 3.14, b: 1.414}
copy : {a: 3.14, b: 1.414, c: Hello copy!}
original : {a: 3.14, b: 1.414, c: Hello copy!}
 */