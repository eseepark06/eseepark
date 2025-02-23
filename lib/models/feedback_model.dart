import 'dart:convert';

class FeedbackFields {
  static const String feedbackId = 'feedback_id';
  static const String userId = 'user_id';
  static const String rating = 'rating';
  static const String comment = 'comment';
  static const String createdAt = 'created_at';
}

class FeedbackModel {
  final String feedbackId;
  final String userId;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  FeedbackModel({
    required this.feedbackId,
    required this.userId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  // Convert a Map into a FeedbackModel instance
  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      feedbackId: map[FeedbackFields.feedbackId] as String? ?? '',
      userId: map[FeedbackFields.userId] as String? ?? '',
      rating: map[FeedbackFields.rating] as double? ?? 0.0,
      comment: map[FeedbackFields.comment] as String?,
      createdAt: map[FeedbackFields.createdAt] != null
          ? DateTime.tryParse(map[FeedbackFields.createdAt] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // Convert an instance to a Map
  Map<String, dynamic> toMap() {
    return {
      FeedbackFields.feedbackId: feedbackId,
      FeedbackFields.userId: userId,
      FeedbackFields.rating: rating,
      FeedbackFields.comment: comment,
      FeedbackFields.createdAt: createdAt.toIso8601String(),
    };
  }

  // Convert an instance to JSON
  String toJson() => json.encode(toMap());

  // Create an instance from JSON
  factory FeedbackModel.fromJson(String source) =>
      FeedbackModel.fromMap(json.decode(source));
}
