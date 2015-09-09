// source: http://stackoverflow.com/questions/15854549/how-can-i-build-an-enum-with-dart

enum Status {
  none,
  running,
  stopped,
  paused
}

void main() {
  print(Status.values);
  Status.values.forEach((v) => print('value: $v, index: ${v.index}'));
  print('running: ${Status.running}, ${Status.running.index}');
  print('running index: ${Status.values[1]}');
}
/*
[Status.none, Status.running, Status.stopped, Status.paused]
value: Status.none, index: 0
value: Status.running, index: 1
value: Status.stopped, index: 2
value: Status.paused, index: 3
running: Status.running, 1
running index: Status.running
*/