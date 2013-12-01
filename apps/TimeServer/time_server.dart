// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Revised December 2013, by Terry.

import "dart:io";
import "dart:convert";

const HOST = "localhost";
const PORT = 8080;
final REQUEST_PATH = "/time";

const LOG_REQUESTS = true;

void main() {
  HttpServer.bind(HOST, PORT)
  .then((HttpServer server) {
    server.listen(
        (HttpRequest request) {
          if (LOG_REQUESTS) {
            print("Request: ${request.method} ${request.uri} "
            "from ${request.connectionInfo.remoteAddress}");
          }
          if (request.uri.path == REQUEST_PATH) {
            requestReceivedHandler(request);
          }
          else request.response.close();
        });
    print("${new DateTime.now()} : Serving $REQUEST_PATH on http://${HOST}:${PORT}.\n");
  });
}

// create and send response for the request here.
// if you are using Future or Stream objects inside of the try block,
// you have to handle their error and throw that error.
void requestReceivedHandler(HttpRequest request) {
  try {
//  var x = 1 % 0;  // uncomment this line to test exception handling
    String htmlResponse = createHtmlResponse();
    sendResponse(request, htmlResponse);
  }
  catch (e, st){ // catch any error and exception
    sendErrorResponse(request, e, st);
  }
}

void sendResponse(HttpRequest request, String htmlResponse){
  String htmlResponse = createHtmlResponse();
  List<int> encodedHtmlResponse = UTF8.encode(htmlResponse);
  request.response.headers
    ..set(HttpHeaders.CONTENT_TYPE, "text/html; charset=UTF-8")
    ..contentLength = encodedHtmlResponse.length;
  request.response
    ..add(encodedHtmlResponse)
    ..close();
}

void sendErrorResponse(HttpRequest request, e, st){
  request.response
    ..statusCode = HttpStatus.INTERNAL_SERVER_ERROR
    ..headers.set('Content-Type', 'text/html; charset=UTF-8')
    ..write('<pre>internal server error:\n$e\n$st</pre>')
    ..close();
}

String createHtmlResponse() {
  return
'''
<html>
  <style>
    body { background-color: teal; }
    p { background-color: white; border-radius: 8px; border:solid 1px #555; 
        text-align: center; padding: 0.5em;
        font-family: "Lucida Grande", Tahoma; font-size: 18px; color: #555; }
  </style>
  <body>
    <br/><br/>
    <p>Current time: ${new DateTime.now()}</p>
  </body>
</html>
''';
}
