import 'dart:ui';

import 'package:eseepark/globals.dart';
import 'package:eseepark/screens/others/accounts/partials/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../customs/custom_widgets.dart';
import '../../../main.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> with AutomaticKeepAliveClientMixin<Account> {
  @override
  bool get wantKeepAlive => true;

  List<AccountStatus> statuses = [];

  void initStatus() {
    statuses = [
      AccountStatus(
        title: supabase.auth.currentUser?.emailConfirmedAt == null ? 'Not Verified' : 'Verified',
        icon: supabase.auth.currentUser?.emailConfirmedAt == null ? Icons.email_outlined : Icons.verified_outlined,
        backgroundColor: supabase.auth.currentUser?.emailConfirmedAt == null ? Colors.red : Colors.green,
        fontColor: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      AccountStatus(
        title: DateFormat.yMMMd().format(DateTime.parse(supabase.auth.currentUser!.createdAt.toString())),
        icon: Icons.perm_contact_calendar_outlined,
        backgroundColor: Theme.of(Get.context as BuildContext).colorScheme.primary,
        fontColor: Colors.white,
        fontWeight: FontWeight.w600,
      )
    ];
  }

  @override
  void initState() {
    super.initState();

    initStatus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          children: [
            Text('My Account',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.only(top: screenHeight * 0.025),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle_rounded,
                        size: screenSize * 0.036,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: (supabase.auth.currentUser?.userMetadata?['name'] ?? 'Anonymous').toString(),
                            ),
                          ],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenSize * 0.014,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'
                          )
                        )
                      ),
                    ],
                  ),
                  Divider(
                    color: const Color(0xFFD1D1D1),
                    thickness: .3,
                  ),
                  Container(
                    height: screenHeight * 0.03,
                    width: screenWidth,
                    child: ListView.builder(
                      itemCount: statuses.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return statuses[index];
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Section(
              title: 'Personal',
              children: [
                SectionItem(title: 'Profile', showDivider: true),
                SectionItem(title: 'Favorites')
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Section(
              title: 'General',
              children: [
                SectionItem(
                  title: 'Settings',
                  onTap: () => Get.to(() => const Settings(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 400)
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AccountStatus extends StatefulWidget {
  final String title;
  final IconData icon;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? fontColor;
  final FontWeight? fontWeight;

  const AccountStatus({
    super.key,
    required this.title,
    required this.icon,
    this.iconSize,
    this.backgroundColor,
    this.fontColor,
    this.fontWeight
  });

  @override
  State<AccountStatus> createState() => _AccountStatusState();
}

class _AccountStatusState extends State<AccountStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: widget.backgroundColor
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
      ),
      margin: EdgeInsets.only(right: screenWidth * 0.025),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon,
            color: widget.fontColor,
            size: widget.iconSize ?? screenWidth * 0.04
          ),
          SizedBox(width: screenWidth * 0.015),
          Text(widget.title,
            style: TextStyle(
              color: widget.fontColor,
              fontWeight: widget.fontWeight,
              height: 1,
              fontSize: screenSize * 0.01
            )
          )
        ],
      ),
    );
  }
}
