import 'package:flutter/material.dart';
import '../../domain/entities/first_aid.dart';
import 'package:easy_localization/easy_localization.dart';

class FirstAidCard extends StatelessWidget {
  final FirstAid firstAid;

  const FirstAidCard({Key? key, required this.firstAid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                const Icon(Icons.health_and_safety, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    firstAid.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              firstAid.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 20),

            // Conditions section
            Text(
              'potential_conditions'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 8),

            // Condition chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: firstAid.potentialConditions.map((condition) {
                return Chip(
                  label: Text(condition),
                  backgroundColor: Colors.blue[50],
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
