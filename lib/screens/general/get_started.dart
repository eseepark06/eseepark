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
        image: 'image'
    ),
    GetStartedInfo(
        title: 'Real-Time Parking Updates dsd',
        subtitle: 'No more aimless searching, see available parking slots instantly',
        image: 'image'
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
            Column(
              children: [
                Container(
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
                                fontSize: screenSize * 0.03
                            ),
                          ),
                        )
                    ),
                  ),
                ),
                Container(
                  color: Colors.red,
                  height: screenHeight * 0.3,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                  setState(() {
                    if(currentIndex == 0) {
                      currentIndex++;
                    } else {
                      currentIndex--;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(

                ),
              child: Text('Next')
            )
          ],
        )
      ),
    );
  }
}
