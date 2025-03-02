import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wheel_slider/wheel_slider.dart';
import '../../../../globals.dart';
import '../../../../main.dart';
import '../../../../models/reservation_model.dart';

class SlotTimePicker extends StatefulWidget {
  final String slotId;

  const SlotTimePicker({
    super.key,
    required this.slotId,
  });

  @override
  _SlotTimePickerState createState() => _SlotTimePickerState();
}

class _SlotTimePickerState extends State<SlotTimePicker> {
  final List<DateTime> timeSlots = List.generate(
    24,
        (index) => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, index ~/ 2, (index % 2) * 30),
  );
  final List<String> meridiemIndicator = ['AM', 'PM'];
  DateTime slotTime = DateTime.now();
  int selectedMeridiemIndex = 0;
  int selectedTimeIndex = 0;
  final FixedExtentScrollController _timeController = FixedExtentScrollController();
  final FixedExtentScrollController _meridiemController = FixedExtentScrollController();
  Stream<List<Map<String, dynamic>>>? slotReservationStream;
  Set<String> reservedTimes = {};

  bool isAllowed = false;

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
        List<Reservation> validReservations = reservations
            .map((e) => Reservation.fromMap(e))
            .where((res) =>
        res.status != 'completed' &&
            res.status != 'cancelled' &&
            res.status != 'expired')
            .toList();

        reservedTimes = validReservations.map((res) {
          return DateFormat('yyyy-MM-dd h:mm a').format(res.startTime);
        }).toSet();

        print(reservedTimes);
      }
      return [
        {'reservations': reservations.map((e) => Reservation.fromMap(e)).toList()}
      ];
    });

    setState(() {});
  }

  String formatTime(DateTime time) {
    return DateFormat('h:mm').format(time);
  }

  String formatSelectedTime({String format = 'yyyy-MM-dd h:mm a'}) {
    DateTime selectedTime = timeSlots[selectedTimeIndex];
    String meridiem = meridiemIndicator[selectedMeridiemIndex];

    int hour = selectedTime.hour;
    if (meridiem == 'PM' && hour != 12) {
      hour += 12;
    } else if (meridiem == 'AM' && hour == 12) {
      hour = 0;
    }

    DateTime finalTime = DateTime(
      selectedTime.year,
      selectedTime.month,
      selectedTime.day,
      hour,
      selectedTime.minute,
    );

    return DateFormat(format).format(finalTime);
  }

  int getAvailableSlots(DateTime selectedTime, List<Reservation> reservations) {
    int availableCount = 0;

    print('Selected Time: $selectedTime');

    for (DateTime slot in timeSlots) {
      int hour = slot.hour;
      if (selectedMeridiemIndex == 1) {
         if (hour != 12) {
          hour += 12;
        }
      } else { // AM case
        if (hour == 12) {
          hour = 0;
        }
      }

      DateTime adjustedSlotTime = DateTime.utc(
        slot.year,
        slot.month,
        slot.day,
        hour,
        slot.minute,
      );


      if (adjustedSlotTime.isBefore(selectedTime)) {
        // print('Skipping slot: $adjustedSlotTime (before selected time of $selectedTime)');
        continue;
      }

      bool isReserved = reservations.any((reservation) {
        DateTime reservationStartTime = DateTime.utc(
          reservation.startTime.year,
          reservation.startTime.month,
          reservation.startTime.day,
          reservation.startTime.hour,
          reservation.startTime.minute,
        );
        DateTime reservationEndTime = DateTime.utc(
          reservation.endTime.year,
          reservation.endTime.month,
          reservation.endTime.day,
          reservation.endTime.hour,
          reservation.endTime.minute,
        );

        bool overlaps = (adjustedSlotTime.isAfter(reservationStartTime) && adjustedSlotTime.isBefore(reservationEndTime)) ||
            adjustedSlotTime.isAtSameMomentAs(reservationStartTime) ||
            adjustedSlotTime.isAtSameMomentAs(reservationEndTime);

                // print('Slot: $adjustedSlotTime | Reservation Start: $reservationStartTime | Reservation End: $reservationEndTime | Overlaps: $overlaps');

        return overlaps;
      });

      if (isReserved) {
        // print('Slot: $adjustedSlotTime is reserved. Stopping count.');
        break;
      }

      // print('Slot: $adjustedSlotTime is available.');
      availableCount++;
    }

    if (selectedMeridiemIndex == 0) {
      // print('Checking PM slots...');
      for (DateTime slot in timeSlots) {
        int hour = slot.hour + 12;
        if (hour == 24) hour = 12;

        DateTime adjustedSlotTime = DateTime.utc(
          slot.year,
          slot.month,
          slot.day,
          hour,
          slot.minute,
        );

        print('Adjusted PM Slot Time: $adjustedSlotTime');

        if (adjustedSlotTime.isBefore(selectedTime)) {
          print('Skipping PM slot: $adjustedSlotTime (before selected time of $selectedTime)');
          continue;
        }

        bool isReserved = reservations.any((reservation) {
          DateTime reservationStartTime = DateTime.utc(
            reservation.startTime.year,
            reservation.startTime.month,
            reservation.startTime.day,
            reservation.startTime.hour,
            reservation.startTime.minute,
          );
          DateTime reservationEndTime = DateTime.utc(
            reservation.endTime.year,
            reservation.endTime.month,
            reservation.endTime.day,
            reservation.endTime.hour,
            reservation.endTime.minute,
          );

          bool overlaps = (adjustedSlotTime.isAfter(reservationStartTime) && adjustedSlotTime.isBefore(reservationEndTime)) ||
              adjustedSlotTime.isAtSameMomentAs(reservationStartTime) ||
              adjustedSlotTime.isAtSameMomentAs(reservationEndTime);

          // Debugging output for reservation checking
          print('PM Slot: $adjustedSlotTime | Reservation Start: $reservationStartTime | Reservation End: $reservationEndTime | Overlaps: $overlaps');

          return overlaps;
        });

        if (isReserved) {
          print('PM Slot: $adjustedSlotTime is reserved. Stopping count.');
          break;
        }

        print('PM Slot: $adjustedSlotTime is available.');
        availableCount++;
      }
    }

    print('Total available slots from selected time: $availableCount');
    return availableCount;
  }
  List<DateTime> generateTimeSlots() {
    DateTime now = DateTime.now();
    List<DateTime> slots = [];
    for (int i = 0; i < 24; i++) {
      DateTime slotTime = DateTime(now.year, now.month, now.day, i ~/ 2, (i % 2) * 30);
      slots.add(slotTime);
    }
    return slots;
  }

  @override
  void dispose() {
    _timeController.dispose();
    _meridiemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: slotReservationStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

        final reservations = (snapshot.data?.isNotEmpty == true)
            ? snapshot.data!.first['reservations'] as List<Reservation>
            : [];

        return Container(
          height: screenHeight * 0.45,
          width: screenWidth,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    top: screenHeight * 0.03,
                    bottom: screenHeight * 0.01
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text('Select a Time',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.05
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2
                            )
                        ),
                        padding: EdgeInsets.all(screenSize * 0.001),
                        child: Icon(Icons.close,
                            color: Theme.of(context).colorScheme.primary,
                            size: screenWidth * 0.06
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TIME PICKER (30-minute intervals)
                  Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.25,
                        child: WheelSlider.customWidget(
                          totalCount: 24, // 24 values for 30-minute intervals
                          initValue: 0, // Start at the first available time
                          isInfinite: false,
                          onValueChanged: (val) {
                            setState(() {
                              selectedTimeIndex = val;
                            });

                            int hour = timeSlots[val].hour;
                            int minute = timeSlots[val].minute;

                            // Adjust hour based on selected meridiem
                            if (selectedMeridiemIndex == 1) { // 1 means PM
                              if (hour != 12) {
                                hour += 12; // Convert to 24-hour format
                              }
                            } else { // AM case
                              if (hour == 12) {
                                hour = 0; // Midnight case
                              }
                            }

                            // Create a DateTime object for the current time slot in UTC
                            slotTime = DateTime.utc(
                              timeSlots[val].year,
                              timeSlots[val].month,
                              timeSlots[val].day,
                              hour,
                              minute,
                            );

                            // Check if the slot time is reserved based on start and end times
                            bool isReserved = reservations.any((reservation) {
                              if (reservation.startTime.isBefore(reservation.endTime)) {
                                DateTime reservationStartTime = DateTime.utc(
                                  reservation.startTime.year,
                                  reservation.startTime.month,
                                  reservation.startTime.day,
                                  reservation.startTime.hour,
                                  reservation.startTime.minute,
                                );
                                DateTime reservationEndTime = DateTime.utc(
                                  reservation.endTime.year,
                                  reservation.endTime.month,
                                  reservation.endTime.day,
                                  reservation.endTime.hour,
                                  reservation.endTime.minute,
                                );

                                bool overlaps = (slotTime.isAfter(reservationStartTime) && slotTime.isBefore(reservationEndTime)) ||
                                    (slotTime.isAtSameMomentAs(reservationStartTime) || slotTime.isAtSameMomentAs(reservationEndTime)) ||
                                    (reservationStartTime.isBefore(slotTime) && reservationEndTime.isAfter(slotTime)) ||
                                    (slotTime.isAtSameMomentAs(reservationStartTime)); // Include exact match for startTime

                                // print('Is reserved: $overlaps');
                                return overlaps;
                              }
                              return false; // Not a valid reservation
                            });

                            setState(() {
                              isAllowed = !isReserved;
                            });



                            print('Time Slot Changed to  : $slotTime');

                            int availableSlots = getAvailableSlots(slotTime, reservations as List<Reservation>);
                            print('Available slots for booking: $availableSlots');

                          },
                          enableAnimation: true,
                          hapticFeedbackType: HapticFeedbackType.vibrate,
                          showPointer: false,
                          itemSize: screenHeight * 0.045,
                          controller: _timeController,
                          verticalListWidth: screenWidth * 0.22,
                          horizontal: false,
                          children: timeSlots.asMap().entries.map((entry) {
                            final index = entry.key;
                            final time = entry.value;
                            int hour = time.hour;
                            int minute = time.minute;

                            // Adjust hour based on selected meridiem
                            if (selectedMeridiemIndex == 1) { // 1 means PM
                              if (hour != 12) {
                                hour += 12; // Convert to 24-hour format
                              }
                            } else { // AM case
                              if (hour == 12) {
                                hour = 0; // Midnight case
                              }
                            }

                            // Create a DateTime object for the current time slot in UTC
                            slotTime = DateTime.utc(
                              time.year,
                              time.month,
                              time.day,
                              hour,
                              minute,
                            );

                            // Check if the slot time is reserved based on start and end times
                            bool isReserved = reservations.any((reservation) {
                              if (reservation.startTime.isBefore(reservation.endTime)) {
                                DateTime reservationStartTime = DateTime.utc(
                                  reservation.startTime.year,
                                  reservation.startTime.month,
                                  reservation.startTime.day,
                                  reservation.startTime.hour,
                                  reservation.startTime.minute,
                                );
                                DateTime reservationEndTime = DateTime.utc(
                                  reservation.endTime.year,
                                  reservation.endTime.month,
                                  reservation.endTime.day,
                                  reservation.endTime.hour,
                                  reservation.endTime.minute,
                                );

                                bool overlaps = (slotTime.isAfter(reservationStartTime) && slotTime.isBefore(reservationEndTime)) ||
                                    (slotTime.isAtSameMomentAs(reservationStartTime) || slotTime.isAtSameMomentAs(reservationEndTime)) ||
                                    (reservationStartTime.isBefore(slotTime) && reservationEndTime.isAfter(slotTime)) ||
                                    (slotTime.isAtSameMomentAs(reservationStartTime)); // Include exact match for startTime

                                // print('Is reserved: $overlaps');
                                return overlaps;
                              }
                              return false; // Not a valid reservation
                            });

                            return InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {

                                WidgetsBinding.instance.addPostFrameCallback((_) async {
                                  _timeController.animateToItem(index,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                });

                                // Existing onTap logic can go here if needed
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  formatTime(time),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: screenWidth * 0.05,
                                    letterSpacing: 1,
                                    color: isReserved ? Colors.grey : Colors.black,
                                    fontWeight: isReserved ? FontWeight.w300 : FontWeight.w600,
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
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.25,
                        child: WheelSlider.customWidget(
                          totalCount: 2,
                          initValue: 0,
                          isInfinite: false,
                          onValueChanged: (val) {
                            setState(() {
                              selectedMeridiemIndex = val;
                            });
                            print(formatSelectedTime());

                            int hour = timeSlots[selectedTimeIndex].hour;
                            int minute = timeSlots[selectedTimeIndex].minute;

                            if (selectedMeridiemIndex == 1) {
                              if (hour != 12) {
                                hour += 12;
                              }
                            } else { // AM case
                              if (hour == 12) {
                                hour = 0;
                              }
                            }

                            slotTime = DateTime.utc(
                              timeSlots[selectedTimeIndex].year,
                              timeSlots[selectedTimeIndex].month,
                              timeSlots[selectedTimeIndex].day,
                              hour,
                              minute,
                            );

                            // Check if the slot time is reserved based on start and end times
                            bool isReserved = reservations.any((reservation) {
                              if (reservation.startTime.isBefore(reservation.endTime)) {
                                DateTime reservationStartTime = DateTime.utc(
                                  reservation.startTime.year,
                                  reservation.startTime.month,
                                  reservation.startTime.day,
                                  reservation.startTime.hour,
                                  reservation.startTime.minute,
                                );
                                DateTime reservationEndTime = DateTime.utc(
                                  reservation.endTime.year,
                                  reservation.endTime.month,
                                  reservation.endTime.day,
                                  reservation.endTime.hour,
                                  reservation.endTime.minute,
                                );

                                bool overlaps = (slotTime.isAfter(reservationStartTime) && slotTime.isBefore(reservationEndTime)) ||
                                    (slotTime.isAtSameMomentAs(reservationStartTime) || slotTime.isAtSameMomentAs(reservationEndTime)) ||
                                    (reservationStartTime.isBefore(slotTime) && reservationEndTime.isAfter(slotTime)) ||
                                    (slotTime.isAtSameMomentAs(reservationStartTime)); // Include exact match for startTime

                                // print('Is reserved: $overlaps');
                                return overlaps;
                              }
                              return false; // Not a valid reservation
                            });

                            setState(() {
                              isAllowed = !isReserved;
                            });

                            int availableSlots = getAvailableSlots(slotTime, reservations as List<Reservation>);
                            print('Available slots for booking: $availableSlots');
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
                            final period = entry.value;

                            return InkWell(
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) async {
                                  _meridiemController.animateToItem(index,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                });
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  period,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: screenWidth * 0.05,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600,
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
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015
                ),
                margin: EdgeInsets.only(bottom: screenHeight * 0.025),
                child: ElevatedButton(
                  onPressed: isAllowed ? () {

                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.013
                    ),
                  ),
                  child: Text('Select ${formatSelectedTime(format: 'h:mm a')}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}