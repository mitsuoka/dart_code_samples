main() {
  try {
    throw "Stack trace example";
  } catch (e, s) {
    print("Caught: $e");
    print("Stack: $s");
  }
}
/*
Caught: Stack trace example
Stack: #0      main (file:///C:/dart_applications/LanguageGuideSampleCodes/test_stacktrace.dart:3:5)
*/