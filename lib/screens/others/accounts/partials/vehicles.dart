import 'package:eseepark/globals.dart';
import 'package:eseepark/screens/others/accounts/partials/widgets/add_vehicle.dart';
import 'package:flutter/material.dart';

class Vehicles extends StatefulWidget {
  const Vehicles({super.key});

  @override
  State<Vehicles> createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text('Vehicles',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500
          ),
        ),
        actions: [
          InkWell(
            onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return AddVehicle();
                }
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
              margin: EdgeInsets.only(right: screenWidth * 0.03),
              padding: EdgeInsets.all(5),
              child: Icon(Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        ],
      ),

    );
  }
}
