main() {
  List s = ['hello', 'world'];
  for(String x in s) print(x);
  // above statement is equivalent to:
  Iterator i = s.iterator;
  while (i.moveNext()) {
    String x = i.current;
    print(x);
  }
}
/*
hello
world
hello
world
*/