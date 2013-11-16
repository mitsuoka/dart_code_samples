import 'dart:async';
main() {
  try {
    funcA();
  }
  on Error catch (er, st) {
    print('Error : $er');
    print(st);
    }
  on Exception catch (ex, st) {
    print('Exception : $ex');
    print(st);
    }
}

 funcA() {
  funcB(0);
//  funcC();
//  funcD();
}

// ArgumentError
funcB(x) {
  if(x == 0) throw new ArgumentError('Generated ArgumentError');
}

// IntegerDivisionByZeroException
funcC() {
  int x = 1 % 0;
}

// AsyncError (Bad state: More than one element)
funcD() {
  final testData = ['a', 'b'];
  var stream = new Stream.fromIterable(testData);
  stream.single.then((value){})
    .catchError((e, stackTrace){
      print('AsyncError : ${e}');
      print('Stack Trace : ${stackTrace}');
      });
}