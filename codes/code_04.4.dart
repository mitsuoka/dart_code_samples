/* 摂氏と華氏の変換 */
tempUnitConvert(var temp, consoleOut, {bool toFahrenheit : true}) {
  var tempC, tempF;
  if (toFahrenheit){
    tempC = temp; tempF = tempC * 9 / 5 + 32;
  } else {
    tempF = temp; tempC = (tempF - 32) * 5 / 9;
  }
  String result = 'Celsius: $tempC,  Fahrenheit: $tempF';
  consoleOut(result);
}
main(){
  tempUnitConvert(32, (str){print(str);}, toFahrenheit: false);
  tempUnitConvert(32, (str){print('--- $str ---');});
}

/*
Celsius: 0,  Fahrenheit: 32
--- Celsius: 32,  Fahrenheit: 89.6 ---
*/
