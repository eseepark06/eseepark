import 'dart:math';

import 'package:eseepark/controllers/auth/account_controller.dart';
import 'package:eseepark/customs/custom_textfields.dart';
import 'package:eseepark/globals.dart';
import 'package:eseepark/main.dart';
import 'package:eseepark/screens/others/lobby/account_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  bool processingEmail = false;
  final accountController = AccountController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: screenHeight * 0.11),
                  Image.asset('assets/images/general/eseepark-transparent-logo-bnw.png',
                    width: screenWidth * 0.15,
                  ),
                  SizedBox(height: screenHeight * 0.08),
                  Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello There!',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: screenSize * 0.024
                            ),
                          ),
                          Text('Ready To Park In?',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: screenSize * 0.024
                            ),
                          )
                        ],
                      )
                  ),
                  Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07
                      ),
                      margin: EdgeInsets.only(top: screenHeight * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('With your email as your username, you can access our parking services.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: screenSize * 0.012,
                              height: 1.6
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          CustomTextFieldWithLabel(
                            title: '',
                            controller: emailController,
                            placeholder: 'Enter your email',
                            cursorColor: Theme.of(context).colorScheme.primary,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            titleStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: screenSize * 0.012
                            ),
                            placeholderStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                              fontSize: screenSize * 0.012
                            ),
                            mainTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize * 0.012
                            ),
                            onChanged: (val) {
                              setState(() {});
                            },
                            horizontalPadding: screenWidth * 0.05,
                            verticalPadding: screenHeight * 0.02,
                            borderRadius: 30,
                          )
                        ],
                      )
                  ),
                ],
              ),
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom + screenHeight * 0.03,
                left: 0,
                right: 0,
                child: Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.07
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Text('By clicking next, you have read and agree to our Terms and Conditions and Privacy Policy.',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                                  fontSize: screenSize * 0.009
                              ),
                            )
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Container(
                            constraints: BoxConstraints(minWidth: screenWidth * 0.3),
                            child: ElevatedButton(
                              onPressed: emailController.text.trim().isEmpty ? null : () async {

                                  if(!processingEmail) {

                                    FocusScope.of(context).unfocus();

                                    setState(() {
                                      processingEmail = true;
                                    });

                                    final check = await accountController.emailNextButton(emailController.text.trim());


                                    if(check != null) {
                                      if(check == 1) {
                                        try {
                                          await supabase.auth.signInWithOtp(
                                            email: emailController.text.trim(),
                                          );


                                          setState(() {
                                            processingEmail = false;
                                          });

                                          print('Proceeding to sign in');

                                          Get.to(() => OTPAccount(email: emailController.text.trim(), isNewAccount: false),
                                              duration: const Duration(milliseconds: 300),
                                              transition: Transition.cupertino
                                          );
                                        } catch(e) {
                                          print('Exception found: $e');
                                          if(e.toString().contains('For security purposes, you can only request this after')) {
                                            RegExp regExp = RegExp(r'(\d+) seconds');
                                            Match? match = regExp.firstMatch(e.toString());

                                            print(match?.group(1));

                                            Get.to(() => OTPAccount(email: emailController.text.trim(), isNewAccount: false, codeInterval: int.parse(match?.group(1) ?? '0')),
                                                duration: const Duration(milliseconds: 300),
                                                transition: Transition.cupertino
                                            );
                                          } else {
                                            print('doesnt contain');
                                          }
                                        }
                                      }
                                      else {
                                        print('Proceeded with a null value so signing upp');
                                        try {
                                          final response = await supabase.auth.signUp(
                                              email: emailController.text.trim(),
                                              password: Random().nextInt(10000000).toString()
                                          );

                                          print('Proceeding to sign up');

                                          if(response.session != null) {
                                            await supabase.auth.signInWithOtp(
                                              email: emailController.text.trim(),
                                            );


                                            setState(() {
                                              processingEmail = false;
                                            });

                                            Get.to(() => OTPAccount(email: emailController.text.trim(), isNewAccount: true),
                                                duration: const Duration(milliseconds: 300),
                                                transition: Transition.cupertino
                                            );
                                          } else {
                                            print('Sent: $response');


                                            setState(() {
                                              processingEmail = false;
                                            });

                                            Get.to(() => OTPAccount(email: emailController.text.trim(), isNewAccount: true),
                                                duration: const Duration(milliseconds: 300),
                                                transition: Transition.cupertino
                                            );
                                          }
                                        } catch(e) {
                                          print('Exception foudnd: $e');

                                          if(e.toString().contains('For security purposes, you can only request this after')) {
                                            RegExp regExp = RegExp(r'(\d+) seconds');
                                            Match? match = regExp.firstMatch(e.toString());

                                            print(match);

                                            Get.to(() => OTPAccount(email: emailController.text.trim(), isNewAccount: true, codeInterval: int.parse(match?.group(1) ?? '0')),
                                                duration: const Duration(milliseconds: 300),
                                                transition: Transition.cupertino
                                            );
                                          } else {
                                            print('doesnt contain');
                                          }
                                        }
                                      }
                                    }


                                    setState(() {
                                      processingEmail = false;
                                    });
                                  }



                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015,
                                  horizontal: screenWidth * 0.06
                                )
                              ),
                              child: processingEmail ? CupertinoActivityIndicator(color: Colors.white) : Row(
                                children: [
                                  Text('Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenSize * 0.014
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Icon(Icons.arrow_forward,
                                    size: screenSize * 0.018,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            )
                        )
                      ],
                    )
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
