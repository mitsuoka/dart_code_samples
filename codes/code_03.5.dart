String sayHello(String msg, String to) {
  String importantify(msg) => '!!! ${msg} !!!';
  return '${importantify(msg)} to ${to}';
}
main(){
  print(sayHello('Urgent', 'Bill'));
}
/*
!!! Urgent !!! to Bill
*/
