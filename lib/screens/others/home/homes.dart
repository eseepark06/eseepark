import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: Container(
              width: screenWidth,
              padding: EdgeInsets.only(
                top: screenHeight * 0.08,
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                bottom: screenHeight * 0.02,
              ),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(onTap: () => Get.back(), splashColor: Colors.transparent, highlightColor: Colors.transparent, child: Icon(Icons.arrow_back, size: screenSize * 0.025)),
                      SizedBox(width: screenWidth * 0.05),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            establishment.name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenSize * 0.018,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(establishment.address,
                                            style: TextStyle(
                                              color: const Color(0xFF808080),
                                              fontSize: screenSize * 0.01,
                                              height: 1.3,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.05),
                                  Container(
                                    width: screenWidth * 0.16,
                                    height: screenWidth * 0.16,
                                    decoration: BoxDecoration(
                                      image: establishment.image != null ? DecorationImage(
                                          image: NetworkImage(establishment.image ?? ''),
                                          fit: BoxFit.cover
                                      ) : null,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: screenWidth * 0.04),
                              Row(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          padding: EdgeInsets.all(screenWidth * 0.005),
                                          child: Icon(
                                            Icons.local_parking,
                                            size: screenWidth * 0.04,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Text("${widget.availableSlots} ${widget.availableSlots > 1 ? 'Slots' : 'Slot'} Available",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: screenSize * 0.01,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.05),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          padding: EdgeInsets.all(screenWidth * 0.005),
                                          child: Icon(
                                            Icons.location_pin,
                                            size: screenWidth * 0.04,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Text("${widget.availableSlots} kilometers away",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: screenSize * 0.01,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.onPrimary, width: .3),
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.013,
                        horizontal: screenWidth * 0.05
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.directions, color: Colors.white, size: screenWidth * 0.05),
                        SizedBox(width: screenWidth * 0.02),
                        Text('Get Directions',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize * 0.011,
                              fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
