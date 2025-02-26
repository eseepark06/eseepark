import 'dart:convert';

class VehicleFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String userId = 'user_id';
  static const String licensePlate = 'license_plate';
  static const String type = 'type';
  static const String category = 'category';
  static const String image = 'image';
  static const String createdAt = 'created_at';
}

class Vehicle {
  final String id;
  final String name;
  final String userId;
  final String licensePlate;
  final String type;
  final String category;
  final String? image; // Nullable field
  final DateTime createdAt;

  Vehicle({
    required this.id,
    required this.name,
    required this.userId,
    required this.licensePlate,
    required this.type,
    required this.category,
    this.image,
    required this.createdAt,
  });

  // Factory method to create a Vehicle from a Map
  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map[VehicleFields.id] as String? ?? '',
      name: map[VehicleFields.name] as String? ?? '',
      userId: map[VehicleFields.userId] as String? ?? '',
      licensePlate: map[VehicleFields.licensePlate] as String? ?? '',
      type: map[VehicleFields.type] as String? ?? '',
      category: map[VehicleFields.category] as String? ?? '',
      image: map[VehicleFields.image] as String?, // Nullable
      createdAt: map[VehicleFields.createdAt] != null
          ? DateTime.tryParse(map[VehicleFields.createdAt] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // Convert an instance to a Map
  Map<String, dynamic> toMap() {
    return {
      VehicleFields.id: id,
      VehicleFields.name: name,
      VehicleFields.userId: userId,
      VehicleFields.licensePlate: licensePlate,
      VehicleFields.type: type,
      VehicleFields.category: category,
      VehicleFields.image: image,
      VehicleFields.createdAt: createdAt.toIso8601String(),
    };
  }

  // Convert an instance to JSON
  String toJson() => json.encode(toMap());

  // Create an instance from JSON
  factory Vehicle.fromJson(String source) => Vehicle.fromMap(json.decode(source));
}
