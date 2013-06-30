/* 挨拶*/
void sayGreeting(String name, {String salutation : 'Hello', String exclamation : '!'}) {
  String greeting = '$salutation $name$exclamation';
  print(greeting);
}
main() {
  sayGreeting('Bill');
  sayGreeting('Tom', salutation: 'Hi');
  sayGreeting('Alia', exclamation: '!!', salutation: 'Good Morning');
  // The following are all valid.
  connectToServer('secret');
  connectToServer('secret', '1.2.3.4');
  connectToServer('secret', '1.2.3.4', 9999);

}
connectToServer(String authKey, [ip = '127.0.0.1', port = 8080]) {
  print('aunthKey = $authKey, ip = $ip, port = $port');
}

/*
Hello Bill!
Hi Tom!
Good Morning Alia!!
aunthKey = secret, ip = 127.0.0.1, port = 8080
aunthKey = secret, ip = 1.2.3.4, port = 8080
aunthKey = secret, ip = 1.2.3.4, port = 9999
*/