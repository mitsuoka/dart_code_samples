class Greeter {
  var prefix = 'Hello,';

  greet(name) {
    print('$prefix $name');
  }
}

main() {
  var greeter = new Greeter();
  greeter.greet("Class!");
}
/*
Hello, Class!
*/