/*
  Dart code sample : Simple tool for HTTP server development
  Returns contents of the HTTP request to the client
    1. Save these files into a folder named DumpHttpRequest.
    2. From Dart editor, File > Open Folder and select this DumpHttpRequest folder.
    3. Run DumpHttpRequest.dart as server.
    4. Access the DumpHttpRequest.html file from your browser such as : file:///C:/ … /DumpHttpRequest/DumpHttpRequest.html
    5. Enter some text to the text areas and click “Submit using POST” or “Submit using GET” button.
    6. This server will return available data from the request. This data is also available on the Dart editor’s console.
  Ref: www.cresc.co.jp/tech/java/Google_Dart/DartLanguageGuide.pdf (in Japanese)
  May 2012, by Cresc Corp.
  June and August 2012 (revised to incorporate new APIs)
  January 2013 (revised to incorporate API change)
  Feb. 2013, Revised to incorporate newly added dart:async library.
  Feb. 2013, Revised to incorporate revised dart:io library.
  March 2013, API changes (String and HttpResponse) fixed
  July 2013, Modified main() to ruggedize.
  Aug. 2013, API change (removed StringDecoder and added dart:convert) fixed
  Oct. 2013, API change (dart:utf removed) fixed
  Nov. 2013, API change (remotHost -> remoteAddress) fixed
  Aug. 2015, Updated for the latest API
*/

import "dart:async";
import "dart:io";
import "dart:convert";

final HOST = "127.0.0.1";
final PORT = 8080;
final REQUEST_PATH = "/DumpHttpRequest";
final LOG_REQUESTS = false;

void main() {
  HttpServer.bind(HOST, PORT)
  .then((HttpServer server) {
    server.autoCompress = true; // set false to disable compressed body transmission
    server.listen(
        (HttpRequest request) {
          request.response.done.then((d){
              print("sent response to the client for request : ${request.uri}");
            }).catchError((e) {
              print("Error occured while sending response: $e");
            });
          if (request.uri.path == REQUEST_PATH) {
            requestReceivedHandler(request);
          }
          else request.response.close();
        });
    print("${new DateTime.now()} : Serving $REQUEST_PATH on http://${HOST}:${PORT}.\n");
  });
}

void requestReceivedHandler(HttpRequest request) {
  HttpResponse response = request.response;
  List<int> bodyBytes = [];      // request body byte data
  var completer = new Completer();
  if (request.method == "GET") {
    completer.complete("query string data received");
  } else if (request.method == "POST") {
    request.listen(
        (data) {
          bodyBytes.addAll(data);
        },
        onDone: () {
          completer.complete("body data received");
        },
        onError: (e) {
          print("exeption occured : ${e.toString()}");
        }
    );
  }
  else {
    response.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
    response.close();
    return;
  }
  // process the request and send a response
  completer.future.then((data){
    if (LOG_REQUESTS) {
      print(createLogMessage(request, bodyBytes));
    }
    response.headers.add("Content-Type", "text/html; charset=UTF-8");
    response.write(createHtmlResponse(request, bodyBytes));
    response.close();
  });
}

// create html response text
String createHtmlResponse(HttpRequest request, List<int> bodyBytes) {
  var res = '''<html>
  <head>
    <title>DumpHttpRequest</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <H1>Data available from the request</H1>
    <pre>${makeSafe(createLogMessage(request, bodyBytes)).toString()}
    </pre>
  </body>
</html>
''';
  return res;
}

// create log message
StringBuffer createLogMessage(HttpRequest request, [List<int> bodyBytes]) {
  var sb = new StringBuffer('''request.headers.host : ${request.headers.host}
request.headers.port : ${request.headers.port}
request.connectionInfo.localPort : ${request.connectionInfo.localPort}
request.connectionInfo.remoteAddress : ${request.connectionInfo.remoteAddress}
request.connectionInfo.remotePort : ${request.connectionInfo.remotePort}
request.method : ${request.method}
request.persistentConnection : ${request.persistentConnection}
request.protocolVersion : ${request.protocolVersion}
request.contentLength : ${request.contentLength}
request.uri : ${request.uri}
request.uri.scheme : ${request.uri.scheme}
request.uri.path : ${request.uri.path}
request.uri.query : ${request.uri.query}
request.uri.queryParameters :
''');
  request.uri.queryParameters.forEach((key, value) {
    sb.write("  ${key} : ${value}\n");
  });
  sb.write('''request.cookies :
''');
  request.cookies.forEach((value) {
    sb.write("  ${value.toString()}\n");
  });
  sb.write('''request.headers.expires : ${request.headers.expires}
request.headers :''');
  request.headers.forEach((name, values) {
    sb.write('\n  $name :');
    values.forEach((value) {
      sb.write(' $value');
    });
  });
  sb.write('''\n
request.session.id : ${request.session.id}
requset.session.isNew : ${request.session.isNew}
''');
  if (request.method == "POST") {
    var enctype = request.headers["content-type"][0];
    if (enctype.contains("text")) {
      // UTF8 encoded text/plain
      sb.write("request body string (text/plain) : ${UTF8.decode(bodyBytes)}");
    } else if (enctype.contains("urlencoded")) {
      // URL encoded
      sb.write("request body string (URL decoded): "
      + Uri.decodeQueryComponent(UTF8.decode(bodyBytes)));
    } else {
      sb.write("request body string (as ASCII bytes): "
      + bytesToAscii(bodyBytes).toString());
    }
  }
  sb.write("\n");
  return sb;
}

  // convert List<int> data into printable ASCII string
  //  unreadable characters are replaced with '?'
  StringBuffer bytesToAscii(List<int> bytes) {
    var sb = new StringBuffer();
    int b;
    for (int i = 0; i < bytes.length; i++) {
      b = bytes[i];
      if (b >= 0x7f || b <= 0x1f) b = 0x3f; // unreadable
      if (bytes[i] == 0x0a) b = 0x0a; // LF
      if (bytes[i] == 0x0d) b = 0x0d; // CR
      sb.writeCharCode(b);
    }
    return sb;
  }

// make safe string buffer data as HTML text
StringBuffer makeSafe(StringBuffer b) {
  var s = b.toString();
  b = new StringBuffer();
  for (int i = 0; i < s.length; i++){
    if (s[i] == '&') { b.write('&amp;');
    } else if (s[i] == '"') { b.write('&quot;');
    } else if (s[i] == "'") { b.write('&#x27;');
    } else if (s[i] == '<') { b.write('&lt;');
    } else if (s[i] == '>') { b.write('&gt;');
    } else if (s[i] == '/') { b.write('&#x2F;');
    } else { b.write(s[i]);
    }
  }
  return b;
}
