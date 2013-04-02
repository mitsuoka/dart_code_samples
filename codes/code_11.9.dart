class MyException implements Exception {
  String mes = '';
  MyException([this.mes]);
}

void ThrowDemo(int x) {
  try {
    try {
      // Throw an exception that depends on the argument
      if (x == 0)
        throw new MyException('200 : x equals zero');
      else
        throw new MyException('201 : x does not equal zero');
    }
    on MyException catch (e) {
    // Handle the exception
      switch (e.mes.substring(0, 3)) {
        case '200':
          print('$e - handled locally');
          break;
        default:
        // Throw the exception to a higher level
          print('not a "200" error .. ${e.mes}');
          throw new MyException('300 : threw from inner to higher');
      }
    }
  }
  on MyException catch (e) {
  // Handle the higher-level exception.
    print('$e - handled higher up');
  }
} 
main() { 
  ThrowDemo(0);
  ThrowDemo(1);
}

/*
200 : x equals zero - handled locally
not a "200" error .. 201 : x does not equal zero
300 : threw from inner to higher - handled higher up
*/