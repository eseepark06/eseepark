import 'package:eseepark/customs/custom_widgets.dart';
import 'package:eseepark/globals.dart';
import 'package:eseepark/main.dart';
import 'package:eseepark/screens/others/lobby/lobby.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ValueNotifier<bool> processingLogout = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: screenSize * 0.017
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          SizedBox(height: screenHeight * 0.03),
          Section(
            title: 'Account Management',
            titleSize: screenSize * 0.012,
            children: [
              SectionItem(title: 'Log Out',
                onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text('Are you sure you want to log out?'),
                      elevation: 0,
                      actionsPadding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                          bottom: screenHeight * 0.015,
                          top: screenHeight * 0.02
                      ),
                      contentPadding: EdgeInsets.only(
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        top: screenHeight * 0.022,
                        bottom: screenHeight * 0.0
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: Text('Cancel',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: processingLogout,
                          builder: (context, value, child) {
                            return TextButton(
                              onPressed: () async {
                                try {

                                  if(!value) {
                                    setState(() {
                                      processingLogout.value = true;
                                    });

                                    await supabase.auth.signOut();

                                    setState(() {
                                      processingLogout.value = false;
                                    });

                                    Get.offAll(() => const Lobby(),
                                        transition: Transition.cupertino,
                                        duration: const Duration(milliseconds: 450)
                                    );
                                  }

                                } catch(e) {
                                  print('Exception: $e');
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03
                                )),
                                minimumSize: MaterialStateProperty.all(Size(screenWidth * 0.22, screenHeight * 0.045)),
                                backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                              ),
                              child: value ? CupertinoActivityIndicator(color: Colors.white) :
                                Text('Log Out',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                            );
                          }
                        )
                      ],
                    )
                ),
              )
            ]
          )
        ],
      ),
    );
  }
}
