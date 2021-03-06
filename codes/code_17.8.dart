import 'dart:io';
import 'dart:convert'; // Sept. 30 2013, added this new library
final fileName = 'testData.txt';
final String testData = '''安倍晋三首相は２６日午前、政権発足から３カ月を迎えたことについて、
  「今までと同じように結果を出していくことに全力を尽くしていきたい」と述べた。''';

main() {
  // create a file to write
  File file = new File(fileName);
  // get IOSink to write data
  IOSink fileSink = file.openWrite(mode: FileMode.WRITE, encoding: UTF8);
  // and write the data using StringSink\write
  fileSink.write(testData);
  print('Done writing $file');
  fileSink.close();
  // read back the file
  file = new File(fileName);
  file.open(mode: FileMode.READ)
    .then((f){
      file.readAsString()
        .then((data) {
           print('Readbacked data : $data');
           f.close();
        })
        .catchError((err, stackTrace){
          print('AsyncError : $err');
          print('Stack Trace : $stackTrace');
          f.close();
        });
    })
    .catchError((err) {
      print('Open error : $err');
    });
}
