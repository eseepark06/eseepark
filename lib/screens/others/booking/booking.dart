import 'package:eseepark/models/establishment_model.dart';
import 'package:eseepark/models/parking_section_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../globals.dart';
import '../../../main.dart';
import '../../../models/parking_slot_model.dart';

class Booking extends StatefulWidget {
  final String slotId;
  final int availableSlots;

  const Booking({
    super.key,
    required this.slotId,
    required this.availableSlots
  });

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final ScrollController scrollController = ScrollController();
  Stream<List<Map<String, dynamic>>>? parkingStream;

  @override
  void initState() {
    super.initState();
    _setupParkingStream();
  }

  void _setupParkingStream() {
    parkingStream = supabase
        .from('parking_slots')
        .stream(primaryKey: ['slot_id'])
        .eq('slot_id', widget.slotId)
        .asyncMap((slots) async {
      if (slots.isNotEmpty) {
        final slot = slots.first;


        if(slot['status'] != 'available') {
          print('Oops! This slot is already occupied');

          return <Map<String, dynamic>>[];
        }

        final sectionData = await supabase
            .from('parking_sections')
            .select()
            .eq('section_id', slot['section_id'])
            .single();

        final establishmentData = await supabase
            .from('establishments')
            .select()
            .eq('establishment_id', sectionData['establishment_id'])
            .single();

        return [
          {
            'slot': ParkingSlot.fromMap(slot),
            'section': ParkingSection.fromMap(sectionData),
            'establishment': Establishment.fromMap(establishmentData),
          }
        ];
      }
      return <Map<String, dynamic>>[];
    }).asyncExpand((event) async* {
      yield event; // Yield the data received from asyncMap
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: parkingStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Data Available"));
          }

          final data = snapshot.data!.first;
          final slot = data['slot'] as ParkingSlot;
          final section = data['section'] as ParkingSection;
          final establishment = data['establishment'] as Establishment;

          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: screenHeight * 0.24, // Set an estimated height, this will be adjusted
                pinned: true,
                elevation: 1,
                scrolledUnderElevation: 0,
                centerTitle: true,
                floating: true,
                collapsedHeight: screenHeight * 0.24,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    double maxHeight = constraints.maxHeight; // Dynamic height based on content
                    return FlexibleSpaceBar(
                      background: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + screenHeight * 0.02, // Adjust for status bar
                          left: screenWidth * 0.04,
                          right: screenWidth * 0.04,
                          bottom: screenHeight * 0.02,
                        ),
                        decoration: BoxDecoration(color: Colors.white),
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
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                        left: screenWidth * 0.04,
                        right: screenWidth * 0.04,
                        bottom: screenHeight * 0.02,
                      ),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Parking Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize * 0.015,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text('Operation',
                            style: TextStyle(
                                color: Color(0xFF808080).withValues(alpha: 0.7),
                                fontSize: screenSize * 0.011,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            children: [
                              Text('Open Now • ',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: screenSize * 0.012,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              Text('10:00 AM - 11:30 PM',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize * 0.012,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                        left: screenWidth * 0.04,
                        right: screenWidth * 0.04,
                        bottom: screenHeight * 0.02,
                      ),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Slot Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize * 0.015,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text('Section - Slot No. & Floor',
                            style: TextStyle(
                                color: Color(0xFF808080).withValues(alpha: 0.7),
                                fontSize: screenSize * 0.011,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            children: [
                              Text('${section.name}-${slot.slotNumber} • ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize * 0.012,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              Text('Floor ${section.floorLevel}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize * 0.012,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text('Vehicle',
                            style: TextStyle(
                                color: Color(0xFF808080).withValues(alpha: 0.7),
                                fontSize: screenSize * 0.011,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1D1D1).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.013,
                                horizontal: screenWidth * 0.05
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Select a Vehicle',
                                  style: TextStyle(
                                      color: const Color(0xFF808080).withValues(alpha: 0.9),
                                      fontSize: screenSize * 0.012,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down, color: const Color(0xFF808080).withValues(alpha: 0.9),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                        left: screenWidth * 0.04,
                        right: screenWidth * 0.04,
                        bottom: screenHeight * 0.02,
                      ),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Parking Type Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize * 0.015,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text('Section - Slot No. & Floor',
                            style: TextStyle(
                                color: Color(0xFF808080).withValues(alpha: 0.7),
                                fontSize: screenSize * 0.011,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            children: [
                              Text('${section.name}-${slot.slotNumber} • ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize * 0.012,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              Text('Floor ${section.floorLevel}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize * 0.012,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text('Vehicle',
                            style: TextStyle(
                                color: Color(0xFF808080).withValues(alpha: 0.7),
                                fontSize: screenSize * 0.011,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1D1D1).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.013,
                                horizontal: screenWidth * 0.05
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Select a Vehicle',
                                  style: TextStyle(
                                      color: const Color(0xFF808080).withValues(alpha: 0.9),
                                      fontSize: screenSize * 0.012,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down, color: const Color(0xFF808080).withValues(alpha: 0.9),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
