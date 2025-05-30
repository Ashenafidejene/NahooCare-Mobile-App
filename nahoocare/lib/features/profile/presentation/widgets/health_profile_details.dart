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
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context, Icons.water_drop, 'Blood Type', [
              profile.bloodType,
            ]),
            const Divider(height: 32),
            _buildProfileSection(
              context,
              Icons.warning_amber,
              'Allergies',
              profile.allergies,
            ),
            const Divider(height: 32),
            _buildProfileSection(
              context,
              Icons.favorite,
              'Chronic Conditions',
              profile.chronicConditions,
            ),
            const Divider(height: 32),
            _buildProfileSection(
              context,
              Icons.history,
              'Medical History',
              profile.medicalHistory,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToEditProfile(context),
                    icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                    label: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmDeleteProfile(context),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    IconData icon,
    String title,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty || (items.length == 1 && items.first.isEmpty))
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Text('None', style: Theme.of(context).textTheme.bodyMedium),
          )
        else
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  items
                      .map(
                        (item) => Chip(
                          label: Text(item),
                          backgroundColor: Colors.blueAccent.withOpacity(0.1),
                          labelStyle: const TextStyle(color: Colors.black87),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
      ],
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
