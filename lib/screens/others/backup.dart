import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../../../../globals.dart';
import '../../../../main.dart';
import '../../../../models/reservation_model.dart';

class SlotTimePicker extends StatefulWidget {
  final String slotId;

  const SlotTimePicker({
    super.key,
    required this.slotId
  });

  @override
  _SlotTimePickerState createState() => _SlotTimePickerState();
}

class _SlotTimePickerState extends State<SlotTimePicker> {
  List<String> time = [
    '1:00', '1:15', '1:30', '1:45',
    '2:00', '2:15', '2:30', '2:45',
    '3:00', '3:15', '3:30', '3:45',
    '4:00', '4:15', '4:30', '4:45',
    '5:00', '5:15', '5:30', '5:45',
    '6:00', '6:15', '6:30', '6:45',
    '7:00', '7:15', '7:30', '7:45',
    '8:00', '8:15', '8:30', '8:45',
    '9:00', '9:15', '9:30', '9:45',
    '10:00', '10:15', '10:30', '10:45',
    '11:00', '11:15', '11:30', '11:45',
    '12:00', '12:15', '12:30', '12:45',
  ];
  List<String> meridiemIndicator = ['AM', 'PM'];
  final FixedExtentScrollController _timeController = FixedExtentScrollController();
  final FixedExtentScrollController _meridiemController = FixedExtentScrollController();
  Stream<List<Map<String, dynamic>>>? slotReservationStream;

  @override
  void dispose() {
    super.dispose();

    _meridiemController.dispose();
    _timeController.dispose();
  }

  @override
  void initState() {
    super.initState();

    _setupParkingStream();
  }

  void _setupParkingStream() {
    slotReservationStream = supabase
        .from('reservations')
        .stream(primaryKey: ['slot_id'])
        .eq('slot_id', widget.slotId)
        .asyncMap((reservations) async {
      if (reservations.isNotEmpty) {
        return [
          {
            'reservations': reservations.isNotEmpty ? reservations.map((e) => Reservation.fromMap(e)).toList()  : []
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
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: slotReservationStream,
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }

          final reservations = (snapshot.data?.isNotEmpty == true)
              ? snapshot.data!.first['reservations'] as List<Reservation>
              : [];

          return Container(
            height: screenHeight * 0.4,
            width: screenWidth,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: screenHeight * 0.25,
                          child: WheelSlider.customWidget(
                            totalCount: 12,
                            initValue: 5,
                            isInfinite: false,
                            onValueChanged: (val) {
                              print(val);
                            },
                            enableAnimation: true,
                            hapticFeedbackType: HapticFeedbackType.vibrate,
                            showPointer: false,
                            itemSize: screenHeight * 0.045,
                            controller: _timeController,
                            verticalListWidth: screenWidth * 0.22,
                            horizontal: false,
                            children: time.asMap().entries.map((entry) {
                              final index = entry.key;
                              final time = entry.value;

                              return InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                                    _timeController.animateToItem(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(time,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: screenWidth * 0.05,
                                        letterSpacing: 1
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                          top: screenHeight * 0.1,
                          bottom: screenHeight * 0.1,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Container(
                              width: screenWidth * 0.03,
                              height: screenHeight * 0.03,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(30)
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Stack(
                      children: [
                        Container(
                          height: screenHeight * 0.25,
                          child: WheelSlider.customWidget(
                            totalCount: 12,
                            initValue: 5,
                            isInfinite: false,
                            onValueChanged: (val) {
                              print(val);
                            },
                            controller: _meridiemController,
                            enableAnimation: true,
                            allowPointerTappable: true,
                            hapticFeedbackType: HapticFeedbackType.vibrate,
                            showPointer: false,
                            itemSize: screenHeight * 0.045,
                            verticalListWidth: screenWidth * 0.22,
                            horizontal: false,
                            children: meridiemIndicator.asMap().entries.map((entry) {
                              final index = entry.key;
                              final time = entry.value;

                              return InkWell(
                                onTap: () {
                                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                                    _meridiemController.animateToItem(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                  });
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(time,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: screenWidth * 0.05,
                                        letterSpacing: 1
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                          top: screenHeight * 0.1,
                          bottom: screenHeight * 0.1,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Container(
                              width: screenWidth * 0.03,
                              height: screenHeight * 0.03,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(30)
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        }
    );
  }
}