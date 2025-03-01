import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  static final SettingsProvider _instance = SettingsProvider._internal();

  factory SettingsProvider() => _instance;

  SettingsProvider._internal();

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}