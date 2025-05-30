import 'package:flutter/material.dart';
import '../../../healthcare_center/presentation/pages/healthcare_center_details_page.dart';
import '../../domain/entities/healthcare_entity.dart';

class HealthcareCard extends StatelessWidget {
  final HealthcareEntity healthcareCenter;

  const HealthcareCard({super.key, required this.healthcareCenter});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => HealthcareCenterDetailsPage(
                    centerId: healthcareCenter.centerId,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      healthcareCenter.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (healthcareCenter.specialties.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: -8,
                  children:
                      healthcareCenter.specialties
                          .map(
                            (specialty) => Chip(
                              label: Text(specialty),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${healthcareCenter.latitude.toStringAsFixed(4)}, ${healthcareCenter.longitude.toStringAsFixed(4)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
