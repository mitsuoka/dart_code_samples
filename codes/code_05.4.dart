class Point {
  num x, y, z;
  List v;
  Point(this.x, this.y) : z = 10 {
    v = [];
    for(var i=1; i<=5; i++) {
      v.add(i);
    }
  }
}
main() {
  var point = new Point(1, 2);
  print('x:${point.x} y:${point.y} z:${point.z}');
  for (var i=0; i<point.v.length; i++){
    print(point.v[i]);
  }
}
/*
x:1 y:2 z:10
1
2
3
4
5
*/