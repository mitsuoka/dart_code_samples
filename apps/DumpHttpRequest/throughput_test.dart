import "dart:io";
import "dart:async";

final HOST = "127.0.0.1";
final PORT = 8080;
final REQUEST_PATH = "/throughput";

void main() {
  HttpServer.bind(HOST, PORT)
  .then((HttpServer server) {
    server.listen((HttpRequest request) async {
      var response = request.response;
      print("sent response to the client ${request.hashCode} for request : ${request.uri}");
      response.done.then((d){
      }).catchError((e) {
        print("Error occured while sending response: $e");
      });
      if (request.uri.path == REQUEST_PATH) {
        try {
          var pauseTime = num.parse(request.uri.queryParameters["pause"]);
          response.write("\n" + log("Request for $pauseTime sec. pause accepted"));
          await sleep(new Duration(seconds: pauseTime));
          response.write("\n" + log("Sent response for $pauseTime sec. pause time"));
        } catch(e,st){
          response.write("\n" +  log("Input error, try again \n$st"));
        }
        response.close();
      }
      else response.close();
    });
    print("${new DateTime.now()} : Serving $REQUEST_PATH on http://${HOST}:${PORT}.\n");
  });
}

// Sleeps during the specified duration
Future sleep(Duration duration) {
  return new Future.delayed(duration, () => "awaked");
}

// Create log message with timestamp
String log(String msg) {
  String timestamp = new DateTime.now().toString().substring(11);
  return '$timestamp : $msg';
}