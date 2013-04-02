main() {
  Map directory = const{'fire': 119, 'cops': 110, 'emergency': 120, 'time': 117};
  String s = 'time';
  if (directory.containsKey(s))
  print('$s? dial ${directory[s]}');
  else print('sorry, no number available for $s');
}
/*
time? dial 117
*/