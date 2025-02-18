import 'dart:async';
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eseepark/customs/custom_widgets.dart';
import 'package:eseepark/models/establishment_model.dart';
import 'package:eseepark/models/parking_slot_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../controllers/establishments/establishments_controller.dart';
import '../../../../globals.dart';
import '../../../../models/parking_section_model.dart';


class Section {
  final int id;
  final String section;

  const Section({
    required this.id,
    required this.section
  });
}

class Slot {
  final int id;
  final Section slotSection;
  final int slotNo;
  final String slotStatus;
  int? timeOccupied;

  Slot({
    required this.id,
    required this.slotSection,
    required this.slotNo,
    required this.slotStatus,
    this.timeOccupied
  });

  void incrementTime() {
    if (slotStatus == 'Occupied' && timeOccupied != null) {
      timeOccupied = timeOccupied! + 1; // Increment time by 1 second
    }
  }
}

class ParkingSheet extends StatefulWidget {
  final String establishmentId;

  const ParkingSheet({
    super.key,
    required this.establishmentId
  });

  @override
  State<ParkingSheet> createState() => _ParkingSheetState();
}

class _ParkingSheetState extends State<ParkingSheet> {
  final _controller = EstablishmentController();
  int floorIndex = 0;
  late Timer _timer;

  List<Section> sectionList = [
    Section(id: 1, section: 'A'),
    Section(id: 2, section: 'B'),
    Section(id: 3, section: 'C'),
  ];

  List<Slot> slots = [];

  List<Slot> generateSlots() {
    List<Slot> slots = [];
    Random random = Random();

    for (var section in sectionList) {
      for (int i = 1; i <= 5; i++) {
        bool isOccupied = random.nextBool();
        slots.add(Slot(
          id: (section.id - 1) * 5 + i,
          slotSection: section,
          slotNo: i,
          slotStatus: isOccupied ? 'Occupied' : 'Available',
          timeOccupied: isOccupied ? random.nextInt(120) + 1 : null, // 1 to 120 minutes
        ));
      }
    }
    return slots;
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        for (var slot in slots) {
          slot.incrementTime();
        }
      });
    });
  }


  @override
  void initState() {
    super.initState();

    slots = generateSlots();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _timer.cancel();
  }

  final List<String> items = [
    'All',
    'Free',
    'Occupied',
  ];

  String selectedValue = 'All';
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
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


      // // Filter based on the selected value
      // if (selectedValue == 'Free') {
      //   filteredSlots = (establishment.parkingSections
      //       ?.where((section) => section.parkingSlots!.where((slot) => slot.slotStatus == 'available').isNotEmpty)
      //       .toList() ?? []).cast<ParkingSlot>();
      //
      //   print('filteredSlots: $filteredSlots');
      //
      // } else if (selectedValue == 'Occupied') {
      //   filteredSlots = (establishment.parkingSections
      //       ?.where((section) => section.parkingSlots!.where((slot) => slot.slotStatus == 'occupied').isNotEmpty)
      //       .toList() ?? []).cast<ParkingSlot>();
      // }

        return Container(
          height: screenHeight * 0.83,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.04
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(establishment.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize * 0.018,

                            ),),
                            Text('Slots Available: ${establishment.parkingSections
                                ?.fold<int>(0, (sum, section) => sum + (section.parkingSlots?.where((slot) => slot.slotStatus == 'available').length ?? 0)) ?? 0}',
                            style: TextStyle(
                              color: (establishment.parkingSections
                                  ?.fold<int>(0, (sum, section) => sum + (section.parkingSlots?.where((slot) => slot.slotStatus == 'available').length ?? 0)) ?? 0) == 0 ? Colors.red : Color(0xff808080),
                              fontSize: screenSize * 0.01
                            ),)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffcacaca)
                          ),
                          shape: BoxShape.circle
                        ),
                        padding: EdgeInsets.all(screenSize * 0.01),
                        child: Icon(Icons.close),
                      ),
                    )
                  ],
                ),
              ), // MALL NAME, SLOTS, N BUTTON
              Container(
                height: screenHeight * 0.05,
                width: screenWidth,
                child: ListView.builder(
                  itemCount: establishment.parkingSections?.fold(0, (val, section) => (section.floorLevel ?? 0) > (val ?? 0) ? val = section.floorLevel : val) ?? 0,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          floorIndex = index;
                        });
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      child: Container(
                        decoration: BoxDecoration(
                          color: floorIndex == index ? Theme.of(context).colorScheme.primary : Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(30)
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05
                        ),
                        margin: EdgeInsets.only(
                          left: index == 0 ? screenWidth * 0.03 : screenWidth * 0.045
                        ),
                        child: Text('Floor ${index+1}',
                          style: TextStyle(
                            color: floorIndex == index ? Color(0xffffffff) : Color(0xff545454),
                            fontWeight: floorIndex == index ? FontWeight.bold : FontWeight.normal
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ), //
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text('Showing Details for Floor ${floorIndex+1}',
                        style: TextStyle(
                            color: Color(0xff808080)
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Select Item',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: items
                              .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            enabled: true,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: selectedValue == item ? Theme.of(context).colorScheme.primary : Colors.white
                              ),
                              child: Text(
                                item,
                                style: TextStyle(
                                    fontSize: screenSize * 0.012,
                                    fontWeight: selectedValue == item ? FontWeight.bold : FontWeight.normal,
                                    color: selectedValue == item ? Colors.white : Colors.black
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: 160,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            elevation: 0,
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor: Colors.white,
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    width: .5,
                                    color: const Color(0xFFD1D1D1)
                                )
                            ),
                            elevation: 0,
                            offset: const Offset(-110, -10),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            selectedMenuItemBuilder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.015,
                                    horizontal: screenWidth * 0.03
                                ),
                                child: Text(selectedValue,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenSize * 0.012
                                  ),
                                ),
                              );
                            },
                            padding: const EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: GridView.builder(
                    itemCount: establishment.parkingSections
                        ?.fold<int>(0, (sum, section) => sum + (section.parkingSlots?.where((slot) {
                          bool isSorted = selectedValue == 'All' ? true : slot.slotStatus == (selectedValue == 'Free' ? 'available' : selectedValue.toLowerCase());

                          return isSorted;
                    }).length ?? 0)) ?? 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 14,
                      childAspectRatio: 2.4,
                    ),
                    itemBuilder: (context, index) {
                      // ✅ Explicitly define allSlots as a List of Maps
                      final List<Map<String, dynamic>> allSlots = establishment.parkingSections
                          ?.expand((section) => section.parkingSlots
                          ?.where((slot) {
                        bool isSorted = selectedValue == 'All'
                            ? true
                            : slot.slotStatus == (selectedValue == 'Free' ? 'available' : selectedValue.toLowerCase());

                        return isSorted;
                      })
                          .map((slot) => {'section': section, 'slot': slot})
                          .toList() ?? <Map<String, dynamic>>[])
                          .toList()
                          .cast<Map<String, dynamic>>() ?? [];

                      if (index >= allSlots.length) return SizedBox(); // Prevents index errors

                      // ✅ Accessing section and slot correctly
                      final ParkingSection section = allSlots[index]['section'] as ParkingSection;
                      final ParkingSlot currentSlot = allSlots[index]['slot'] as ParkingSlot;


                      return Container(
                        decoration: BoxDecoration(
                          border: currentSlot.slotStatus == 'available'
                              ? Border.all(width: .6, color: const Color(0xFFD1D1D1))
                              : null,
                          color: currentSlot.slotStatus == 'available'
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Display Section-Number (A-1, A-2, B-1, etc.)
                            Text(
                              '${section.name}-${currentSlot.slotNumber}',
                              style: TextStyle(
                                fontSize: screenSize * 0.015,
                                fontWeight: FontWeight.bold,
                                height: 1,
                                color: currentSlot.slotStatus == 'available' ? Colors.black : Colors.white,
                              ),
                            ),
                            if (currentSlot.slotStatus != 'Under Maintenance')
                              ParkingSlotTimer(slotStatus: currentSlot.slotStatus, timeTaken: currentSlot.timeTaken?.toString()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.03,
                  bottom: screenHeight * 0.03,
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.017
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize * 0.014,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Icon(Icons.double_arrow_outlined,
                              color: Colors.white,
                              size: screenSize * 0.017,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.06),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.3
                        ),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.04
                      ),
                      child: Icon(Icons.info,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    )
                  ],
                )
              )
            ],
          ),
        );
      },
    );
  }
}
