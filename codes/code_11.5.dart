main() {
  DateTime now = new DateTime.now();
  switch(now.weekday) {
    case (DateTime.SUNDAY): print('hobby'); break;
    case (DateTime.SATURDAY): print('sleep'); break;
    default: print('work!');
  }
}