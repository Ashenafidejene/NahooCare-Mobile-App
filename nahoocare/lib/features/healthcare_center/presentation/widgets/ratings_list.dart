import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/rating.dart';
import 'package:easy_localization/easy_localization.dart';

class RatingsList extends StatelessWidget {
  final List<Rating> ratings;

  const RatingsList({Key? key, required this.ratings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'No reviews yet.\nBe the first to review!'.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: ratings.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final rating = ratings[index];
        final initials = _getInitials("someBody ".tr());

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Row(
              children: [
                RatingBarIndicator(
                  rating: rating.ratingValue.toDouble(),
                  itemBuilder:
                      (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  rating.ratingValue.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (rating.comment.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    rating.comment,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  _formatDate(rating.ratedAt),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return parts.take(2).map((e) => e[0].toUpperCase()).join();
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
}
