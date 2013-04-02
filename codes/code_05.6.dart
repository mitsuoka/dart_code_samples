class Greeter {
  var prefix = 'Hello,';
  Greeter();
  Greeter.withPrefix(this.prefix);
  greet(name) {
    print('$prefix $name');
  }
}

main() {
  var greeter1 = new Greeter();
  greeter1.greet('Class');
  var greeter2 = new Greeter.withPrefix('Howdy,');
  greeter2.greet('Class');
}
/*
Hello, Class
Howdy, Class
*/