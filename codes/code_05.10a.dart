main() {
  int x = 0xffffffff;
  int y = 4;
  print(x);      // 4294967295
  print(x >> y); // 268435455
  print(x << y); // 68719476720
  x = -0x7ffffff;
  print(x);      // -134217727
  print(x >> y); // -8388607
  print(x << y); // -2147483632
}