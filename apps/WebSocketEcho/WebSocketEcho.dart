// Sample Dart WebSocket echo server
// Source : http://blog.sethladd.com/2012/04/dart-server-supports-web-sockets.html#disqus_thread
// you can connect to ws://localhost:8000/ws
// Feb. 2013, revised to incorporate redesigned dart:io v2 library

import 'dart:io';

void main() {
  HttpServer.bind('127.0.0.1', 8000)
  .then((HttpServer server) {
    server
      .where((request) => request.uri.path == '/ws')
      .transform(new WebSocketTransformer())
      .listen((WebSocket ws){
        wsHandler(ws);
      });
    print("Echo server started");
  });
}

wsHandler(WebSocket ws) {
  print('new connection : ${ws.hashCode}');
  ws.listen((message) {
      print('message is ${message}');
      ws.send('Echo: ${message}');
    }, onDone: (() {
      print('connection ${ws.hashCode} closed with ${ws.closeCode} for ${ws.closeReason}');
    })
  );
}