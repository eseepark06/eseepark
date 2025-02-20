import 'package:eseepark/models/establishment_model.dart';
import 'package:eseepark/models/parking_rate_model.dart';
import 'package:flutter/material.dart';

import '../../../../globals.dart';
import '../home.dart';

class Establishments extends StatefulWidget {
  final Establishment establishment;
  final ParkingRate? parkingRate;
  final int? parkingSlotsCount;
  final List<ParkingMenu> parkingMenus;
  
  const Establishments({
    super.key,
    required this.establishment,
    this.parkingRate,
    this.parkingSlotsCount,
    required this.parkingMenus
  });

  @override
  State<Establishments> createState() => _EstablishmentsState();
}

class _EstablishmentsState extends State<Establishments> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.33,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.01),
                spreadRadius: 2,
                blurRadius: 3)
          ]),
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                    image: widget.establishment.image!.isNotEmpty
                        ? DecorationImage(
                        image: NetworkImage(widget.establishment.image!),
                        fit: BoxFit.cover)
                        : null,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.01,
            left: screenWidth * 0.03,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.003),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.onPrimary),
              child: Text(
                widget.parkingMenus
                    .where((e) => e.name == widget.establishment.establishmentType)
                    .toList()
                    .first
                    .name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize * 0.0095,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  color: (widget.parkingSlotsCount ?? 0) > 0
                      ? Theme.of(context).colorScheme.onPrimary
                      : const Color(0xFFD0D0D0)),
              child: Column(
                children: [
                  Text(
                    widget.parkingSlotsCount.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize * 0.012,
                        height: 1,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'slots',
                    style: TextStyle(
                        color: Colors.white,
                        height: 1,
                        fontSize: screenSize * 0.0095,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.12,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white),
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.014),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.establishment.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: screenSize * 0.014,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${1} kilometers away',
                              style: TextStyle(
                                  fontSize: screenSize * 0.0095,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF808080)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: screenSize * 0.014,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            4.5.toString(),
                            style: TextStyle(
                                fontSize: screenSize * 0.011,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              '₱${double.parse((widget.parkingRate?.flatRate ?? widget.parkingRate?.baseRate).toString()).toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: screenSize * 0.011,
                                  fontFamily: 'HelveticaNeue',
                                  color: const Color(0xFF808080)),
                            ),
                            TextSpan(
                              text: widget.parkingRate?.flatRate == null
                                  ? ' • First ${widget.parkingRate?.baseHours} hours'
                                  : ' • Fixed Parking Fee',
                              style: TextStyle(
                                  fontSize: screenSize * 0.009,
                                  fontFamily: 'Poppins',
                                  color: const Color(0xFF808080)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
