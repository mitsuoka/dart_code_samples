main() {
  Map mimeMap = const {
    'rtf': 'application/rtf',
    '3g2': 'video/3gpp2',
    'exe': 'application/octet-stream',
    'abs': 'audio/x-mpeg',
  };
  List keys = mimeMap.keys.toList()..sort();
  for (String key in keys) {
    print('extension: $key, mime type:${mimeMap[key]}');
  };
}
/*
extension: 3g2, mime type:video/3gpp2
extension: abs, mime type:audio/x-mpeg
extension: exe, mime type:application/octet-stream
extension: rtf, mime type:application/rtf
 */