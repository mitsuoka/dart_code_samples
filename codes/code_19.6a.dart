// Most simple GZIP echo server
import "dart:io";

void main() {
  HttpServer
  .bind(InternetAddress.LOOPBACK_IP_V4, 8080)
  .then((server) {
    server.autoCompress = true;
    server.listen((HttpRequest request) {
      request.response..write('Hello, world!')
        ..close();
    });
  });
}