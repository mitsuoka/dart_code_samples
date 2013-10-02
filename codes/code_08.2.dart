// Run this code in production mode and checked mode.
class A<T> {
  final T a;
  A(T this.a);
  String toString(){return 'class A object, a = $a';}
}

int main(){
  A x = new A<int>(3.14); // Warning: double is not assignable to int
  print(x.a is int);
  print(x.toString());
  x = new A<String>('Hi');
  print(x.toString());
}
/*
false
class A object, a = 3.14
class A object, a = Hi
*/