main() {
  DateTime now = new DateTime.now();
  switch(now.weekday) {
    case (DateTime.SUN): print('hobby'); break;
    case (DateTime.SAT): print('sleep'); break;
    default:         print('work!');
  }
}