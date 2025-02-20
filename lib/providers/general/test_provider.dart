import 'package:flutter/material.dart';


class TestProvider with ChangeNotifier {
  static final TestProvider _instance = TestProvider._internal();

  factory TestProvider() => _instance;

  TestProvider._internal();

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 3));

  }
}