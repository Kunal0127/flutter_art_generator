import 'package:flutter/material.dart';

class ApiKeyProvider with ChangeNotifier {
  String _apiKey = '';

  String get apiKey => _apiKey;

  set apiKey(String value) {
    _apiKey = value;
    notifyListeners();
  }
}
