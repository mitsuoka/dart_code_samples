import 'dart:html';
import 'dart:convert';
const LOG_REQUESTS = true;

void main() {
  querySelector("#submitButton1").onClick.listen((_){clicked(1);});
  querySelector("#submitButton2").onClick.listen((_){clicked(2);});
}

void clicked(int button){
  var uri;
  if (button == 1){
    SelectElement smenu = document.getElementById("selectMenu");
    if (smenu == null) uri = ""; else uri = smenu.value;
  } else {
    TextAreaElement ta = document.getElementById("textArea");
    uri = ta.value;
  }
  logFresh('URI : $uri');
  if (uri != "") doGetData(uri);
}

void doGetData(String uri){
  HttpRequest request = new HttpRequest();
  // add an event handler that is called when the request finishes
  HttpRequest.getString(uri)
    .then((String text) {
      log('received response from the server');
      log('response text : ${text}');
      log('jsonObject : ${JSON.decode(text)}');
    })
    .catchError((Error error) {
      log('Error :');
      log('status : ${request.statusText}');
      log('response headers : \n${request.responseHeaders}');
      log('response text : ${request.responseText}');
    });
}

void log(message) {
  if(LOG_REQUESTS) {
    print(message);
    querySelector("#log").innerHtml = querySelector("#log").innerHtml + "\n$message";
  }
}

void logFresh(message) {
  if(LOG_REQUESTS) {
    print(message);
    querySelector("#log").innerHtml = "Log Messages:\n$message";
  }
}