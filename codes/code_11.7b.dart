main() {
  loopExit:
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 5; j++){
      print('$i, $j');
        if (i == 2 && j ==2) {
          break loopExit;
        }
     }
  }
}