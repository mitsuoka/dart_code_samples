/**
 * Simple Proxy Server
 * This proxy only logs all data passing through it. This is only
 * suitable for text based protocols since received data will be
 * converted into readable ASCII strings before being logged.
 * Aug. 2015, Cresc Corp.
 */

import 'dart:io';
import 'dart:async';

var serverHost = InternetAddress.LOOPBACK_IP_V4;
int proxyPort = 12345;
int serverPort = 8080;
Socket clientSideSocket, serverSideSocket;

main() {
  try {
    ServerSocket.bind(serverHost, proxyPort).then((server) {
      log("Proxy is waiting for client's request on $serverHost:$proxyPort");
      server.listen((serverSocket){
        // new client connection, connect to server if necessary
        connectToServer().then((_) {
          // close previous client socket if necessary
          closePreviousSocket(serverSocket).then((_){
          });
        });
      });
    });
  } catch (e, st) {log('Exception! $e \nStack Trace :\n$st');}
}

// connect to the server
Future connectToServer() {
  var completer = new Completer();
  if (serverSideSocket == null) {
  Socket.connect(serverHost, serverPort).then((serverSocket) {
    log('Proxy connected to the server with $serverHost:$serverPort');
    serverSideSocket = serverSocket;
    // set outbound call back here
    serverSideSocket.listen((outboundData) {
      processOutbound(outboundData);}
    ,onError:(e){
      log('Failed to receive server data: $e');
    });
    completer.complete(1);
  }).catchError((e) {
    log('Connection error: $e\nStart server and restart this proxy');
  });
  } else completer.complete(1);  //already connected
  return completer.future;
}

// close previous client socket
Future closePreviousSocket(Socket clientSocket) {
  var completer = new Completer();
  if (clientSideSocket != null && clientSideSocket != clientSocket){
    clientSideSocket.close().then((_) {
      clientSideSocket = clientSocket;
      // set inbound callback here
      clientSideSocket.listen((inboundData) {
        processInbound(inboundData);}
      ,onError:(e){
        log('Failed to receive client data: $e');
      });
      completer.complete(2);
    });
  } else {
    clientSideSocket = clientSocket;
    completer.complete(2);
    // set inbound callback here also
    clientSideSocket.listen((inboundData) {
      processInbound(inboundData);}
    ,onError:(e){
      log('Failed to receive client data: $e');
    });
  }
  return completer.future;
}


// process socket data
processInbound(List<int> inboundData) {
  log('** inbound traffic **\n' + bytesToAscii(inboundData).toString());
  try {
    serverSideSocket.add(inboundData);
  } catch (e){
    log('Failed to send data to server: $e');
  }
}

processOutbound(List<int> outboundData) {
  log('** outbound traffic **\n' + bytesToAscii(outboundData).toString());
  try {
    clientSideSocket.add(outboundData);
  } catch (e){
    log('Failed to send data to client: $e');
  }
}

// convert List<int> data into printable ASCII string
//  unreadable codes are replaced with '?'
StringBuffer bytesToAscii(List<int> bytes) {
  var sb = new StringBuffer();
  int b;
  for (int i=0; i<bytes.length; i++) {
    b = bytes[i];
    if (b >= 0x7f || b <= 0x1f) b = 0x3f; // unreadable
    if (bytes[i] == 0x0a) b = 0x0a; // LF
    if (bytes[i] == 0x0d) b = 0x0d; // CR
    sb.writeCharCode(b);
  }
  return sb;
}

void log(String msg) {
  String timestamp = new DateTime.now().toString().substring(11);
  print('$timestamp : $msg');
}
