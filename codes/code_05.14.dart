class Friendly {
  String name;
  Friendly(this.name);
  sayHi() {
    print("Hi, I'm $name!");
  }
}
main(){
  var friendly = new Friendly("Terry");
  var tearOff = friendly.sayHi; // メソッドの引き剥がし
  tearOff();
}