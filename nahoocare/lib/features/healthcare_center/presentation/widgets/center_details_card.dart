import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../domain/entities/healthcare_center.dart';

class CenterDetailsCard extends StatelessWidget {
  final HealthcareCenter center;

  const CenterDetailsCard({Key? key, required this.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              center.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(
                  center.address,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (center.averageRating != null) ...[
              Row(
                children: [
                  RatingBarIndicator(
                    rating: center.averageRating!,
                    itemBuilder:
                        (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    center.averageRating!.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (center.specialists.isNotEmpty) ...[
              const Text(
                'Specialties:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    center.specialists
                        .map(
                          (specialty) => Chip(
                            label: Text(specialty),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 12),
            ],
            if (center.contactInfo != null &&
                center.contactInfo!.isNotEmpty) ...[
              const Text(
                'Contact Information:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...center.contactInfo!.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(entry.value),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (center.availableTime.isNotEmpty) ...[
              const Text(
                'Operating Hours:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...center.availableTime.map(
                (time) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(time),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
