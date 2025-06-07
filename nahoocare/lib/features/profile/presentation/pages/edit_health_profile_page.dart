import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/health_profile.dart';
import '../bloc/health_profile_bloc.dart';
import '../widgets/health_profile_form.dart';

class EditHealthProfilePage extends StatefulWidget {
  final HealthProfile profile;

  const EditHealthProfilePage({super.key, required this.profile});

  @override
  State<EditHealthProfilePage> createState() => _EditHealthProfilePageState();
}

class _EditHealthProfilePageState extends State<EditHealthProfilePage> {
  late HealthProfile _editedProfile;

  @override
  void initState() {
    super.initState();
    _editedProfile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.blueAccent,
          ), // Larger back icon
          onPressed: () => Navigator.maybePop(context), // Safer pop
        ),
        title: const Text('Edit Health Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              context.read<HealthProfileBloc>().add(
                UpdateHealthProfileEvent(_editedProfile),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: HealthProfileForm(
          profile: _editedProfile,
          onProfileChanged: (profile) {
            setState(() {
              _editedProfile = profile;
            });
          },
        ),
      ),
    );
  }
}
