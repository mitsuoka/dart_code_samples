import 'dart:async';
import 'dart:math';
main() {
  var data = [1, 'a', 3, 4, 5, 'end', 6];
  var stream = new Stream.fromIterable(data);

  // define a stream transformer
  var transformer = new StreamTransformer(handleData: (value, sink) {
    if (value is num)
      // create new values from the original value
      sink.add('√$value =  ${sqrt(value)}');
    // complete the stream if value is 'end'
    else if (value == 'end') sink.close();
    // trigger error for the illegal value
    else sink.addError(new ArgumentError('$value is not a number'));
    },
  handleDone: (sink) => sink.close(),
  handleError: (err, sink) => sink.addError(err)
  );

  // transform the stream and listen to its output
  stream.transform(transformer).listen((value) => print("$value"),
    onError:(err) => print('$err'),
    onDone:() => print('Done!')
  );
}