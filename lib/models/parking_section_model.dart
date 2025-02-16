import 'dart:convert';
import 'package:eseepark/models/parking_slot_model.dart';

class ParkingSectionFields {
  static const String id = 'section_id';
  static const String establishmentId = 'establishment_id';
  static const String name = 'name';
  static const String floorLevel = 'floor_level';
  static const String createdAt = 'created_at';
}

class ParkingSection {
  final String id;
  final String establishmentId;
  final String name;
  final int? floorLevel;
  final DateTime createdAt;
  final List<ParkingSlot>? parkingSlots;

  ParkingSection({
    required this.id,
    required this.establishmentId,
    required this.name,
    this.floorLevel,
    required this.createdAt,
    this.parkingSlots,
  });

  ParkingSection copyWith({
    String? id,
    String? establishmentId,
    String? name,
    int? floorLevel,
    DateTime? createdAt,
    List<ParkingSlot>? parkingSlots,
  }) {
    return ParkingSection(
      id: id ?? this.id,
      establishmentId: establishmentId ?? this.establishmentId,
      name: name ?? this.name,
      floorLevel: floorLevel ?? this.floorLevel,
      createdAt: createdAt ?? this.createdAt,
      parkingSlots: parkingSlots ?? this.parkingSlots,
    );
  }

  factory ParkingSection.fromMap(Map<String, dynamic> map) {
    return ParkingSection(
      id: map[ParkingSectionFields.id] as String? ?? '', // Ensures a default value
      establishmentId: map[ParkingSectionFields.establishmentId] as String? ?? '',
      name: map[ParkingSectionFields.name] as String? ?? '',
      floorLevel: (map[ParkingSectionFields.floorLevel] as num?)?.toInt(), // Ensures it's an int
      createdAt: DateTime.tryParse(map[ParkingSectionFields.createdAt] as String? ?? '') ?? DateTime.now(),
      parkingSlots: map['parking_slots'] is List
          ? (map['parking_slots'] as List).map((x) => ParkingSlot.fromMap(x as Map<String, dynamic>)).toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ParkingSectionFields.id: id,
      ParkingSectionFields.establishmentId: establishmentId,
      ParkingSectionFields.name: name,
      ParkingSectionFields.floorLevel: floorLevel,
      ParkingSectionFields.createdAt: createdAt.toIso8601String(),
      'parking_slots': parkingSlots?.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
