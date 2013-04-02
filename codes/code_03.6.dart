typedef String TempToText(var something);
String fromCelsius(var temp)
  => 'Celsius: $temp degreesC, Fahrenheit: ${temp*9/5+32} degreesF';
String fromFahrenheit(var temp)
  => 'Celsius: ${(temp-32)*5/9} degreesC, Fahrenheit: $temp degreesF';
void printTemp(var someTemp, TempToText whichMethod){
  print(whichMethod(someTemp));
}
main() {
  bool celsius = true; // unit of the someTemp
  var someTemp = 0;    // input temperature
  TempToText whichMethod;
  if (celsius) whichMethod = fromCelsius;
    else whichMethod = fromFahrenheit;
  printTemp(someTemp, whichMethod);
}
/*
Celsius: 0 degreesC, Fahrenheit: 32 degreesF
*/
