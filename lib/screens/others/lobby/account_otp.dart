import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import '../../../customs/custom_textfields.dart';
import '../../../globals.dart';
import '../home.dart';
import '../hub.dart';

class OTPAccount extends StatefulWidget {
  const OTPAccount({super.key});

  @override
  State<OTPAccount> createState() => _OTPAccountState();
}

class _OTPAccountState extends State<OTPAccount> {
  int codeSeconds = 300;
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (codeSeconds > 0) {
        setState(() {
          codeSeconds--;
        });
      } else {
        timer.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

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
                          Text('Enter One-Time Code',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: screenSize * 0.024
                            ),
                          ),
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
                          Text('A one-time code was sent to your email, kindly check your inbox or spam folder.',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w300,
                                fontSize: screenSize * 0.012,
                                height: 1.6
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Container(
                            child: OtpTextField(
                              numberOfFields: 6,
                              showFieldAsBox: true,
                              borderWidth: 0,
                              cursorColor: Colors.white,
                              borderColor: Colors.transparent,
                              keyboardType: TextInputType.number,
                              borderRadius: BorderRadius.circular(10),
                              fillColor: Color(0xFFB2B2B2).withValues(alpha: 0.4),
                              filled: true,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              disabledBorderColor: Colors.transparent,
                              focusedBorderColor: Colors.transparent,
                              enabledBorderColor: Colors.transparent,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize * 0.015,
                                fontWeight: FontWeight.bold
                              ),
                              onCodeChanged: (String code) {
                                //handle validation or checks here if necessary
                              },
                              //runs when every textfield is filled
                              onSubmit: (String verificationCode) {

                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Container(
                            width: screenWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Didn't receive the code?",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenSize * 0.011
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Resend Code',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenSize * 0.011,
                                            fontFamily: 'Poppins',
                                            decoration: TextDecoration.underline
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = () => startTimer(),
                                      ),
                                      TextSpan(
                                        text: ' in ${formatTime(codeSeconds)} ${codeSeconds > 60 ? 'minutes' : 'seconds'}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenSize * 0.011,
                                            fontFamily: 'Poppins',
                                        ),
                                      )
                                    ]
                                  ),
                                )
                              ],
                            )
                          )
                        ],
                      )
                  ),
                ],
              ),
              Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom + screenHeight * 0.07,
                  left: 0,
                  right: 0,
                  child: Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07
                      ),
                      child: ElevatedButton(
                        onPressed: () => Get.offAll(() => const Hub(),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.0185,
                            horizontal: screenWidth * 0.06
                          )
                        ),
                        child: Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize * 0.014),),
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
