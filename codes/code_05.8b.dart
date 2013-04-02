class Location { 
  num lat, lng; 
}

void main() {
  var waikiki = new Location(); 
  waikiki.lat = 21.271488; // 暗示的なセッタ
  waikiki.lng = -157.822806; // 暗示的なセッタ
  
  print(waikiki.lat); // 暗示的なゲッタ
  print(waikiki.lng); // 暗示的なゲッタ
}