class SearchFields {
  static const String searchText = 'search_text';
  static const String createdAt = 'created_at';
}

class SearchModel {
  final String searchText;
  final DateTime createdAt;

  const SearchModel({
    required this.searchText,
    required this.createdAt,
  });

  factory SearchModel.fromMap(Map<String, dynamic> json) => SearchModel(
    searchText: json[SearchFields.searchText] as String? ?? '',
    createdAt: DateTime.tryParse(json[SearchFields.createdAt] as String? ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toMap() {
    return {
      SearchFields.searchText: searchText,
      SearchFields.createdAt: createdAt.toIso8601String(),
    };
  }
}