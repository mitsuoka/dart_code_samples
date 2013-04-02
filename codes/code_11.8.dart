main() {
  var x = 0;
  var y = 0;
  outerLoop:
    for(;;) {
    x++;
    innerLoop:
    for(y = 0; y < 10; y++) {
      if (x == 9 ) break outerLoop;  // quit outer loop
      if (y > 3) break;              // Quit the innermost loop
      if (x == 2) break innerLoop;   // Do the same thing
      if (x == 4) continue outerLoop;     // new outer loop test
      if ((x >= 7) && (x < 9)) continue;  // new inner loop test
      print('x = $x, y = $y');
    }
  }
  print('At end : x = $x, y = $y');
}
/*
x = 1, y = 0
x = 1, y = 1
x = 1, y = 2
x = 1, y = 3
x = 3, y = 0
x = 3, y = 1
x = 3, y = 2
x = 3, y = 3
x = 5, y = 0
x = 5, y = 1
x = 5, y = 2
x = 5, y = 3
x = 6, y = 0
x = 6, y = 1
x = 6, y = 2
x = 6, y = 3
At end : x = 9, y = 0
*/
