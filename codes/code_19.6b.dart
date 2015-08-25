/*
  GZIP compression test
 */
import 'dart:io';
import 'dart:convert';

void testServer() {
  HttpServer
  .bind(InternetAddress.LOOPBACK_IP_V4, 8080)
  .then((server) {
    server.autoCompress = true; // change here to disable compression
    print('Server started with: '
      '${server.address}:${server.port}');
    server.listen((HttpRequest request) {
      print('Server received a request with: ${request.uri.path}');
      request.response..write('Hello, world!')
                      ..close();
    });
  });
}

void main() {
  var httpRequest = 'GET / HTTP/1.1\nAccept-Encoding: GZIP\n\n';
  // start the test server
  testServer();
  // connect, send a request, and receive its response
  Socket.connect(InternetAddress.LOOPBACK_IP_V4, 8080).then((socket) {
    print('Connected to: '
      '${socket.remoteAddress.address}:${socket.remotePort}');
    socket.listen((data) {
      print('Response from the server:\n'
        + new String.fromCharCodes(data).trim());
      });
    socket.add(UTF8.encode(httpRequest));
    print('Request to the server:\n$httpRequest');
  });
}