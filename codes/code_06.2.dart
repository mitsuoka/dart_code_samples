abstract class Describable {
  void describe();
  void describeWithEmphasis() {
    print('========');
    describe();
    print('========');
  }
}

class MyTitle extends Describable {
  void describe() => print("General Manager");
}
class MySubtitle implements Describable {
  void describe() => print("Development Division");
  void describeWithEmphasis() {
    print('********');
    describe();
    print('********');
  }
}

main(){
  new MyTitle().describeWithEmphasis();
  new MySubtitle().describeWithEmphasis();
}