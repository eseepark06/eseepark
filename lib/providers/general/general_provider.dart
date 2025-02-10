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

  bool get isGetStartedShown => _isGetStartedShown;

  Future<void> _loadGetStarted() async {
    final prefs = await SharedPreferences.getInstance();

    _isGetStartedShown = prefs.getBool('isGetStartedShown') ?? false;

    notifyListeners();
  }
}