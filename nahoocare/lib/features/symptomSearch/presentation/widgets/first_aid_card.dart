import 'package:flutter/material.dart';
import '../../domain/entities/first_aid.dart';

class FirstAidCard extends StatelessWidget {
  final FirstAid firstAid;

  const FirstAidCard({Key? key, required this.firstAid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(firstAid.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(firstAid.description),
            const SizedBox(height: 16),
            Text(
              'Potential Conditions:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              spacing: 8,
              children:
                  firstAid.potentialConditions
                      .map((condition) => Chip(label: Text(condition)))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
