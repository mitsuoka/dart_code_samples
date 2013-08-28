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
  Aug. 2913, API change (removed StringDecoder and added dart:convert) fixed
*/

import "dart:async";
import "dart:io";
import "dart:convert";
import "dart:utf" as utf;

final HOST = "127.0.0.1";
final PORT = 8080;
final REQUEST_PATH = "/DumpHttpRequest";
final LOG_REQUESTS = false;

void main() {
  HttpServer.bind(HOST, PORT)
  .then((HttpServer server) {
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
  String bodyString = "";      // request body byte data
  var completer = new Completer();
  if (request.method == "GET") { completer.complete("query string data received");
  } else if (request.method == "POST") {
    request
      .transform(UTF8.decoder) // decode the body as UTF
      .listen(
          (String str){bodyString = bodyString + str;},
          onDone: (){
            completer.complete("body data received");},
          onError: (e){
            print('exeption occured : ${e.toString()}');}
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
      print(createLogMessage(request, bodyString));
    }
    response.headers.add("Content-Type", "text/html; charset=UTF-8");
    response.write(createHtmlResponse(request, bodyString));
    response.close();
  });
}

// create html response text
String createHtmlResponse(HttpRequest request, String bodyString) {
  var res = '''<html>
  <head>
    <title>DumpHttpRequest</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <H1>Data available from the request</H1>
    <pre>${makeSafe(createLogMessage(request, bodyString)).toString()}
    </pre>
  </body>
</html>
''';
  return res;
}

// create log message
StringBuffer createLogMessage(HttpRequest request, [String bodyString]) {
  var sb = new StringBuffer( '''request.headers.host : ${request.headers.host}
request.headers.port : ${request.headers.port}
request.connectionInfo.localPort : ${request.connectionInfo.localPort}
request.connectionInfo.remoteHost : ${request.connectionInfo.remoteHost}
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
  request.uri.queryParameters.forEach((key, value){
    sb.write("  ${key} : ${value}\n");
  });
  sb.write('''request.cookies :
''');
  request.cookies.forEach((value){
    sb.write("  ${value.toString()}\n");
  });
  sb.write('''request.headers.expires : ${request.headers.expires}
request.headers :
  ''');
  var str = request.headers.toString();
  for (int i = 0; i < str.length - 1; i++){
    if (str[i] == "\n") { sb.write("\n  ");
    } else { sb.write(str[i]);
    }
  }
  sb.write('''\nrequest.session.id : ${request.session.id}
requset.session.isNew : ${request.session.isNew}
''');
  if (request.method == "POST") {
    var enctype = request.headers["content-type"];
    if (enctype[0].contains("text")) {
      sb.write("request body string : ${bodyString.replaceAll('+', ' ')}");
    } else if (enctype[0].contains("urlencoded")) {
      sb.write("request body string (URL decoded): ${urlDecode(bodyString)}");
    }
  }
  sb.write("\n");
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

// URL decoder decodes url encoded utf-8 bytes
// Use this method to decode query string
// We need this kind of encoder and decoder with optional [encType] argument
String urlDecode(String s){
  int i, p, q;
   var ol = new List<int>();
   for (i = 0; i < s.length; i++) {
     if (s[i].codeUnitAt(0) == 0x2b) { ol.add(0x20); // convert + to space
     } else if (s[i].codeUnitAt(0) == 0x25) {        // convert hex bytes to a single bite
       i++;
       p = s[i].toUpperCase().codeUnitAt(0) - 0x30;
       if (p > 9) p = p - 7;
       i++;
       q = s[i].toUpperCase().codeUnitAt(0) - 0x30;
       if (q > 9) q = q - 7;
       ol.add(p * 16 + q);
     }
     else { ol.add(s[i].codeUnitAt(0));
     }
   }
  return utf.decodeUtf8(ol);
}

// URL encoder encodes string into url encoded utf-8 bytes
// Use this method to encode cookie string
// or to write URL encoded byte data into OutputStream
List<int> urlEncode(String s) {
  int i, p, q;
  var ol = new List<int>();
  List<int> il = utf.encodeUtf8(s);
  for (i = 0; i < il.length; i++) {
    if (il[i] == 0x20) { ol.add(0x2b);  // convert sp to +
    } else if (il[i] == 0x2a || il[i] == 0x2d || il[i] == 0x2e || il[i] == 0x5f) { ol.add(il[i]);  // do not convert
    } else if (((il[i] >= 0x30) && (il[i] <= 0x39)) || ((il[i] >= 0x41) && (il[i] <= 0x5a)) || ((il[i] >= 0x61) && (il[i] <= 0x7a))) { ol.add(il[i]);
    } else { // '%' shift
      ol.add(0x25);
      ol.add((il[i] ~/ 0x10).toRadixString(16).codeUnitAt(0));
      ol.add((il[i] & 0xf).toRadixString(16).codeUnitAt(0));
    }
  }
  return ol;
}

// To test functions urlEncode and urlDecode, replace main() with:
/*
void main() {
  String s = "√2 is 1.414";
  // will be encoded as : %E2%88%9A2+is+1.414
  List encodedList = urlEncode(s);
  String encodedString = new String.fromCharCodes(encodedList);
  print("URL encoded string : $encodedString");
  String decodedString = urlDecode(encodedString);
  print("URL decoded string : $decodedString");
}
*/