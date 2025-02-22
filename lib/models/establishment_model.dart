import 'dart:convert';
import 'package:eseepark/models/parking_rate_model.dart';
import 'package:eseepark/models/parking_section_model.dart';



class EstablishmentFields {
  static final String establishmentId = 'establishment_id';
  static final String name = 'name';
  static final String address = 'address';
  static final String contactNumber = 'contact_number';
  static final String availabilityStatus = 'availability_status';
  static final String establishmentType = 'establishment_type';
  static final String createdAt = 'created_at';
  static final String image = 'image';
  static final String coordinates = 'coordinates';
  static final String supportedVehicleTypes = 'supported_vehicle_types';
}

class Establishment {
  final String establishmentId;
  final String name;
  final String address;
  final String contactNumber;
  final String establishmentType;
  final String availabilityStatus;
  final DateTime createdAt;
  final String? image;
  final Map<String, dynamic> coordinates;

  final List<String>? supportedVehicleTypes;

  final double? distance;

  // Parking rate as an object
  final ParkingRate? parkingRate;

  final List<ParkingSection>? parkingSections;

  final int? parkingSlotsCount;

  Establishment({
    required this.establishmentId,
    required this.name,
    required this.address,
    required this.contactNumber,
    required this.availabilityStatus,
    required this.establishmentType,
    required this.createdAt,
    this.image,
    required this.coordinates,
    this.supportedVehicleTypes,
    this.distance,
    this.parkingRate,
    this.parkingSections,
    this.parkingSlotsCount
  });

  factory Establishment.fromMap(Map<String, dynamic> map) {
    return Establishment(
      establishmentId: map[EstablishmentFields.establishmentId] as String? ?? '',
      name: map[EstablishmentFields.name] as String? ?? 'Unknown',
      address: map[EstablishmentFields.address] as String? ?? 'No address',
      contactNumber: map[EstablishmentFields.contactNumber] as String? ?? 'No contact',
      availabilityStatus: map[EstablishmentFields.availabilityStatus] as String? ?? 'Unknown',
      establishmentType: map[EstablishmentFields.establishmentType] as String? ?? 'Unknown',
      createdAt: map[EstablishmentFields.createdAt] != null
          ? DateTime.parse(map[EstablishmentFields.createdAt] as String)
          : DateTime.now(),

      image: map[EstablishmentFields.image] as String?,

      // Ensure coordinates is correctly extracted
      coordinates: map[EstablishmentFields.coordinates] is String
          ? jsonDecode(map[EstablishmentFields.coordinates] as String) as Map<String, dynamic>
          : map[EstablishmentFields.coordinates] as Map<String, dynamic>? ?? {},

      supportedVehicleTypes: map[EstablishmentFields.supportedVehicleTypes] is List
          ? (map[EstablishmentFields.supportedVehicleTypes] as List).cast<String>()
          : null,

      // Ensure distance is correctly parsed as double
      distance: (map['distance'] is int)
          ? (map['distance'] as int).toDouble()
          : map['distance'] as double?,

      // Handle parking rate parsing safely
      parkingRate: map['parking_rate'] != null && map['parking_rate'] is Map<String, dynamic>
          ? ParkingRate.fromMap(map['parking_rate'] as Map<String, dynamic>)
          : null,

      // Handle parking sections parsing safely
      parkingSections: map['parking_sections'] is List
          ? (map['parking_sections'] as List).map((x) => ParkingSection.fromMap(x as Map<String, dynamic>)).toList()
          : null,

      parkingSlotsCount: map['parking_slots_count'] as int? ?? 0,
    );
  }

  // Convert an instance to a Map
  Map<String, dynamic> toMap() {
    return {
      EstablishmentFields.establishmentId: establishmentId,
      EstablishmentFields.name: name,
      EstablishmentFields.address: address ?? '',
      EstablishmentFields.contactNumber: contactNumber ,
      EstablishmentFields.availabilityStatus: availabilityStatus,
      EstablishmentFields.establishmentType: establishmentType,
      EstablishmentFields.createdAt: createdAt.toIso8601String(),
      EstablishmentFields.image: image,
      EstablishmentFields.coordinates: coordinates,
      EstablishmentFields.supportedVehicleTypes: supportedVehicleTypes,
      'distance': distance,
      'parking_rate': parkingRate?.toMap(), // Include parking rate
      'parking_sections': parkingSections?.map((x) => x.toMap()).toList(), // Include parking sections
      'parking_slots_count': parkingSlotsCount
    };
  }

  String toJson() => json.encode(toMap());

  factory Establishment.fromJson(String source) =>
      Establishment.fromMap(json.decode(source));
}
