main() {
  var directory = {'fire': 119, 'cops': 110, 'emergency': 120, 'time': 117};
  directory['weather'] = 177;    // add an element
  print(directory['weather']);   // 177
  print(directory.length);       // 5, number of key/value pairs
  directory.remove('weather');   // remove a element
  print(directory.length);       // 4
  print(directory['weather']);   // null
  directory.forEach((k,v) => print(k));  // iterating
  directory.putIfAbsent('earthquake', () {
    // do something
    return 171;
  });
  print(directory['earthquake'] );       // 171
}

/*
 * 177
5
4
null
fire
cops
emergency
time
171
*/