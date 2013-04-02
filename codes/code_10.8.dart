main() {
var a1 = true && true;       // t && t returns true
var a2 = true && false;      // t && f returns false
var a3 = false && true;      // f && t returns false
var a4 = false && (3 == 4);  // f && f returns false
var a5 = "Cat" && "Dog";     // str && str returns false with warning
var a6 = false && "Cat";     // f && str returns false with warning
var a7 = "Cat" && false;     // str && f returns false with warning
var o1 = true || true;       // t || t returns true
var o2 = false || true;      // f || t returns true
var o3 = true || false;      // t || f returns true
var o4 = false || (3 == 4);  // f || f returns false
var o5 = "Cat" || "Dog";     // str || str returns false with warning
var o6 = false || "Cat";     // f || str returns false with warning
var o7 = "Cat" || false;     // str || f returns false with warning
var n1 = !true;              // !t returns false
var n2 = !false;             // !f returns true
var n3 = !"Cat";             // !str returns true with warning

print(a1); print(a2); print(a3); print(a4); print(a5); 
print(a6); print(a7); print('');
print(o1); print(o2); print(o3); print(o4); print(o5); 
print(o6); print(o7); print('');
print(n1); print(n2); print(n3);
}