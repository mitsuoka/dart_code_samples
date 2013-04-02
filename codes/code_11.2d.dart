main() {
  Map data = { '内閣総理大臣' : '野田佳彦', '総務大臣' : '川端達夫', '法務大臣' : '平岡秀夫' };

// for-inループ
  for (var key in data.keys) {
    print('$key, ${data[key]}');
  }

// forEachループ

  data.forEach((key, value){
    print('${key}, ${value}');
  });
}
/*
内閣総理大臣, 野田佳彦
総務大臣, 川端達夫
法務大臣, 平岡秀夫
内閣総理大臣, 野田佳彦
総務大臣, 川端達夫
法務大臣, 平岡秀夫
*/