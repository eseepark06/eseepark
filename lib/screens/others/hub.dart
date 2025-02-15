import 'package:eseepark/globals.dart';
import 'package:eseepark/screens/others/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Hub extends StatefulWidget {
  const Hub({super.key});

  @override
  State<Hub> createState() => _HubState();
}

class _HubState extends State<Hub> {
  final pageController = PageController();
  bool isAnimating = false;
  int selectedPage = 0;

  void onPageChanged(int index) {
    if (!isAnimating) {
      setState(() {
        selectedPage= index;
      });
    }
  }

  void onNavTapped(int index) async {
    if (index != selectedPage && !isAnimating) {
      setState(() {
        isAnimating = true;
      });

      await pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );

      setState(() {
        selectedPage = index;
        isAnimating = false;
      });
    }
  }

  Widget navMenu({required int index, required String title, required String svgAsset}) {
    return InkWell(
      onTap: () => onNavTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.035,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: SvgPicture.asset('assets/svgs/hub/$svgAsset-${selectedPage == index ? 'selected' : 'unselected'}.svg',
                  key: ValueKey(selectedPage == index ? 'selected_$index' : 'unselected_$index'),
                  colorFilter: ColorFilter.mode(
                    selectedPage == index ? Theme.of(context).colorScheme.primary : const Color(0xFF808080), BlendMode.srcIn
                  ),
                  width: selectedPage == index ? screenWidth * 0.06 : screenWidth * 0.05,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(title,
                key: ValueKey(selectedPage == index ? 'text_selected_$index' : 'text_unselected_$index'),
                style: TextStyle(
                  color: selectedPage == index ? Theme.of(context).colorScheme.primary : const Color(0xFF808080),
                  fontWeight: selectedPage == index ? FontWeight.bold : FontWeight.normal,
                  fontSize: screenWidth * 0.03,

                ),
              ),
            )
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: [
                  const Home(),
                  Container(color: Colors.blue),
                  Container(color: Colors.red),
                  Container(color: Colors.green),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFF808080).withValues(alpha: 0.5),
                    width: 0.2
                  )
                )
              ),
              padding: EdgeInsets.only(
                bottom: screenHeight * 0.01
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  navMenu(index: 0, title: 'Home', svgAsset: 'home'),
                  navMenu(index: 1, title: 'Activity', svgAsset: 'activity'),
                  navMenu(index: 2, title: 'Search', svgAsset: 'search'),
                  navMenu(index: 3, title: 'Account', svgAsset: 'account'),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
