import 'dart:math';

import 'package:eseepark/controllers/auth/account_controller.dart';
import 'package:eseepark/customs/custom_textfields.dart';
import 'package:eseepark/globals.dart';
import 'package:eseepark/main.dart';
import 'package:eseepark/screens/others/lobby/account_otp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
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
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF09F1D),
                const Color(0xFFD96717)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  Image.asset('assets/images/general/eseepark-transparent-logo-768.png',
                    width: screenWidth * 0.4,
                  ),
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
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: screenSize * 0.024
                            ),
                          ),
                          Text('Ready To Park In?',
                            style: TextStyle(
                                color: Colors.white,
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
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w300,
                              fontSize: screenSize * 0.012,
                              height: 1.6
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          CustomTextFieldWithLabel(
                            title: '',
                            controller: emailController,
                            placeholder: 'Enter your email',
                            backgroundColor: Color(0xFFB2B2B2).withValues(alpha: 0.4),
                            titleStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: screenSize * 0.012
                            ),
                            placeholderStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: screenSize * 0.012
                            ),
                            mainTextStyle: TextStyle(
                                color: Colors.white,
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
                                  color: Colors.white,
                                  fontSize: screenSize * 0.009
                              ),
                            )
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Container(
                            child: ElevatedButton(
                              onPressed: emailController.text.trim().isEmpty ? null : () async {
                                  final check = await accountController.emailNextButton(emailController.text.trim());

                                  if(check != null) {
                                    if(check == 1) {
                                      try {
                                        await supabase.auth.signInWithOtp(
                                            email: emailController.text.trim(),
                                        );

                                        print('Proceeding to sign in');

                                        Get.to(() => OTPAccount(email: emailController.text.trim()),
                                          duration: const Duration(milliseconds: 300),
                                          transition: Transition.cupertino
                                        );
                                      } catch(e) {
                                        print('Exception found: $e');
                                      }
                                    }else {
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

                                          Get.to(() => OTPAccount(email: emailController.text.trim()),
                                              duration: const Duration(milliseconds: 300),
                                              transition: Transition.cupertino
                                          );
                                        } else {
                                          print('Exception found: $response');
                                        }
                                      } catch(e) {
                                        print('Exception found: $e');
                                      }
                                    }
                                  }

                                  },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015,
                                  horizontal: screenWidth * 0.06
                                )
                              ),
                              child: Row(
                                children: [
                                  Text('Next',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenSize * 0.014
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Icon(Icons.arrow_forward,
                                    size: screenSize * 0.018,
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
