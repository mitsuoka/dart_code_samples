class Person {
  String firstName, lastName;
  Person(this.firstName, this.lastName);
}

class Puppy {
  final bool cuddly = true;
}

main() {
  var spot = new Puppy();
  var alice = new Person("Alice", "Smith");
  var petOwners = new Map();
  petOwners[alice] = spot;
  print(petOwners[alice].cuddly); // true
}