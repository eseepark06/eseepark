import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Image.asset('assets/images/general/eseepark-transparent-logo.png',
          width: screenSize * 0.1,
          height: screenSize * 0.1,
        ),
      ),
    );
  }
}
