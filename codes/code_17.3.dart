// sample of await expressions and async methods
// refer to https://github.com/dart-lang/sdk/issues/24278

import 'dart:async';
import 'dart:io';

main() async {
  // Connect to a web socket.
  WebSocket socket = await WebSocket.connect('ws://echo.websocket.org');

  // Setup listening.
  socket.listen((message) {
    print('message: $message');
  }, onError: (error) {
    print('error: $error');
  }, onDone: () {
    print('socket closed.');
  }, cancelOnError: true);

  // Add message
  socket.add('echo!');

  // Wait for the socket to close.
  try {
    await socket.done;
    print('WebSocket down');
  } catch (error) {
    print('WebScoket done with error $error');
  }
}