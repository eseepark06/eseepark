import 'package:eseepark/models/establishment_model.dart';
import 'package:eseepark/models/parking_rate_model.dart';
import 'package:flutter/material.dart';

import '../../../../globals.dart';
import '../home.dart';

class Establishments extends StatefulWidget {
  final Establishment establishment;
  final ParkingRate? parkingRate;
  final int? parkingSlotsCount;
  final double? ratings;
  final List<ParkingMenu> parkingMenus;
  
  const Establishments({
    super.key,
    required this.establishment,
    this.parkingRate,
    this.parkingSlotsCount,
    this.ratings,
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 1
          ),
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
                height: screenHeight * 0.14,
                decoration: BoxDecoration(
                    image: widget.establishment.image!.isNotEmpty
                        ? DecorationImage(
                        image: NetworkImage(widget.establishment.image!),
                        fit: BoxFit.cover)
                        : null,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: screenHeight * 0.125,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)
                    ),
                    color: Colors.white
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.014
                ),
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
                                    fontSize: screenSize * 0.012,
                                    fontWeight: FontWeight.bold),
                              ),
                                if(widget.establishment.distance != null)
                                  Container(
                                    margin: EdgeInsets.only(top: screenHeight * 0.003),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(5)
                                          ),
                                          padding: EdgeInsets.all(screenSize * 0.002),
                                          child: Icon(Icons.location_on_sharp,
                                            color: Colors.white,
                                            size: screenWidth * 0.03,
                                            applyTextScaling: false,
                                            textDirection: TextDirection.ltr,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.015),
                                        Text(
                                          '${widget.establishment.distance?.toStringAsPrecision(2)} kilometers away',
                                          style: TextStyle(
                                              fontSize: screenSize * 0.009,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF808080)),
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Row(
                          children: [
                            ...List.generate(
                              (widget.ratings ?? 0.0).floor(),
                                  (index) => Icon(
                                Icons.star,
                                size: screenSize * 0.014,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            if ((widget.ratings ?? 0.0) % 1 != 0) // If there's a fraction part, add a half star
                              Icon(
                                Icons.star_half_rounded,
                                size: screenSize * 0.014,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              widget.ratings.toString(),
                              style: TextStyle(
                                fontSize: screenSize * 0.011,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.008),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                  '₱${double.parse((widget.parkingRate?.flatRate ?? widget.parkingRate?.baseRate).toString()).toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: screenSize * 0.017,
                                      fontFamily: 'HelveticaNeue',
                                      color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w800
                                  ),
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
                        ),
                        ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            disabledBackgroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04
                            ),
                            elevation: 0
                          ),
                          child: Text('Explore Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
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
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
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
        ],
      ),
    );
  }
}
