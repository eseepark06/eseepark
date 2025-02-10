import 'package:eseepark/providers/general/theme_provider.dart';
import 'package:eseepark/providers/root_provider.dart';
import 'package:eseepark/screens/general/get_started.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'globals.dart' as globals;

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => RootProvider()),
        ],
        child: const Start(),
      )
  );
}

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenSize = globals.screenHeight + globals.screenWidth;

    if (!themeProvider.isInitialized) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator(color: Colors.green)),
        ),
      );
    }

    final rootProvider = Provider.of<RootProvider>(context);
    rootProvider.initializeData();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme.copyWith(
        textTheme: themeProvider.currentTheme.textTheme.apply(
          fontFamily: 'Poppins',
        ),
      ),
      home: GetStarted(),
    );
  }
}

