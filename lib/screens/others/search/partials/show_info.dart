import 'package:eseepark/controllers/establishments/establishments_controller.dart';
import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../models/establishment_model.dart';
import '../../home/partials/parking_sheet.dart';

class ShowInfo extends StatefulWidget {
  final String establishmentId;
  final double? distance;

  const ShowInfo({
    super.key,
    required this.establishmentId,
    this.distance
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

          return Stack(
            children: [
              ListView(
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
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(

                              ),
                              child: Wrap(
                                spacing: screenWidth * 0.02,
                                children: (establishment.supportedVehicleTypes ?? []).asMap().entries.map((entry) {
                                  final vehicleType = entry.value;
                                  return Container(
                                    margin: EdgeInsets.only(right: screenWidth * 0.01),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Theme.of(context).colorScheme.primary
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03,
                                        vertical: screenWidth * 0.01
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset('assets/svgs/search/${entry.value.toLowerCase()}.svg',
                                          width: screenWidth * 0.04,
                                          colorFilter: ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Text(vehicleType.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.026
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Container(
                              width: screenWidth * 0.92,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(establishment.name.toString(),
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Container(
                                    margin: EdgeInsets.only(top: screenHeight * 0.0045),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.star,
                                          color: Theme.of(context).colorScheme.primary,
                                          size: screenWidth * 0.04,
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Text(4.5.toString(),
                                          style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.w600
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Container(
                              width: screenWidth * 0.92,
                              child: Text(establishment.address.toString(),
                                style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)
                                ),
                              ),
                            ),
                            if(widget.distance != null)
                              Container(
                                  width: screenWidth * 0.92,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(
                                      top: screenHeight * 0.01
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.location_pin, size: screenWidth * 0.034),
                                        SizedBox(width: screenWidth * 0.01),
                                        Padding(
                                          padding: EdgeInsets.only(top: screenHeight * 0.0025),
                                          child: Text('${(widget.distance ?? 0).toStringAsPrecision(2)} km away',
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.03
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ),

                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
                    margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Some things to note',
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: (establishment.parkingRate?.rateType ?? '') == 'tiered_hourly' ? 'Hourly Rate' : 'Flat Rate',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w600,
                                )
                              ),
                              TextSpan(
                                text: '  •  ',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03
                                ),
                              ),
                              if(establishment.parkingRate?.rateType == 'tiered_hourly')
                                TextSpan(
                                    children: [
                                      TextSpan(
                                          text: '₱${establishment.parkingRate?.baseRate}'
                                      ),
                                      TextSpan(
                                          text: ' first ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          )
                                      ),
                                      TextSpan(
                                          text: '${establishment.parkingRate?.baseHours}'
                                      ),
                                      TextSpan(
                                          text: ' hours, then ',
                                          style: TextStyle(
                                              fontFamily: 'Poppins'
                                          )
                                      ),
                                      TextSpan(
                                          text: '₱${establishment.parkingRate?.extraHourlyRate}',
                                      ),
                                      TextSpan(
                                          text: ' per hour',
                                          style: TextStyle(
                                              fontFamily: 'Poppins'
                                          )
                                      )
                                    ],
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'HelveticaNeue'
                                    )
                                ),
                              if(establishment.parkingRate?.rateType == 'flat_rate')
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '₱${establishment.parkingRate?.flatRate}',
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeue'
                                      )
                                    ),
                                    TextSpan(
                                        text: ' Fixed Rate',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: screenWidth * 0.028,
                                        )
                                    )
                                  ],
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.w400,
                                  )
                                )
                            ],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Theme.of(context).colorScheme.primary
                            )
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(3)
                              ),
                              padding: EdgeInsets.all(screenWidth * 0.005),
                              child: Icon(Icons.local_parking, color: Colors.white, size: screenWidth * 0.023),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text('${establishment.parkingSections?.fold<int>(0, (sum, section) => sum + (section.parkingSlots?.where((slot) => slot.slotStatus == 'available').length ?? 0)) ?? 0} out of ${establishment.parkingSections?.fold<int>(0, (sum, section) => sum + (section.parkingSlots?.length ?? 0)) ?? 0} slots are available',
                              style: TextStyle(
                                fontSize: screenWidth * 0.028,
                                height: 1.1
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Divider(
                          height: screenHeight * 0.015,
                          thickness: 0.2,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Contact Number',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(3)
                                        ),
                                        padding: EdgeInsets.all(screenWidth * 0.005),
                                        child: Icon(Icons.phone, color: Colors.white, size: screenWidth * 0.023),
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(establishment.contactNumber ?? '',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.028,
                                            height: 1.1
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Establishment Type',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(3)
                                        ),
                                        padding: EdgeInsets.all(screenWidth * 0.005),
                                        child: Icon(Icons.bloodtype, color: Colors.white, size: screenWidth * 0.023),
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(establishment.establishmentType ?? '',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.028,
                                            height: 1.1
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                ],
              ),
              Positioned(
                bottom: screenHeight * 0.04,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                child: InkWell(
                  onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return ParkingSheet(establishmentId: establishment.establishmentId);
                  }),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.06,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.primary
                    ),
                    alignment: Alignment.center,
                    child: Text('Explore',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
