import 'package:flutter/cupertino.dart';
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
  bool processingName = false;
  final nameController = TextEditingController();

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
                          Text('What Should We Call You?',
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
                          Text("Let us know how you'd like to be addressed.",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
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
                          ),
                          SizedBox(height: screenHeight * 0.03),
                        ],
                      )
                  ),
                ],
              ),
              Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom + screenHeight * 0.05,
                  left: 0,
                  right: 0,
                  child: Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07
                      ),
                      child: ElevatedButton(
                        onPressed: nameController.text.trim().length < 8 ? null : () async {

                          if(processingName) {
                            return;
                          }

                          setState(() {
                            processingName = true;
                          });

                          FocusScope.of(context).unfocus();


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
                        child: processingName ? CupertinoActivityIndicator() : Text('Finish Setup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize * 0.014, color: Colors.white),),
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
