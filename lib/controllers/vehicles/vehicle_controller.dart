import 'dart:io';

import 'package:eseepark/main.dart';
import 'package:eseepark/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

class VehicleController {

  static final VehicleController _vehicleController = VehicleController._internal();

  factory VehicleController() {
    return _vehicleController;
  }

  VehicleController._internal();

  // Methods
  Future<List<Vehicle>> getUserVehicles() async {
    try {
      if (supabase.auth.currentUser == null) throw Exception("User not logged in");

      final response = await supabase
          .from('vehicles')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);

      return response.map((data) => Vehicle.fromMap(data)).toList();
    } catch (e) {
      debugPrint("Error fetching user vehicles: $e");
      return [];
    }
  }

  Future<bool> addVehicle({
    required String vehicleType,
    required String vehicleCategory,
    required String vehicleLicensePlate,
    required String vehicleName,
    File? vehicleImage,
  }) async {
    try {
      if (supabase.auth.currentUser == null) throw Exception("User not logged in");

      String? imageUrl;

      // Upload image if provided
      if (vehicleImage != null) {
        final String userId = supabase.auth.currentUser!.id;
        final String fileExtension = lookupMimeType(vehicleImage.path)!.split('/').last;
        final String fileName = '$userId-${const Uuid().v4()}.$fileExtension';

        final storageResponse = await supabase.storage
            .from('vehicle-images')
            .upload(fileName, vehicleImage, fileOptions: FileOptions(
             upsert: false,
        ));

        if (storageResponse.isNotEmpty) {
          print("Upload image message: ${storageResponse}");
        }

        imageUrl = supabase.storage.from('vehicle-images').getPublicUrl(fileName);
      }

      // Insert into Supabase database
      final response = await supabase.from('vehicles').insert({
        'user_id': supabase.auth.currentUser!.id,
        'type': vehicleType,
        'category': vehicleCategory,
        'license_plate': vehicleLicensePlate,
        'name': vehicleName,
        'image': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true; // Success
    } catch (e) {
      debugPrint("Error adding vehicle: $e");
      return false; // Failure
    }
  }
}