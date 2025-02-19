import 'dart:async';

import 'package:eseepark/screens/others/lobby/account_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';
import '../../../globals.dart';
import '../../../main.dart';
import '../hub.dart';

class OTPAccount extends StatefulWidget {
  final String email;
  final bool isNewAccount;
  final int? codeInterval;

  const OTPAccount({
    super.key,
    required this.email,
    required this.isNewAccount,
    this.codeInterval
  });

  @override
  State<OTPAccount> createState() => _OTPAccountState();
}

class _OTPAccountState extends State<OTPAccount> {
  final codeController = TextEditingController();
  String resendText = 'Resend Code';
  bool processingOtp = false;

  int codeSeconds = 300;
  Timer? _timer;

  void checkIfCodeIntervalNotNull() async {
    if (widget.codeInterval != null) {
      startTimer(widget.codeInterval!);
    } else {
      startTimer(300);
    }
  }

  void startTimer(int seconds) {
    codeSeconds = seconds;
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

  String formatTimeFromMessage(String message) {
    RegExp regExp = RegExp(r'(\d+) seconds');
    Match? match = regExp.firstMatch(message);

    if (match != null) {
      int seconds = int.parse(match.group(1)!);
      int minutes = seconds ~/ 60;
      int secs = seconds % 60;
      return '$minutes:${secs.toString().padLeft(2, '0')}';
    }

    return "Invalid time format"; // Fallback if no number is found
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfCodeIntervalNotNull();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          Text('Enter One-Time Code',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
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
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w400,
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
                              cursorColor: Theme.of(context).colorScheme.primary,
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
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: screenSize * 0.015,
                                fontWeight: FontWeight.bold
                              ),
                              onCodeChanged: (String code) {
                                setState(() {
                                  codeController.text = '';
                                });
                              },
                              //runs when every textfield is filled
                              onSubmit: (String verificationCode) {
                                setState(() {
                                  codeController.text = verificationCode;
                                });
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
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: screenSize * 0.011
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: resendText,
                                        style: TextStyle(
                                            color: codeSeconds == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenSize * 0.013,
                                            fontFamily: 'Poppins',
                                            decoration: TextDecoration.underline
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = () async {
                                          try {

                                            if(resendText == 'Resend Code') {

                                              setState(() {
                                                resendText = 'Resending...';
                                              });

                                              await supabase.auth.signInWithOtp(
                                                email: widget.email.trim(),
                                              );

                                              setState(() {
                                                resendText = 'Resend Code';
                                              });

                                              startTimer(300);
                                            } else {

                                              setState(() {
                                                resendText = 'Resend Code';
                                              });
                                            }

                                          } catch(e) {
                                            final error = e as AuthException;
                                            print('Error resending code: $e');
                                            Get.snackbar('Cooldown in Progress!', 'Resend code cooldown in progress please wait for ${formatTimeFromMessage(error.message)} ${error.message.contains('seconds') ? 'seconds' : 'minutes'}', backgroundColor: Colors.red, colorText: Theme.of(context).colorScheme.primary, duration: const Duration(seconds: 2));

                                            setState(() {
                                              resendText = 'Resend Code';
                                            });
                                          }

                                        },
                                      ),
                                      if(codeSeconds > 0)
                                      TextSpan(
                                        text: ' in ${formatTime(codeSeconds)} ${codeSeconds > 60 ? 'minutes' : 'seconds'}',
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
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
                        onPressed: codeController.text.trim().length < 6 ? null : () async {

                          try {
                            print('Verrifiyng otp code: ${codeController.text.trim()}');

                            if(processingOtp) {
                              return;
                            }

                            FocusScope.of(context).unfocus();

                            setState(() {
                              processingOtp = true;
                            });

                            final verifyOTP = await supabase.auth.verifyOTP(
                                token: codeController.text.trim(),
                                type: OtpType.email,
                                email: widget.email
                            );



                            if(verifyOTP.session != null) {
                              Get.offAll(() => (supabase.auth.currentUser?.userMetadata?['name'] != null ? const Hub() : const AccountName()),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 400)
                              );
                            } else {
                              Get.snackbar('Error', 'Invalid OTP', backgroundColor: Colors.red, colorText: Theme.of(context).colorScheme.primary, duration: const Duration(seconds: 2));
                            }
                          } catch(e) {
                            print('Error found: $e');
                            setState(() {
                              processingOtp = false;
                            });
                            Get.snackbar('Oops!', 'That OTP is incorrect or expired. Please double-check and try again.', backgroundColor: Colors.red, colorText: Theme.of(context).colorScheme.primary, duration: const Duration(seconds: 2));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.0185,
                            horizontal: screenWidth * 0.06
                          )
                        ),
                        child: processingOtp ? CupertinoActivityIndicator(color: Colors.white) :
                          Text(widget.isNewAccount ? 'Next' : 'Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize * 0.014, color: Colors.white),),
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
