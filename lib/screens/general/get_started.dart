import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';

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
        title: 'Find Parking in Seconds',
        subtitle: 'No more aimless searching, see available parking slots instantly',
        image: 'assets/images/getstarted/slide1.png'
    ),
    GetStartedInfo(
        title: 'Real-Time Parking Updates',
        subtitle: 'Stay updated on parking status at a glance—no more aimless searching!',
        image: 'assets/images/getstarted/slide1.png'
    ),
    GetStartedInfo(
        title: 'Know Before You Go',
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(backgroundColor: Colors.transparent, scrolledUnderElevation: 0),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: screenHeight * 0.7,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: screenWidth * .05,
                          right: screenWidth * .05
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize * 0.026
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
                      color: Colors.orange,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * .05
                      ),
                      child: Text(getStartedInfos[currentIndex].subtitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize * 0.014
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * .06,
                vertical: screenHeight * .05
              ),
              width: screenWidth,
              child: ElevatedButton(
                onPressed: () {
                  if(currentIndex + 1 < getStartedInfos.length) {
                    setState(() {
                      currentIndex++;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015
                  ),
                  backgroundColor: Color.lerp(Theme.of(context).colorScheme.primary, Colors.deepOrange, 0.6)
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
