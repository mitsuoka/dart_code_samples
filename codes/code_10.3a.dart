List myList;
main() {
  print(myList);
//  myList.add("Hello"); // error
  myList = new List();
  print(myList.length);
  myList.add("Hello");
  print(myList);
  print(myList.length);
}
/*
null
0
[Hello]
1
*/