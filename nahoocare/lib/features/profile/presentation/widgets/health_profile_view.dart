import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/health_profile_bloc.dart';
import 'create_health_profile_form.dart';
import 'health_profile_details.dart';

class HealthProfileView extends StatelessWidget {
  const HealthProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HealthProfileBloc, HealthProfileState>(
      listener: (context, state) {
        if (state is HealthProfileOperationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is HealthProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is HealthProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HealthProfileLoaded) {
          return HealthProfileDetails(profile: state.profile);
        } else if (state is HealthProfileEmpty) {
          return const CreateHealthProfileForm();
        } else if (state is HealthProfileError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Initializing...'));
      },
    );
  }
}
