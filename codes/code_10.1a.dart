main(){
  int a;
  print(a);
  a = null;
  print(a);
  a = 1;  // deleting this line will cause NullPointerException
  a++;
  print(a);
}
/*
null
null
2
*/