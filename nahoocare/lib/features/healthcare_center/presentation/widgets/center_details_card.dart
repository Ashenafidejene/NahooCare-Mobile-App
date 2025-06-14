import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/healthcare_center.dart';

class CenterDetailsCard extends StatelessWidget {
  final HealthcareCenter center;

  const CenterDetailsCard({Key? key, required this.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            Text(
              center.name,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 18, color: colorScheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(center.address, style: textTheme.bodyMedium),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Rating
            if (center.averageRating != null)
              Row(
                children: [
                  RatingBarIndicator(
                    rating: center.averageRating!,
                    itemBuilder:
                        (_, __) => Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    center.averageRating!.toStringAsFixed(1),
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

            const Divider(height: 24),

            // Specialties
            if (center.specialists.isNotEmpty) ...[
              Text(
                'Specialties'.tr(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    center.specialists
                        .map(
                          (s) => Chip(
                            label: Text(s),
                            backgroundColor: colorScheme.primary.withOpacity(
                              0.1,
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Contact Info
            if (center.contactInfo != null &&
                center.contactInfo!.isNotEmpty) ...[
              Text(
                'Contact Info'.tr(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...center.contactInfo!.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.contact_phone,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${entry.key}: ',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Text(entry.value, style: textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Operating Hours
            if (center.availableTime.isNotEmpty) ...[
              Text(
                'Operating Hours'.tr(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...center.availableTime.map(
                (time) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(child: Text(time, style: textTheme.bodyMedium)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
