/**
 * Simple Proxy Server
 * This proxy logs socket connections and all data passing through it.
 * Received data will be converted into readable ASCII strings
 * (Unprintable ASCII characters are replaced with '?') before being logged.
 *
 * 1) Start your server with http://localhost:8080/yourApp....
 * 2) Start this proxy
 * 3) Call your app from your browser with http://localhost:12345/yourApp...
 *
 * Aug. 2015, Cresc Corp.
 */

import 'dart:io';
import 'dart:async';

// modify here to set following parameters using command line arguments
var serverHost = InternetAddress.LOOPBACK_IP_V4;
int proxyPort = 12345;
int serverPort = 8080;

// active connections map
var connections = {};

main() {
  try {
    ServerSocket.bind(serverHost, proxyPort).then((server) {
      log("Proxy is waiting for client's request on $serverHost:$proxyPort");
      server.listen((newClientSocket) {
        log('New client connection ${newClientSocket.hashCode}');
        // new client connection, connect to your server
        connectToServer(newClientSocket).then((_) {
          // set inbound callback
          setInboundCallback(newClientSocket, connections[newClientSocket]);
          logCurrentConnections(); // **** this is optional ****
        });
      });
    });
  } catch (e, st) {
    log('Exception! $e \nStack Trace :\n$st');
  }
}

// connect to the server and set call back for outbound data
Future connectToServer(Socket clientSocket) {
  var completer = new Completer();
  Socket.connect(serverHost, serverPort).then((serverSocket) {
    log('Proxy establised a connection for incomig socket ${clientSocket.hashCode}'
      ' with server socket ${serverSocket.hashCode}');
    connections[clientSocket] = serverSocket; // add to the connection table
    // set outbound call back here
    serverSocket.listen((outboundData) {
      processOutbound(clientSocket, serverSocket, outboundData);
    }, onDone: () {
      log('Server side socket disconnected (${clientSocket.hashCode}, ${serverSocket.hashCode})');
      clientSocket.destroy();
      connections.remove(clientSocket);
  //  logCurrentConnections(); // **** for debugging ****
    }, onError: (e) {
      log('Failed to receive server data: $e');
    });
    completer.complete(1);
  }).catchError((e) {
    log('Connection error: failed to connect ${clientSocket.hashCode} to the server');
  });
  return completer.future;
}

// set callback for inbound data
setInboundCallback(Socket clientSocket, Socket serverSocket) {
  clientSocket.listen((inboundData) {
    processInbound(clientSocket, serverSocket, inboundData);
  }, onDone: () {
    log('Client side socket disconnected (${clientSocket.hashCode}, ${serverSocket.hashCode})');
    serverSocket.destroy();
    connections.remove(clientSocket);
    logCurrentConnections(); // **** for debugging ****
  }, onError: (e) {
    log('Failed to receive client data: $e');
  });
  return;
}

// process socket data
processInbound(Socket clientSocket, Socket serverSocket, List<int> inboundData) {
  log('** connection (${clientSocket.hashCode}, ${serverSocket.hashCode}) inbound traffic **\n'
    + bytesToAscii(inboundData).toString());
  try {
    serverSocket.add(inboundData);
  } catch (e) {
    log('Failed to send data to server: $e');
  }
}

processOutbound(Socket clientSocket, Socket serverSocket, List<int> outboundData) {
  log('** connection (${clientSocket.hashCode}, ${serverSocket.hashCode}) outbound traffic **\n'
    + bytesToAscii(outboundData).toString());
  try {
    clientSocket.add(outboundData);
  } catch (e) {
    log('Failed to send data to client: $e');
  }
}

// convert List<int> data into printable ASCII string
//  unreadable codes are replaced with '?'
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

// log out a message with timestamp
void log(String msg) {
  String timestamp = new DateTime.now().toString().substring(11);
  print('$timestamp : $msg');
}


// log out current connections for debug
void logCurrentConnections() {
  var msg = 'Current connections (client side socket, server side socket) :\n';
  if (connections.isEmpty) msg += '  none\n';
  else {
    connections.forEach((client, server) {
      msg += '  (${client.hashCode}, ${server.hashCode})\n';
    });
  }
  log(msg);
}
