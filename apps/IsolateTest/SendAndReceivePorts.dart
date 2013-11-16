import 'dart:isolate';
import 'dart:async';

ReceivePort receiver;
SendPort sender;

void receiverJob(){
  receiver.listen((List msg){
    if (msg.length == 2) {
      print('着信メッセージ”${msg[0]}”に対し${msg[1].hashCode}に返信中');
      msg[1].send(['着信メッセージ”${msg[0]}”に対する返信']);
    } else {
      print('着信メッセージ：”${msg[0]}”');
    }
  });
}

void senderJob(){
  sender.send(['送信側からのメッセージその1', sender]);
  sender.send(['送信側からのメッセージその2：返信不要']);
}

main() {
  receiver = new ReceivePort();
  sender = receiver.sendPort;
  receiverJob();
  senderJob();
  new Timer(new Duration(seconds:1), (){receiver.close();});
}

/*
着信メッセージ”送信側からのメッセージその1”に対し134219827に返信中
着信メッセージ：”送信側からのメッセージその2：返信不要”
着信メッセージ：”着信メッセージ”送信側からのメッセージその1”に対する返信”
*/