import 'package:flutter/foundation.dart';

class CustomMethods {
  static void printIfDebug(String text) {
    if (kDebugMode) {
      print("print: $text");
    }
  }
}
