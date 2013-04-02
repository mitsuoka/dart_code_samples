abstract class Quackable {
  Quackable();
  quack();
}
class MockDuck implements Quackable{
  quack()=> print("quack");
}
void main(){
new MockDuck().quack();
}
/*
quack
*/