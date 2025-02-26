import 'package:eseepark/controllers/vehicles/vehicle_controller.dart';
import 'package:eseepark/globals.dart';
import 'package:eseepark/screens/others/accounts/partials/widgets/add_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/vehicle_model.dart';

class Vehicles extends StatefulWidget {
  const Vehicles({super.key});

  @override
  State<Vehicles> createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  final controller = VehicleController();
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
            onTap: () async {
              final vehicles = await controller.getUserVehicles(); // Fetch vehicles first

              final result = await showModalBottomSheet(
                context: Get.context as BuildContext,
                isScrollControlled: true,
                builder: (context) {
                  return AddVehicle(userVehicles: vehicles);
                },
              );

              if (result == true) {
                setState(() {}); // Refresh the UI
              }
            },
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
      body: FutureBuilder(
        future: controller.getUserVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final vehicles = snapshot.data as List<Vehicle>;

          if (vehicles.isEmpty) {
            return Center(
              child: Text('No vehicles found',
                style: TextStyle(
                  fontSize: screenWidth * 0.06
                ),
              ),
            );
          }

          return Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];

                      return Container(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                          top: screenHeight * 0.03,
                          bottom: screenHeight * 0.01,
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text(vehicle.name),
                            subtitle: Text(vehicle.licensePlate),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
