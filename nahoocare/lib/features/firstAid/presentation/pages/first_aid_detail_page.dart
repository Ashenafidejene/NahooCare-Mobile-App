import 'package:flutter/material.dart';

import '../../domain/entities/first_aid_entity.dart';
import '../widgets/first_aid_image.dart';

class FirstAidDetailPage extends StatelessWidget {
  final FirstAidEntity guide;

  const FirstAidDetailPage({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guide.emergencyTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FirstAidImage(imageUrl: guide.image),
            const SizedBox(height: 20),
            Text(
              guide.emergencyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Chip(
              label: Text(guide.category),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            const SizedBox(height: 20),
            ...guide.instructions
                .map(
                  (step) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '• $step',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
