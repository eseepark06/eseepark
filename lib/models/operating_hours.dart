import 'dart:convert';

class OperatingHoursFields {
  static const String day = 'day';
  static const String open = 'open';
  static const String close = 'close';
}

class OperatingHours {
  final String day;
  final String open;
  final String close;

  const OperatingHours({
    required this.day,
    required this.open,
    required this.close
  });

  factory OperatingHours.fromMap(Map<String, dynamic> map) => OperatingHours(
    day: map[OperatingHoursFields.day] as String? ?? '',
    open: map[OperatingHoursFields.open] as String? ?? '',
    close: map[OperatingHoursFields.close] as String? ?? '',
  );

  Map<String, dynamic> toMap() => {
    OperatingHoursFields.day: day,
    OperatingHoursFields.open: open,
    OperatingHoursFields.close: close
  };

  String toJson() => json.encode(toMap());

  factory OperatingHours.fromJson(String source) => OperatingHours.fromMap(json.decode(source));
}