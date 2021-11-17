import 'dart:convert';
import 'dart:math';

import 'package:crypt/crypt.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/helpers/extensions/format_extension.dart';

extension StringFormatHelper on String? {
  String generateBase64Salt([int len = 32]) {
    if (!this!.isNullOrEmpty()) {
      Fluttertoast.showToast(msg: "Generating salt...");
      final Random _random = Random.secure();
      var values = List<int>.generate(len, (i) => _random.nextInt(256));
      return base64Url.encode(values);
    } else {
      return this!;
    }
  }

  String generateHash(String salt, String pass) {
    Fluttertoast.showToast(msg: "Generating hash...");
    return Crypt.sha256(salt + pass).toString();
  }
}
