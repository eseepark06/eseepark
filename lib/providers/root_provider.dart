import 'package:eseepark/providers/general/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'general/settings_provider.dart';
import 'general/test_provider.dart';

class RootProvider with ChangeNotifier {
  final TestProvider testProvider;
  final SettingsProvider settingsProvider;
  final GeneralProvider generalProvider;

  RootProvider()
      : testProvider = TestProvider(),
        settingsProvider = SettingsProvider(),
        generalProvider = GeneralProvider(); // Initialize SettingsProvider

  TestProvider get getTestProvider => testProvider;
  SettingsProvider get getSettingsProvider => settingsProvider;
  GeneralProvider get getGeneralProvider => generalProvider;

  Future<void> initializeData() async {
    await generalProvider.initialize();
    await testProvider.initialize();
    await settingsProvider.initialize();

    FlutterNativeSplash.remove();
  }
}