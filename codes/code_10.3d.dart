main(){
  var list = new List.filled(3, new List.filled(3, 0));
  list[0][0] = 1;
  list[1][1] = 2;
  list[2][2] = 3;
  print(list);
}
// [[1, 0, 0], [0, 2, 0], [0, 0, 3]]