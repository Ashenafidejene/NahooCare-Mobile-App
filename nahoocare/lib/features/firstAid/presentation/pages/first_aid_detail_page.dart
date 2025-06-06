import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/first_aid_entity.dart';
import '../widgets/first_aid_image.dart';

class FirstAidDetailPage extends StatelessWidget {
  final FirstAidEntity guide;

  const FirstAidDetailPage({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(guide.emergencyTitle),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.blueAccent,
          ), // Larger back icon
          onPressed: () => Navigator.maybePop(context), // Safer pop
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FirstAidImage(
                    imageUrl: guide.image,
                    width: double.infinity,
                    height: null, // Let AspectRatio handle height
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Chip(
                    label: Text(
                      guide.category,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.health_and_safety,
                    color: theme.colorScheme.primary,
                    semanticLabel: 'first_aid_icon'.tr(), // Accessible label
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                guide.emergencyTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        guide.instructions.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final step = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$index.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    step,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
