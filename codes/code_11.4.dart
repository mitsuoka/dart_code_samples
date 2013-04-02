main() {
  int i = 0;
  int j = 1;
  do {
    j += j;
    i++;
  }
  while (i < 8);
  print(j);  // 256
}