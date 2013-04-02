final a = {'x': 1};
main() {
  print('final a = $a');
  a['y'] = 2;
  print('manipulated a = $a');
}
/*
a = {x: 1}
manipulated a = {x: 1, y: 2}
*/