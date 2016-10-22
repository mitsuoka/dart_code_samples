import 'dart:html';
import 'dart:convert' show JSON;
import 'dart:async';

final LOG_REQUESTS = true;
const host = 'api.openweathermap.org/data/2.5';
final int numberOfDays = 3;
final APPID = '1a1a27e8eccf4158d52c5763415c8121';

void main() {
  SelectElement smenu = document.getElementById("selectMenu");
  String  cityCode = smenu.value;
  onRequested(cityCode);
  smenu.onChange.listen((ev){
    cityCode = smenu.value;
    onRequested(cityCode);
  });
}

void onRequested(String cityCode){
  loadCurrent(cityCode).then((jsonObj){
    log('received JSON object : ${jsonObj}');
    currentDom(jsonObj);
    loadForecast(cityCode).then((jsonObj){
      log('received JSON object : ${jsonObj}');
      forecastDom(jsonObj);
    });
  });
}

Future<Map> loadCurrent(String cityCode){
  var url = 'http://${host}/weather?id=${cityCode}&APPID=$APPID';
  return loadData(url);
}

Future<Map> loadForecast(String cityCode){
  var url = 'http://${host}/forecast/daily?id=${cityCode}&units=metric&cnt=${numberOfDays}&APPID=$APPID';
  return loadData(url);
}

//call the server asynchronously and return jsonObject as Map
Future<Map> loadData(String url) {
  var completer = new Completer();
  var request = HttpRequest.getString(url, withCredentials: false)
    .then((responseText) {
      log('JSON data from the server $url : $responseText');
      completer.complete(JSON.decode(responseText));
    })
    .catchError((error) {
      print('requested data is not available : $error');
    });
  return completer.future;
}

/**
create a dynamic HTML page
*/

currentDom(Map json) {
  try{
    var cell = document.getElementById('text1Cell');
    cell.innerHtml = '${json["name"]} ${json["sys"]["country"]}';
    var img = document.getElementById('image');
    img.src='http://openweathermap.org/img/w/${json["weather"][0]["icon"]}.png';
    cell = document.getElementById('text2Cell');
    cell.innerHtml = '${json["weather"][0]["main"]}<br>${json["weather"][0]["description"]}';
    cell = document.getElementById('text3Cell');
    var sunrise = new  DateTime.fromMillisecondsSinceEpoch(json["sys"]["sunrise"]*1000,  isUtc: false);
    var sunset = new  DateTime.fromMillisecondsSinceEpoch(json["sys"]["sunset"]*1000,  isUtc: false);
    cell.innerHtml = '''Temperature : ${((json["main"]["temp"]-273.15)*10).round()/10}°C
      <br>Pressure : ${json["main"]["pressure"]}hPa
      <br>Humidity : ${json["main"]["humidity"]}%
      <br>Minimum temperature : ${((json["main"]["temp_min"]-273.15)*10).round()/10}°C
      <br>Maximum temperature : ${((json["main"]["temp_max"]-273.15)*10).round()/10}°C
      <br>Sunrise time : ${sunrise.hour}:${sunrise.minute}
      <br>Sunset time :  ${sunset.hour}:${sunset.minute}''';
    cell = document.getElementById('text4Cell');
    cell.innerHtml = 'Data received : ${new  DateTime
      .fromMillisecondsSinceEpoch(json["dt"]*1000,  isUtc: false).toString().substring(0, 16)}';
  }catch (err, st){
    print('$err \n $st');
  }
}

forecastDom(Map json){
  try{
    var cell = document.getElementById('subTitle');
    cell.innerHtml = '<br>Three day forecast<br>${json["city"]["name"]} ${json["city"]["country"]}';
    TableElement table = document.getElementById('forecastTable');
    while (table.rows.length != 0) table.deleteRow(0);
    for (int i = numberOfDays-1; i >= 0; i--) {
      var row = table.insertRow(0);
      Element tdElement = new Element.tag('td'); tdElement.id ="text1Cell";
      var st='<br>${new  DateTime.fromMillisecondsSinceEpoch
        (json["list"][i]["dt"]*1000,  isUtc: false).toString().substring(0, 16)}';
      tdElement.innerHtml = st;
      row.append(tdElement);
      row = table.insertRow(1);
      tdElement = new Element.tag('td'); tdElement.id ="imageCell";
      var img = document.createElement("IMG");
      img.src='http://openweathermap.org/img/w/${json["list"][i]["weather"][0]["icon"]}.png';
      tdElement.children = [img];
      row.append(tdElement);
      row = table.insertRow(2);
      tdElement = new Element.tag('td'); tdElement.id ="text2Cell";
      tdElement.innerHtml = '${json["list"][i]["weather"][0]["main"]}<br>'
                          + '${json["list"][i]["weather"][0]["description"]}';
      row.append(tdElement);
      row = table.insertRow(3);
      tdElement = new Element.tag('td'); tdElement.id ="text3Cell";
      st = '''Day temperature : 
          ${(json["list"][i]["temp"]["day"]*10).round()/10}°C<br>
          Night temperature : 
          ${(json["list"][i]["temp"]["night"]*10).round()/10}°C<br>
          Humidity : ${json["list"][i]["humidity"]}%<br>
          Atmospheric pressure : ${json["list"][i]["pressure"]}hPa''';
      if (i != numberOfDays - 1) st = st + '<br><br>';
      tdElement.innerHtml = st;
      row.append(tdElement);
      row = table.insertRow(4);
    }
  }catch (err, st){
    print('$err \n $st');
  }
}


String format1(String str){
  str=str.substring(0, str.length-8);
  return str.replaceAll('T',' ');
}

void log(message) {
  if(LOG_REQUESTS) {
    print(message);
  }
}
