// Dart code sample : Status line setting and HTTP response
// Returns a response with required status line
// 1. Create a folder named StatusLineTest
// 2. Put StatusLineTest.dart and StatusLineTest.html into the folder
// 3. From Dart editor, File -> Open Folder, and select the StatusLineTest folder
// 4. Run StatusLineTest.dart as server
// 5. Access file:///c:/..../StatusLineTest/StatusLineTest.html from your browser
// 6. Select a status code and test response of available browsers
// Ref: www.cresc.co.jp/tech/java/Google_Dart/DartLanguageGuide.pdf (in Japanese)
// May 2012, by Cresc Corp.
// September 2012, incorporated API change (dart:math)
// October 2012, incorporated M1 changes
// February 2013, incorporated M3 changes
// March 2013, HttpResponse API change fixed

import "dart:io";
import 'dart:math' as Math;

final HOST = "127.0.0.1";
final PORT = 8080;
final REQUEST_PATH = "/StatusLineTest";
final LOG_REQUESTS = true;

void main() {
  HttpServer.bind(HOST, PORT)
  .then((HttpServer server) {
    server.listen(
        (HttpRequest request) {
          if (request.uri.path == REQUEST_PATH) {
            requestReceivedHandler(request);
          }
        });
    print("Serving $REQUEST_PATH on http://${HOST}:${PORT}.");
  });
}

void requestReceivedHandler(HttpRequest request) {
  HttpResponse response = request.response;
  logRequest(request);
  int status = int.parse(request.queryParameters['raioButton']); // get status code from the query

  List statusCode;
  if (status == 100) { statusCode = [HttpStatus.CONTINUE, '100 Continue', 'The client SHOULD continue with its request.'];
  } else if (status == 101) { statusCode = [HttpStatus.SWITCHING_PROTOCOLS, '101 Switching Protocols', 'The server understands and is willing to comply with the client\'s request, via the Upgrade message header field (section 14.42), for a change in the application protocol being used on this connection.'];
  } else if (status == 200) { statusCode = [HttpStatus.OK, '200 OK', 'The request has succeeded.'];
  } else if (status == 201) { statusCode = [HttpStatus.CREATED, '201 Created', 'The request has been fulfilled and resulted in a new resource being created.'];
  } else if (status == 202) { statusCode = [HttpStatus.ACCEPTED, '202 Accepted', 'The request has been accepted for processing, but the processing has not been completed.'];
  } else if (status == 203) { statusCode = [HttpStatus.NON_AUTHORITATIVE_INFORMATION, '203 Non-Authoritative Information', 'The returned metainformation in the entity-header is not the definitive set as available from the origin server, but is gathered from a local or a third-party copy.'];
  } else if (status == 204) { statusCode = [HttpStatus.NO_CONTENT, '204 No Content', 'The server has fulfilled the request but does not need to return an entity-body, and might want to return updated metainformation.'];
  } else if (status == 205) { statusCode = [HttpStatus.RESET_CONTENT, '205 Reset Content', 'The server has fulfilled the request and the user agent SHOULD reset the document view which caused the request to be sent.'];
  } else if (status == 206) { statusCode = [HttpStatus.PARTIAL_CONTENT, '206 Partial Content', 'The server has fulfilled the partial GET request for the resource.'];
  } else if (status == 300) { statusCode = [HttpStatus.MULTIPLE_CHOICES, '300 Multiple Choices', 'User (or user agent) can select a preferred representation and redirect its request to that location.'];
  } else if (status == 301) { statusCode = [HttpStatus.MOVED_PERMANENTLY, '301 Moved Permanently', 'The requested resource has been assigned a new permanent URI and any future references to this resource SHOULD use one of the returned URIs.'];
  } else if (status == 302) { statusCode = [HttpStatus.FOUND, '302 Found', 'The requested resource resides temporarily under a different URI.'];
  } else if (status == 303) { statusCode = [HttpStatus.SEE_OTHER, '303 See Other', 'The response to the request can be found under a different URI and SHOULD be retrieved using a GET method on that resource.'];
  } else if (status == 304) { statusCode = [HttpStatus.NOT_MODIFIED, '304 Not Modified', 'If the client has performed a conditional GET request and access is allowed, but the document has not been modified, the server SHOULD respond with this status code.'];
  } else if (status == 305) { statusCode = [HttpStatus.USE_PROXY, '305 Use Proxy', 'The requested resource MUST be accessed through the proxy given by the Location field.'];
  } else if (status == 307) { statusCode = [HttpStatus.TEMPORARY_REDIRECT, '307 Temporary Redirect', 'The requested resource resides temporarily under a different URI.'];
  } else if (status == 400) { statusCode = [HttpStatus.BAD_REQUEST, '400 Bad Request', 'The request could not be understood by the server due to malformed syntax.'];
  } else if (status == 401) { statusCode = [HttpStatus.UNAUTHORIZED,'401 Unauthorized', 'The request requires user authentication.'];
  } else if (status == 403) { statusCode = [HttpStatus.FORBIDDEN,'403 Forbidden', 'The server understood the request, but is refusing to fulfill it.'];
  } else if (status == 404) { statusCode = [HttpStatus.NOT_FOUND, '404 Not Found', 'The server has not found anything matching the Request-URI.'];
  } else if (status == 405) { statusCode = [HttpStatus.METHOD_NOT_ALLOWED, '405 Method Not Allowed', 'The method specified in the Request-Line is not allowed for the resource identified by the Request-URI.'];
  } else if (status == 406) { statusCode = [HttpStatus.NOT_ACCEPTABLE, '406 Not Acceptable', 'The resource identified by the request is only capable of generating response entities which have content characteristics not acceptable according to the accept headers sent in the request.'];
  } else if (status == 407) { statusCode = [HttpStatus.PROXY_AUTHENTICATION_REQUIRED, '407 Proxy Authentication Required', 'This code is similar to 401 (Unauthorized), but indicates that the client must first authenticate itself with the proxy.'];
  } else if (status == 408) { statusCode = [HttpStatus.REQUEST_TIMEOUT, '408 Request Timeout', 'The client did not produce a request within the time that the server was prepared to wait.'];
  } else if (status == 409) { statusCode = [HttpStatus.CONFLICT, '409 Conflict', 'The request could not be completed due to a conflict with the current state of the resource.'];
  } else if (status == 410) { statusCode = [HttpStatus.GONE, '410 Gone', 'The requested resource is no longer available at the server and no forwarding address is known.'];
  } else if (status == 411) { statusCode = [HttpStatus.LENGTH_REQUIRED, '411 Length Required', 'The server refuses to accept the request without a defined Content- Length.'];
  } else if (status == 412) { statusCode = [HttpStatus.PRECONDITION_FAILED, '412 Precondition Failed', 'The precondition given in one or more of the request-header fields evaluated to false when it was tested on the server.'];
  } else if (status == 413) { statusCode = [HttpStatus.REQUEST_ENTITY_TOO_LARGE, '413 Request Entity Too Large', 'The server is refusing to process a request because the request entity is larger than the server is willing or able to process.'];
  } else if (status == 414) { statusCode = [HttpStatus.REQUEST_URI_TOO_LONG, '414 Request-URI Too Long', 'The server is refusing to service the request because the Request-URI is longer than the server is willing to interpret.'];
  } else if (status == 415) { statusCode = [HttpStatus.UNSUPPORTED_MEDIA_TYPE, '415 Unsupported Media Type', 'The server is refusing to service the request because the entity of the request is in a format not supported by the requested resource for the requested method.'];
  } else if (status == 416) { statusCode = [HttpStatus.REQUESTED_RANGE_NOT_SATISFIABLE, '416 Requested Range Not Satisfiable', 'A server SHOULD return a response with this status code if a request included a Range request-header field (section 14.35), and none of the range-specifier values in this field overlap the current extent of the selected resource, and the request did not include an If-Range request-header field.'];
  } else if (status == 417) { statusCode = [HttpStatus.EXPECTATION_FAILED, '417 Expectation Failed', 'The expectation given in an Expect request-header field (see section 14.20) could not be met by this server.'];
  } else if (status == 500) { statusCode = [HttpStatus.INTERNAL_SERVER_ERROR, '500 Internal Server Error', 'The server encountered an unexpected condition which prevented it from fulfilling the request.'];
  } else if (status == 501) { statusCode = [HttpStatus.NOT_IMPLEMENTED, '501 Not Implemented', 'The server does not support the functionality required to fulfill the request.'];
  } else if (status == 502) { statusCode = [HttpStatus.BAD_GATEWAY, '502 Bad Gateway', 'The server, while acting as a gateway or proxy, received an invalid response from the upstream server it accessed in attempting to fulfill the request.'];
  } else if (status == 503) { statusCode = [HttpStatus.SERVICE_UNAVAILABLE, '503 Service Unavailable', 'The server is currently unable to handle the request due to a temporary overloading or maintenance of the server.'];
  } else if (status == 504) { statusCode = [HttpStatus.GATEWAY_TIMEOUT, '504 Gateway Timeout', 'The server, while acting as a gateway or proxy, did not receive a timely response from the upstream server specified by the URI.'];
  } else if (status == 505) statusCode = [HttpStatus.HTTP_VERSION_NOT_SUPPORTED, '505 HTTP Version Not Supported', 'The server does not support, or refuses to support, the HTTP protocol version that was used in the request message.'];

  String statusPageHtml = """
<html><head>
<title>Status : ${statusCode[0]}</title>
</head><body>
<h1>${statusCode[1]}</h1>
<p>${statusCode[2]}</p>
</body></html>""";

  response.statusCode = statusCode[0];
  response.headers.add("Content-Type", "text/html; charset=UTF-8");
  response.write(statusPageHtml);
  response.close();
}

// log out contents of the request
void logRequest(HttpRequest request, [String bodyString = '']) {
  print(createLogMessage(request).toString());
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
request.uri.path : ${request.uri.path}
request.uri.query : ${request.uri.query}
request.uri.queryParameters :
''');
  request.queryParameters.forEach((key, value){
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
  sb.write("\n");
  return sb;
}
