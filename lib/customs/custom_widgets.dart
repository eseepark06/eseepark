import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

class Section extends StatefulWidget {
  final String title;
  final double? titleSize;
  final List<Widget>? children;

  const Section({
    super.key,
    this.titleSize,
    required this.title,
    this.children
  });

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(width: screenWidth * 0.02),
              Text(widget.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: widget.titleSize ?? screenSize * 0.014,
                      fontWeight: FontWeight.w600
                  )
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Container(
              width: screenWidth,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14)
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.0
              ),
              child: Column(
                children: widget.children ?? [],
              )
          )
        ],
      ),
    );
  }
}

class SectionItem extends StatefulWidget {
  final String title;
  final bool? showDivider;
  final Function()? onTap;
  const SectionItem({
    super.key,
    required this.title,
    this.showDivider,
    this.onTap
  });

  @override
  State<SectionItem> createState() => _SectionItemState();
}

class _SectionItemState extends State<SectionItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
            horizontal: screenWidth * 0.01
        ),
        decoration: BoxDecoration(
            border: widget.showDivider != null && widget.showDivider == true ? Border(
                bottom: BorderSide(
                    color: const Color(0xFFD1D1D1),
                    width: .3
                )
            ) : null
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: screenSize * 0.012,
                    fontWeight: FontWeight.w400
                )
            ),
            Icon(Icons.chevron_right,
                color: const Color(0xFFD1D1D1),
                size: screenSize * 0.018
            )
          ],
        ),
      ),
    );
  }
}

class ParkingSlotTimer extends StatefulWidget {
  final String slotStatus;
  final String? timeTaken;

  const ParkingSlotTimer({
    super.key,
    required this.slotStatus,
    this.timeTaken,
  });

  @override
  _ParkingSlotTimerState createState() => _ParkingSlotTimerState();
}

class _ParkingSlotTimerState extends State<ParkingSlotTimer> {
  late Timer _timer;
  String elapsedTime = "--";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateElapsedTime();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateElapsedTime();
    });
  }

  void _updateElapsedTime() {
    if (widget.slotStatus.trim().toLowerCase() == 'occupied' && widget.timeTaken != null) {
      try {
        DateTime startTime = DateTime.parse(widget.timeTaken!.trim()).toLocal();
        Duration difference = DateTime.now().difference(startTime);
        setState(() {
          elapsedTime = _formatDuration(difference);
        });
      } catch (e) {
        print("Error parsing timeTaken: $e");
        setState(() {
          elapsedTime = "Invalid Date";
        });
      }
    } else {
      setState(() {
        elapsedTime = "--";
      });
    }
  }


  String _formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '${days}d ${hours.toString().padLeft(2, '0')}h';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
    } else {
      return '${seconds.toString().padLeft(2, '0')}s';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.slotStatus.trim().toLowerCase() == 'available' ? "Available" : "Occupied for: $elapsedTime",
      style: TextStyle(
        fontSize: screenSize * 0.0095,
        color: widget.slotStatus.trim().toLowerCase() == 'available' ? Colors.grey : Colors.white,
      ),
    );
  }
}

class CustomTimePicker extends StatefulWidget {
  final Function(TimeOfDay)? onTimeSelected;

  CustomTimePicker({this.onTimeSelected});

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  DateTime selectedDateTime = DateTime.now();

  // Define the times you want to disable
  final List<TimeOfDay> disabledTimes = [
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 18, minute: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime(2024, 1, 1, 8, 0), // Default to 8:00 AM
              use24hFormat: false,
              minuteInterval: 1, // Allows selecting every minute
              minimumDate: DateTime(2024, 1, 1, 8, 0),  // Starts at 8:00 AM
              maximumDate: DateTime(2024, 1, 1, 22, 0), // Ends at 10:00 PM
              onDateTimeChanged: (DateTime newDateTime) {
                if (newDateTime.hour >= 10 && newDateTime.hour < 13) {
                  return; // Ignore changes if within disabled range
                }
                setState(() {
                  selectedDateTime = newDateTime;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              TimeOfDay selectedTime = TimeOfDay(
                hour: selectedDateTime.hour,
                minute: selectedDateTime.minute,
              );

              // Check if the selected time is in the disabled list
              if (disabledTimes.any((time) =>
              time.hour == selectedTime.hour && time.minute == selectedTime.minute)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('This time is not available. Please choose another time.')),
                );
              } else {
                widget.onTimeSelected?.call(selectedTime);
                Navigator.pop(context);
              }
            },
            child: Text("Select Time"),
          ),
        ],
      ),
    );
  }
}

