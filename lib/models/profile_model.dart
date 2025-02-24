import 'dart:convert';

class ProfileFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String email = 'email';
  static const String favoriteEstablishments = 'favorite_establishments';
}

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final List<String> favoriteEstablishments;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.favoriteEstablishments
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map[ProfileFields.id] as String? ?? '',
      name: map[ProfileFields.name] as String? ?? '',
      email: map[ProfileFields.email] as String? ?? '',
      favoriteEstablishments: (map[ProfileFields.favoriteEstablishments] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ProfileFields.id: id,
      ProfileFields.name: name,
      ProfileFields.email: email,
      ProfileFields.favoriteEstablishments: favoriteEstablishments
    };
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) => ProfileModel.fromMap(json.decode(source));
}