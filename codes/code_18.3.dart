import 'dart:isolate';

class Sender {
  SendPort sendPort;
  String senderId;
  Sender(SendPort sendPort, String senderId) {
    this.sendPort = sendPort;
    this.senderId = senderId;
  }
  run() {
      sendPort.send('received messaage from $senderId');
  }
}

main() {
  var receivePort = new ReceivePort();
  receivePort.forEach((msg) {
    print(msg);
    if(msg.endsWith('#2')) {
      receivePort.close();
    }
  });
  new Sender(receivePort.sendPort, 'sender #1').run();
  new Sender(receivePort.sendPort, 'sender #2').run();
  new Sender(receivePort.sendPort, 'sender #3').run();
}