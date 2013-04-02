import 'dart:isolate';

ReceivePort receiver;
SendPort sender;

void receiverJob(){
  receiver.receive((message, replyTo){
    if (replyTo != null) {
      print('着信メッセージ”$message”に対し${replyTo.hashCode}に返信中');
      replyTo.send('着信メッセージ”$message”に対する返信', receiver.toSendPort());
    } else {
      print('着信メッセージ：”$message”');
      receiver.close();
    }
  });
}

void senderJob(){
  sender.send('送信側からのメッセージその1', sender);
  sender.call('送信側からのメッセージその2');
  sender.send('送信側からのメッセージその3：返信不要');
}

main() {
  receiver = new ReceivePort();
  sender = receiver.toSendPort();
  receiverJob();
  senderJob();
}

/*
着信メッセージ”送信側からのメッセージその1”に対し257に返信中
着信メッセージ”送信側からのメッセージその2”に対し258に返信中
着信メッセージ：”送信側からのメッセージその3：返信不要”
*/