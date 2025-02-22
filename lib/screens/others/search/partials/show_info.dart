import 'package:eseepark/controllers/establishments/establishments_controller.dart';
import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../models/establishment_model.dart';

class ShowInfo extends StatefulWidget {
  final String establishmentId;

  const ShowInfo({
    super.key,
    required this.establishmentId
  });

  @override
  State<ShowInfo> createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  final _controller = EstablishmentController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder(
        stream: _controller.getEstablishmentById(widget.establishmentId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error found: ${snapshot.error}');
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          }

          final establishment = snapshot.data;


          if (establishment == null) {
            return Shimmer.fromColors(
              baseColor: const Color(0xFFEAEAEA),
              highlightColor: const Color(0xFFEAEAEA).withOpacity(0.4),
              enabled: true,
              direction: ShimmerDirection.ltr,
              child: Container(
                height: screenHeight * 0.83,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.035,
                              horizontal: screenWidth * 0.04
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: screenHeight * 0.028,
                                        width: screenWidth * 0.5,
                                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Color(0xffeaeaea)
                                        ),
                                      ),
                                      Container(
                                        height: screenHeight * 0.02,
                                        width: screenWidth * 0.3,
                                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Color(0xffeaeaea)
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffeaeaea),
                                    shape: BoxShape.circle
                                ),
                                padding: EdgeInsets.all(screenSize * 0.013),
                                child: Icon(Icons.close),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: screenHeight * 0.061,
                                width: screenWidth * 0.3,
                                margin: EdgeInsets.only(right: screenWidth * 0.03),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Color(0xffeaeaea)
                                ),
                              ),
                              Container(
                                height: screenHeight * 0.061,
                                width: screenWidth * 0.3,
                                margin: EdgeInsets.only(right: screenWidth * 0.03),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Color(0xffeaeaea)
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.025
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: screenHeight * 0.027,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Color(0xffeaeaea)
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.1),
                              Container(
                                height: screenHeight * 0.061,
                                width: screenWidth * 0.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Color(0xffeaeaea)
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.025
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: screenHeight * 0.085,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Color(0xffeaeaea)
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.09),
                              Expanded(
                                child: Container(
                                  height: screenHeight * 0.085,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Color(0xffeaeaea)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: screenHeight * 0.085,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Color(0xffeaeaea)
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.09),
                              Expanded(
                                child: Container(
                                  height: screenHeight * 0.085,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Color(0xffeaeaea)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.04,
                          right: screenWidth * 0.04,
                          bottom: screenHeight * 0.04
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Color(0xffeaeaea)
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.07),
                          Expanded(
                            child: Container(
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Color(0xffeaeaea)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.33,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                      image: establishment.image != null ? DecorationImage(
                        image: NetworkImage(establishment.image.toString()),
                        fit: BoxFit.cover
                      ) :
                      DecorationImage(
                        image: AssetImage('assets/images/general/eseepark-transparent-logo-768.png'),
                        scale: 6,
                        alignment: Alignment.center
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10)
                      )
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.058,
                    left: screenWidth * 0.05,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => Get.back(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2
                          )
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.01),
                        child: Icon(Icons.arrow_back_outlined,
                          color: Colors.white,
                        )
                      ),
                    ),
                  )
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(

                          ),
                          child: Wrap(
                            children: [

                            ],
                          ),
                        ),
                        Text(establishment.name.toString(),
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
