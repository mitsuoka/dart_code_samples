main() {
  try {
    print( 5 % 0);
  }
  on Exception catch (e) {
    print(e.toString());
  }
  finally {
    print('finally statement');
  }
}
/*
IntegerDivisionByZeroException
finally statement
*/