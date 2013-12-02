main() {
  try {
    errorCode();
  }
  catch (e, st) { // catch any error and exception
    print('Caught an exception in the main() : \n$e\n$st');
  }
}
errorCode() {
  try{
    var x = 5 % 0;
  }
  catch (e, st) {
    print('Caught an exception in the errorCode() : \n$e\n$st');
    rethrow;
  }
}
