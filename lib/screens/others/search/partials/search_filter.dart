import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SearchFilter extends StatefulWidget {
  final Map<String, dynamic> filter;

  const SearchFilter({
    super.key,
    required this.filter
  });

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  Map<String, dynamic> searchFilter = {};

  List<VehicleType> vehicleType = [];

  @override
  void initState() {
    super.initState();

    searchFilter = widget.filter;

    vehicleType = [
      VehicleType(0, 'Car', 'assets/svgs/search/car.svg'),
      VehicleType(1, 'Motorcycle', 'assets/svgs/search/motorcycle.svg'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.55,
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                  ),
                  child: Text('Search Filter',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.06
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vehicle Type',
                        style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 12.0, // Add spacing between items
                        runSpacing: 12.0, // Add spacing between rows
                        children: vehicleType.asMap().entries.map((e) {
                          final int index = e.key;
                          final VehicleType type = e.value;
                          
                          return InkWell(
                            onTap: () {
                              setState(() {
                                searchFilter['vehicle_type'] ??= []; // Ensure it's a list before using it
                                if ((searchFilter['vehicle_type'] as List).contains(type.name)) {
                                  (searchFilter['vehicle_type'] as List).remove(type.name);
                                } else {
                                  (searchFilter['vehicle_type'] as List).add(type.name);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: searchFilter['vehicle_type'] != null && (searchFilter['vehicle_type'] as List).contains(type.name) ? Theme.of(context).colorScheme.primary :  Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.035,
                                vertical: screenHeight * 0.008
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(type.svgAsset,
                                    width: screenWidth * 0.05,
                                    colorFilter: ColorFilter.mode(
                                      searchFilter['vehicle_type'] != null && (searchFilter['vehicle_type'] as List).contains(type.name) ? Colors.white : Theme.of(context).colorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.025),
                                  Text(type.name,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      fontWeight: searchFilter['vehicle_type'] != null && (searchFilter['vehicle_type'] as List).contains(type.name) ? FontWeight.bold : FontWeight.normal,
                                      color: searchFilter['vehicle_type'] != null && (searchFilter['vehicle_type'] as List).contains(type.name) ? Colors.white : Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: Text('Max Radius',
                          style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.01,
                          right: screenWidth * 0.07,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: SfSlider(
                                min: 0.0,
                                max: 40.0,
                                value: searchFilter['max_radius_km'] ?? 0.0,
                                interval: 20,
                                enableTooltip: false,
                                minorTicksPerInterval: 1,
                                edgeLabelPlacement: EdgeLabelPlacement.auto,
                                activeColor: Theme.of(context).colorScheme.primary,
                                labelPlacement: LabelPlacement.onTicks,
                                inactiveColor: Theme.of(context).colorScheme.secondary,
                                onChanged: (dynamic value){
                                  setState(() {
                                    searchFilter['max_radius_km'] = double.parse((value).toStringAsPrecision(2));
                                  });

                                  print(searchFilter);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: TextEditingController(text: '${searchFilter['max_radius_km'] ?? 0.0} km'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * 0.03
                                ),
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02,
                                      vertical: 0
                                  ),
                                  isDense: true,
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                        width: 2
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: screenHeight * 0.03,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05
            ),
            width: screenWidth,
            child: ElevatedButton(
              onPressed: searchFilter.isEmpty ? null : () {
                Navigator.pop(context, searchFilter);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                disabledBackgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.013
                ),
              ),
              child: Text('Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.04
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VehicleType {
  int id;
  String name;
  String svgAsset;

  VehicleType(this.id, this.name, this.svgAsset);
}
