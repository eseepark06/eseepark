import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralProvider with ChangeNotifier {
  static final GeneralProvider _instance = GeneralProvider._internal();

  factory GeneralProvider() => _instance;

  GeneralProvider._internal();

  Future<void> initialize() async {
    await _loadGetStarted();
  }

  bool _isGetStartedShown = false;
  bool _isInitialized = false;


  bool get isGetStartedShown => _isGetStartedShown;
  bool get isInitialized => _isInitialized;

  Future<void> _loadGetStarted() async {
    final prefs = await SharedPreferences.getInstance();

    print(prefs.getKeys());

    _isGetStartedShown = prefs.getBool('isGetStartedShown') ?? false;
    _isInitialized = true;

    print('Set initialize value to $_isInitialized');

    notifyListeners();
  }

  Future<bool> setGetStartedValue(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      bool status = await prefs.setBool('isGetStartedShown', value);

      if(status) {
        _isGetStartedShown = true;
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch(e) {
      return false;
    }
  }
}