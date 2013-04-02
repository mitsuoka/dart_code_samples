class Greeter {
static final prefix = 'Hello,';

static greet(name) {
    print('$prefix $name');
  }
}

main() {
  print(Greeter.prefix);
  Greeter.greet('Class!');
}
/*
Hello,
Hello, Class!
*/
