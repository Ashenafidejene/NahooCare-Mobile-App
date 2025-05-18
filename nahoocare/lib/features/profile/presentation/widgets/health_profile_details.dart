import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/health_profile.dart';
import '../bloc/health_profile_bloc.dart';
import '../pages/edit_health_profile_page.dart';

class HealthProfileDetails extends StatelessWidget {
  final HealthProfile profile;

  const HealthProfileDetails({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection('Blood Type', profile.bloodType),
          _buildListSection('Allergies', profile.allergies),
          _buildListSection('Chronic Conditions', profile.chronicConditions),
          _buildListSection('Medical History', profile.medicalHistory),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _navigateToEditProfile(context),
                child: const Text('Edit Profile'),
              ),
              ElevatedButton(
                onPressed: () => _confirmDeleteProfile(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (items.isEmpty)
            const Text('None', style: TextStyle(fontSize: 16))
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  items
                      .map(
                        (item) => Text(
                          '- $item',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                      .toList(),
            ),
        ],
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHealthProfilePage(profile: profile),
      ),
    );
  }

  void _confirmDeleteProfile(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Profile'),
            content: const Text(
              'Are you sure you want to delete your health profile?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<HealthProfileBloc>().add(
                    DeleteHealthProfileEvent(),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
