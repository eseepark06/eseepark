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
            return Center(child: CircularProgressIndicator());
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
                            children: [],
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
