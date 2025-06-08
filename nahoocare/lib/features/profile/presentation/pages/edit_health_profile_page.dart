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
  bool _isSaving = false;
  @override
  void initState() {
    super.initState();
    _editedProfile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HealthProfileBloc, HealthProfileState>(
      listener: (context, state) {
        if (state is HealthProfileOperationSuccess) {
          Navigator.pop(context); // Only pop after successful update
        } else if (state is HealthProfileError) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.blueAccent,
            ),
            onPressed: _isSaving ? null : () => Navigator.pop(context),
          ),
          title: const Text('Edit Health Profile'),
          actions: [
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            else
              IconButton(icon: const Icon(Icons.save), onPressed: _saveProfile),
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
      ),
    );
  }

  void _saveProfile() {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    context.read<HealthProfileBloc>().add(
      UpdateHealthProfileEvent(_editedProfile),
    );
  }
}
