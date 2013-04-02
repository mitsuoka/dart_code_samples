class Greeter implements Comparable {
  String prefix = 'Hello,';
  Greeter() {}  // default constructor
  Greeter.withPrefix(this.prefix); // named constructor
  greet(String name) => print('$prefix $name'); // print greet
  int compareTo(Greeter other) => prefix.compareTo(other.prefix); // compare prefixes
}

void main() {
  Greeter greeter = new Greeter();
  Greeter greeter2 = new Greeter.withPrefix('Hi,');

  num result = greeter2.compareTo(greeter);
  if (result == 0) {
    greeter2.greet('you are the same.');
  } else {
    greeter2.greet('you are different.');
  }
}
/*
Hi, you are different.
*/