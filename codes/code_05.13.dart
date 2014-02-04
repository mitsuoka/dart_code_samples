//Expando Sample
class Person {
  String name;
  Person(this.name);
}
main() {
  var me = new Person('Terry');
  var nationality = new Expando();
  nationality[me] = 'Japan';
  print('${me.name} : ${nationality[me]}');
  var age = new Expando();
  age[me] = {'age': 50};
  print('${me.name} : ${age[me]["age"]}');
}
/*
Terry : Japan
Terry : 50
*/