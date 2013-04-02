final variable = 1; // single assignment
class A {
  final variable;
  A(this.variable); // initializer
}
main() {
//  variable += 1; // Error: cannot assign value to final variable "variable"
//  new A(2).variable = 3;  // Error: field variable is final
}