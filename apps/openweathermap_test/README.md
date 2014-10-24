openweathermap\_test
==

**openweathermap\_test** is a Dart sample [OpenWeatherMap](http://openweathermap.org/) web service test application. Use this sample code to develop your mashup applications with Dart. This is a code
 sample and an attachment
to the ["Dart Language Gide"](http://www.cresc.co.jp/tech/java/Google_Dart/DartLanguageGuide.pdf) written in Japanese.

このリポジトリは[「プログラミング言語 Dartの基礎」](http://www.cresc.co.jp/tech/java/Google_Dart/DartLanguageGuide_about.html)の添付資料であり、「RESTfulウェブ・サービスとDart (Dart in RESTful web services)」の「ブラウザだけでのアプリケーション」の節で解説されています。この節ではサービスへの登録や専用のAPIが不要なウェブ・サービスを使った簡単なアプリケーションのクライアントのコード例を示しています。


### Installing ###

1. Download and uncompress  this repository.
2. From Dart Editor, File > Open Existing Folder and select this openweathermap\_test folder.
3. Select Tools > Pub Install to install pub libraries.

### Try it ###

1. Run the  weather.html in the \web folder in Dartium (or, Chrome as Javascript). Weather data (current and forecast) of the pre-selected city will be displayed.
2. To see data of another city, select the city from the selection menu.
3. Use JavaScript console of the browser (Control -Shift -J (Windows/Linux)) to see the JSON data from the server.  You can use online JSON editors like [http://www.jsoneditoronline.org/](http://www.jsoneditoronline.org/) to analize the data. Please refer to the [API document](http://openweathermap.org/api).
4. ID of the city you want to see will be available from [here](http://openweathermap.org/help/city_list.txt).
5. Change the numberOfDays value to get longer (up to 16 days) forecasts.

Note: Date and time are displayed as your local time.


### License ###
This sample is licensed under [MIT License][MIT].
[MIT]: http://www.opensource.org/licenses/mit-license.php