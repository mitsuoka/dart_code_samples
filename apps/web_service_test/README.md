web\_service\_test
==

**web\_service\_test** is a Dart sample REST web service test application. You can test weather an web is accessible from your browser. This is a code
 sample and an attachment
to the ["Dart Language Gide"](http://www.cresc.co.jp/tech/java/Google_Dart/DartLanguageGuide.pdf) written in Japanese.

このリポジトリは[「プログラミング言語 Dartの基礎」](http://www.cresc.co.jp/tech/java/Google_Dart/DartLanguageGuide_about.html)の添付資料であり、「RESTfulウェブ・サービスとDart (Dart in RESTful web services)」の「ブラウザだけでのアプリケーション」の節で解説されています。この節ではサービスへの登録が不要なウェブ・サービスを使った簡単なアプリケーションのクライアントのコード例を示しています。


### Installing ###

1. Download and uncompress  this repository.
2. From Dart Editor, File > Open Existing Folder and select this web\_service\_test folder.
3. Select Tools > Pub Install to install pub libraries.

### Try it ###

1. Run the  web\_service\_test.html in the \web folder in Dartium (or, Chrome as Javascript).
2. Select URI from the selection menu and click the Submit button.
3. Or, enter the URL into the text box and click the Submit button.
4. If successful, returned response will be displayed in the Log area (and JavaScript console also).
5. You can use online JSON editors like [http://www.jsoneditoronline.org/](http://www.jsoneditoronline.org/) to analize the data.
6. Use JavaScript console of the browser (Control -Shift -J (Windows/Linux)) to see if a CORS error (No 'Access-Control-Allow-Origin' header is present on the requested resource.) occured .


### License ###
This sample is licensed under [MIT License][MIT].
[MIT]: http://www.opensource.org/licenses/mit-license.php