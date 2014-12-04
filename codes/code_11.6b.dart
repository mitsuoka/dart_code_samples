import 'dart:async';
main() {
  var funcs = [funcA, funcB, funcC, funcD];
  for (var func in funcs) {
    try{
    func(0);
    }
    on Error catch (e, stackTrace)  {print('Error! $e \nStack Trace :\n$stackTrace');
    }
    on Exception catch (e, stackTrace) {print('Exception! $e \nStack Trace :\n$stackTrace');
    }
  }
}

// ArgumentError
funcA(x) {
  if(x == 0) throw new ArgumentError('Generated ArgumentError');
}

// IntegerDivisionByZeroException
funcB(_) {
  int x = 1 % 0;
}

// AsyncError (Bad state: More than one element)
funcC(_) {
  final testData = ['a', 'b'];
  var stream = new Stream.fromIterable(testData);
  stream.single.then((value){})
    .catchError((e, stackTrace) => print('AsyncError! $e \nStack Trace :\n$stackTrace'));
}

//AsyncError (Same error but caught in a zone)
funcD(_) {
  final testData = ['a', 'b'];
  var stream = new Stream.fromIterable(testData);
  runZoned(() {
    stream.single.then((value){
    });
  },
  onError: (e, stackTrace) => print('AsyncError(zoned)! $e \nStack Trace :\n$stackTrace'));
}