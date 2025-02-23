import 'package:eseepark/models/establishment_model.dart';
import 'package:eseepark/screens/others/search/partials/show_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../globals.dart';

class SearchResultWords extends StatefulWidget {
  final String searchedWords;
  final List<Establishment> establishments;

  const SearchResultWords({
    super.key,
    required this.searchedWords,
    required this.establishments
  });

  @override
  State<SearchResultWords> createState() => _SearchResultWordsState();
}

class _SearchResultWordsState extends State<SearchResultWords> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
      ),
      child: ListView(
        children: [
          SizedBox(height: screenHeight * 0.01),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.establishments.length.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' establishments for ',
                ),
                TextSpan(
                  text: '"${widget.searchedWords}"',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: screenWidth * 0.038,
                color: Theme.of(context).colorScheme.primary
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          ...widget.establishments.asMap().entries.map((entry) {
            final index = entry.key;
            final establishment = entry.value;

            return InkWell(
              onTap: () => Get.to(() => ShowInfo(
                establishmentId: establishment.establishmentId,
                distance: establishment.distance,
              ),
                duration: Duration(milliseconds: 300),
                transition: Transition.downToUp,
              ),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 0.3,
                      height: screenWidth * 0.3,
                      margin: EdgeInsets.only(right: screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                        image: establishment.image != null ? DecorationImage(
                          image: NetworkImage(establishment.image ?? ''),
                          fit: BoxFit.cover
                        ) : DecorationImage(
                          image: AssetImage('assets/images/general/eseepark-transparent-logo-768.png'),
                          scale: 15
                        )
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.005),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(establishment.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: screenWidth * 0.01, bottom: screenWidth * 0.0009),
                                            child: Icon(Icons.star,
                                                size: screenWidth * 0.04,
                                                color: Theme.of(context).colorScheme.primary
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: 4.5.toString(),
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: screenWidth * 0.03,
                                              fontWeight: FontWeight.w600,
                                              height: 1
                                          ),
                                        ),
                                        TextSpan(
                                          text: '  ·  ',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.w600,
                                              height: 1.1
                                          ),
                                        ),
                                        TextSpan(
                                          text: establishment.establishmentType,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: screenWidth * 0.03,
                                              fontWeight: FontWeight.w400,
                                              height: 1
                                          ),
                                        ),
                                      ],
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary
                                      )
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Container(
                                            padding: EdgeInsets.all(screenWidth * 0.005),
                                            margin: EdgeInsets.only(right: screenWidth * 0.015, top: screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                            child: Icon(Icons.location_pin,
                                                size: screenWidth * 0.03,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: establishment.distance != null ? '${(establishment.distance ?? 0).toStringAsPrecision(2)} km away' : 'N/A',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: screenWidth * 0.03,
                                              fontWeight: FontWeight.w400,
                                              height: 1
                                          ),
                                        ),
                                        TextSpan(
                                          text: '  ·  ',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.w600,
                                              height: 1.1
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${establishment.parkingSlotsCount} slots available',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: screenWidth * 0.03,
                                              fontWeight: FontWeight.w400,
                                              color: establishment.parkingSlotsCount == 0 ? Colors.red : establishment.parkingSlotsCount == 1 ? Colors.deepOrange : Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                                              height: 1
                                          ),
                                        ),
                                      ],
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary
                                      )
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Wrap(
                                      spacing: screenWidth * 0.01,
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
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.005),
                              ],
                            ),
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
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );

          }).toList(),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("That's all for now!",
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
