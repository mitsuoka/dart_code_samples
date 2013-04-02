import 'dart:math' as Math;

class Point {
  Point(this.x, this.y);        // コンストラクタ
  var x, y;                     // インスタンス変数
  distanceTo(Point other) {     // インスタンス・メソッド
    var dx = x - other.x;
    var dy = y - other.y;
    return Math.sqrt(dx * dx + dy * dy);
  }
  operator +(other) => new Point(x+other.x, y+other.y); // 演算子定義
}

main() {
  Point p1, p2, p3;
  p1 = new Point(5, 10);
  p2 = new Point(3, 4);
  p3 = p1 + p2;         // 定義された演算子を使用
  print('Added result :  X=${p3.x}, Y=${p3.y}');
  print('Distance : ${p1.distanceTo(p2)}');
}

/*
Added result :  X=8, Y=14
Distance : 6.324555320336759
*/