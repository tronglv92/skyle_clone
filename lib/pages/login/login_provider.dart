import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  int count = 0;

  /// Increase value and notify to update ui
  void increase() {
    count++;
    notifyListeners();
  }
}
