import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'general/settings_provider.dart';
import 'general/test_provider.dart';

class RootProvider with ChangeNotifier {
  final TestProvider testProvider;
  final SettingsProvider settingsProvider;

  RootProvider()
      : testProvider = TestProvider(),
        settingsProvider = SettingsProvider(); // Initialize SettingsProvider

  TestProvider get getTestProvider => testProvider;
  SettingsProvider get getSettingsProvider => settingsProvider;

  Future<void> initializeData() async {
    await testProvider.initialize();
    await settingsProvider.initialize();

    FlutterNativeSplash.remove();
  }
}