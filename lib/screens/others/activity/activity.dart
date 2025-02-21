import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Activity',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600
              ),
            ),
            ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 0
              ),
              child: Row(
                children: [
                  Icon(Icons.history,
                    color: Colors.white,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text('History',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
