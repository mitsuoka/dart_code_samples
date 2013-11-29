// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:io";
import "dart:convert";

const HOST = "127.0.0.1";
const PORT = 8080;
final REQUEST_PATH = "/time";

const LOG_REQUESTS = true;

void main() {
  HttpServer.bind(HOST, PORT)
  .then((HttpServer server) {
    server.listen(
        (HttpRequest request) {
          if (request.uri.path == REQUEST_PATH) {
            requestReceivedHandler(request);
          }
          else request.response.close();
        });
    print("${new DateTime.now()} : Serving $REQUEST_PATH on http://${HOST}:${PORT}.\n");
  });
}

void requestReceivedHandler(HttpRequest request) {
  if (LOG_REQUESTS) {
    print("Request: ${request.method} ${request.uri}");
  }

  String htmlResponse = createHtmlResponse();
  List<int> encodedHtmlResponse = UTF8.encode(htmlResponse);

  request.response.headers
    ..set(HttpHeaders.CONTENT_TYPE, "text/html; charset=UTF-8")
    ..contentLength = encodedHtmlResponse.length;
  request.response
    ..add(encodedHtmlResponse)
    ..close();
}

String createHtmlResponse() {
  return
'''
<html>
  <style>
    body { background-color: teal; }
    p { background-color: white; border-radius: 8px; border:solid 1px #555; text-align: center; padding: 0.5em;
        font-family: "Lucida Grande", Tahoma; font-size: 18px; color: #555; }
  </style>
  <body>
    <br/><br/>
    <p>Current time: ${new DateTime.now()}</p>
  </body>
</html>
''';
}
