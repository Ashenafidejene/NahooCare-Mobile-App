import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final String ratingId;
  final String userId;
  final String centerId;
  final int ratingValue;
  final String comment;
  final DateTime ratedAt;

  const Rating({
    required this.ratingId,
    required this.userId,
    required this.centerId,
    required this.ratingValue,
    required this.comment,
    required this.ratedAt,
  });

  @override
  List<Object> get props => [
    ratingId,
    userId,
    centerId,
    ratingValue,
    comment,
    ratedAt,
  ];
}
