import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

import '../../../customs/custom_textfields.dart';
import '../../../globals.dart';
import '../../../main.dart';
import '../hub.dart';

class AccountName extends StatefulWidget {
  const AccountName({super.key});

  @override
  State<AccountName> createState() => _AccountNameState();
}

class _AccountNameState extends State<AccountName> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: true,
      body: Container(
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
                        Text('What Should We Call You?',
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
                        Text("Let us know how you'd like to be addressed.",
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
                          controller: nameController,
                          placeholder: 'Enter Name',
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
                        ),
                        SizedBox(height: screenHeight * 0.03),
                      ],
                    )
                ),
              ],
            ),
            Positioned(
                bottom: screenHeight * 0.05,
                left: 0,
                right: 0,
                child: Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.07
                    ),
                    child: ElevatedButton(
                      onPressed: nameController.text.trim().length < 8 ? null : () async {

                        final modifyName = await supabase.auth.updateUser(
                            UserAttributes(
                              data: {
                                'name': nameController.text.trim()
                              }
                            )
                        );

                        if(modifyName.user != null) {
                          Get.offAll(() => (supabase.auth.currentUser?.userMetadata?['name'] != null ? const Hub() : const AccountName()),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 400)
                          );
                        } else {
                          Get.snackbar('Error', 'Invalid Name', backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 2));
                        }


                        // final verifyOTP = await supabase.auth.verifyOTP(
                        //     token: codeController.text.trim(),
                        //     type: OtpType.email,
                        //     email: widget.email
                        // );

                        // if(verifyOTP.session != null) {
                        //   Get.offAll(() => (supabase.auth.currentUser?.userMetadata?['first_name'] != null ? const Hub() : const AccountName()),
                        //       transition: Transition.rightToLeft,
                        //       duration: const Duration(milliseconds: 400)
                        //   );
                        // } else {
                        //   Get.snackbar('Error', 'Invalid OTP', backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 2));
                        // }
                      },
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
                      child: Text('Finish Setup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize * 0.014),),
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}
