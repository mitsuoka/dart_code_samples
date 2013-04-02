class FieldTest {
  int minimum, maximum;  // null
  String name = 'Cresc'; // String constant
  DateTime today = new DateTime.now(); // Error, expected constant expression
}
main() {
  var ft = new FieldTest();
  print('${ft.name}, ${ft.today}');
}