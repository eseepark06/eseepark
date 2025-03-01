import 'package:eseepark/globals.dart';
import 'package:eseepark/providers/root_provider.dart';
import 'package:eseepark/screens/others/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GetStartedInfo {
  final String title;
  final String subtitle;
  final String image;

  const GetStartedInfo({
    required this.title,
    required this.subtitle,
    required this.image
  });
}

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  int currentIndex = 0;

  final getStartedInfos = [
    GetStartedInfo(
        title: 'Find Parking\nIn Seconds',
        subtitle: 'No more aimless searching, see available parking slots instantly',
        image: 'assets/images/getstarted/slide1.png'
    ),
    GetStartedInfo(
        title: 'Real-Time\nParking Updates',
        subtitle: 'Stay updated on parking status at a glance—no more aimless searching!',
        image: 'assets/images/getstarted/slide1.png'
    ),
    GetStartedInfo(
        title: 'Know Before\nYou Go',
        subtitle: 'Save time by checking available slots before heading out.',
        image: 'assets/images/getstarted/slide1.png'
    ),
    GetStartedInfo(
        title: 'Welcome to eSEEPark!',
        subtitle: 'Making parking smarter, faster, and hassle-free for everyone!',
        image: 'assets/images/getstarted/slide1.png'
    )
  ];

  @override
  Widget build(BuildContext context) {
    final rootProvider = Provider.of<RootProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, scrolledUnderElevation: 0),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: screenHeight * 0.65,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: screenWidth * .07,
                          right: screenWidth * .07
                      ),
                      child: SizedBox(
                        width: screenWidth * 0.9,
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              key: ValueKey<String>(getStartedInfos[currentIndex].title),
                              child: Text(getStartedInfos[currentIndex].title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize * 0.03
                                ),
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * .03),
                  Container(
                    height: screenHeight * 0.35,
                    child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        key: ValueKey<String>(getStartedInfos[currentIndex].image),
                        child: Image.asset(getStartedInfos[currentIndex].image)
                    ),
                  ),
                  SizedBox(height: screenHeight * .03),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * .1
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: Text(getStartedInfos[currentIndex].subtitle,
                          key: ValueKey<String>(getStartedInfos[currentIndex].subtitle),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                            fontSize: screenSize * 0.013,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: screenWidth * .06,
                right: screenWidth * .06,
                bottom: screenHeight * .12
              ),
              width: screenWidth,
              child: ElevatedButton(
                onPressed: () async {
                  if(currentIndex + 1 < getStartedInfos.length) {
                    setState(() {
                      currentIndex++;
                    });
                  } else {
                    bool status = await rootProvider.getGeneralProvider.setGetStartedValue(true);

                    if(status) {
                      Get.offAll(() => const Lobby());
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.018
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Text(getStartedInfos.length == currentIndex + 1 ? 'Get Started' : 'Next',
                    textAlign: TextAlign.start,
                    key: ValueKey<String>(getStartedInfos[currentIndex].title),
                    style: TextStyle(
                      fontSize: screenSize * 0.015,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ),
            )
          ],
        )
      ),
    );
  }
}
