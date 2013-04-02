// calculate day of the week
String getDayOfWeek(days) {
  if (days % 7 == 0) {
    return "Sunday";
  } else if (days % 7 == 1) {
      return "Monday";
  } else if (days % 7 == 2) {
      return "Tuesday";
  } else if (days % 7 == 3) {
      return "Wednesday";
//  } else if (days % 7 == 4) {
//      return "Thursday";
  } else if (days % 7 == 5) {
      return "Friday";
  } else {
      assert (days % 7 == 6);
    return "Saturday";
  };
}

main() {
  try{
    print(getDayOfWeek(5));
    print(getDayOfWeek(4));
  }on Exception catch(e){
    print(e.toString());
  }
}
/*
ckecked mode: 
 Friday
 Failed assertion
productionmode: 
 Friday
 Saturday
*/