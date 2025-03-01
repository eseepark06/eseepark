import 'dart:async';

import 'package:eseepark/models/reservation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../globals.dart';
import '../main.dart';

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

class TestPicker extends StatefulWidget {
  final String slotId;

  const TestPicker({super.key, required this.slotId});

  @override
  _TestPickerState createState() => _TestPickerState();
}

class _TestPickerState extends State<TestPicker> {
  final List<DateTime> timeSlots = List.generate(
    48,
        (index) => DateTime(2025, 1, 1, index ~/ 4, (index % 4) * 15),
  );

  final FixedExtentScrollController _timeController = FixedExtentScrollController();
  final FixedExtentScrollController _meridiemController = FixedExtentScrollController();
  Stream<List<Map<String, dynamic>>>? slotReservationStream;

  @override
  void initState() {
    super.initState();
    _setupParkingStream();
  }

  @override
  void dispose() {
    _timeController.dispose();
    _meridiemController.dispose();
    super.dispose();
  }

  void _setupParkingStream() {
    slotReservationStream = Supabase.instance.client
        .from('reservations')
        .stream(primaryKey: ['slot_id'])
        .eq('slot_id', widget.slotId)
        .map((reservations) => reservations.isNotEmpty
        ? [{'reservations': reservations.map((e) => Reservation.fromMap(e)).toList()}]
        : []);

    setState(() {});
  }

  String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: slotReservationStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

        final reservations = snapshot.data?.isNotEmpty == true
            ? snapshot.data!.first['reservations'] as List<Reservation>
            : [];

        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeWheel(),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeWheel() {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListWheelScrollView.useDelegate(
            controller: _timeController,
            itemExtent: MediaQuery.of(context).size.height * 0.045,
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final time = timeSlots[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    _timeController.animateToItem(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Center(
                    child: Text(
                      formatTime(time),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              },
              childCount: timeSlots.length,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        )
      ],
    );
  }
}


