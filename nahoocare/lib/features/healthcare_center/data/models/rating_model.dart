// lib/features/healthcare_center/data/models/rating_model.dart
import '../../domain/entities/rating.dart';

class RatingModel extends Rating {
  const RatingModel({
    required String ratingId,
    required String userId,
    required String centerId,
    required int ratingValue,
    required String comment,
    required DateTime ratedAt,
  }) : super(
         ratingId: ratingId,
         userId: userId,
         centerId: centerId,
         ratingValue: ratingValue,
         comment: comment,
         ratedAt: ratedAt,
       );

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      ratingId: json['rating_id'],
      userId: json['user_id'],
      centerId: json['center_id'],
      ratingValue: json['rating_value'],
      comment: json['comment'],
      ratedAt: DateTime.parse(json['rated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': ratingId,
    'user_id': userId,
    'center_id': centerId,
    'rating_value': ratingValue,
    'comment': comment,
    'rated_at': ratedAt.toIso8601String(),
  };
}
