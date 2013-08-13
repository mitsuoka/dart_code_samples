main() {
  print(new Fibonacci().fib(10)); // 89
}

class Fibonacci {
  int fib( int value ) {
    if( value == 0 || value == 1 ) {
      return 1;
    }
    return fib( value - 1 ) + fib( value - 2 );
  }
}