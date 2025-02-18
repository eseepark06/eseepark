import 'dart:convert';

class ParkingSlotFields {
  static const String id = 'slot_id';
  static const String sectionId = 'section_id';
  static const String slotNumber = 'slot_number';
  static const String slotStatus = 'status';
  static const String isEvCharging = 'is_ev_charging';
  static const String isPwdFriendly = 'is_pwd_friendly';
  static const String isCovered = 'is_covered';
  static const String createdAt = 'created_at';
  static const String timeTaken = 'time_taken';
}

class ParkingSlot {
  final String id;
  final String sectionId;
  final int slotNumber;
  final String slotStatus;
  final bool isEvCharging;
  final bool isPwdFriendly;
  final bool isCovered;
  final DateTime createdAt;
  final DateTime? timeTaken;

  ParkingSlot({
    required this.id,
    required this.sectionId,
    required this.slotNumber,
    required this.slotStatus,
    required this.isEvCharging,
    required this.isPwdFriendly,
    required this.isCovered,
    required this.createdAt,
    this.timeTaken
  });

  factory ParkingSlot.fromMap(Map<String, dynamic> map) {
    return ParkingSlot(
      id: map[ParkingSlotFields.id] as String? ?? '',
      sectionId: map[ParkingSlotFields.sectionId] as String? ?? '',
      slotNumber: (map[ParkingSlotFields.slotNumber] is int)
          ? map[ParkingSlotFields.slotNumber] as int
          : int.tryParse(map[ParkingSlotFields.slotNumber]?.toString() ?? '0') ?? 0,
      slotStatus: map[ParkingSlotFields.slotStatus] as String? ?? '',
      isEvCharging: (map[ParkingSlotFields.isEvCharging] is bool)
          ? map[ParkingSlotFields.isEvCharging] as bool
          : map[ParkingSlotFields.isEvCharging].toString().toLowerCase() == 'true',
      isPwdFriendly: (map[ParkingSlotFields.isPwdFriendly] is bool)
          ? map[ParkingSlotFields.isPwdFriendly] as bool
          : map[ParkingSlotFields.isPwdFriendly].toString().toLowerCase() == 'true',
      isCovered: (map[ParkingSlotFields.isCovered] is bool)
          ? map[ParkingSlotFields.isCovered] as bool
          : map[ParkingSlotFields.isCovered].toString().toLowerCase() == 'true',
      createdAt: DateTime.tryParse(map[ParkingSlotFields.createdAt] as String? ?? '') ?? DateTime.now(),
      timeTaken: DateTime.tryParse(map['time_taken'] as String? ?? ''),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      ParkingSlotFields.id: id,
      ParkingSlotFields.sectionId: sectionId,
      ParkingSlotFields.slotNumber: slotNumber,
      ParkingSlotFields.slotStatus: slotStatus,
      ParkingSlotFields.isEvCharging: isEvCharging,
      ParkingSlotFields.isPwdFriendly: isPwdFriendly,
      ParkingSlotFields.isCovered: isCovered,
      ParkingSlotFields.createdAt: createdAt.toIso8601String(),
      ParkingSlotFields.timeTaken: timeTaken?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());
}
