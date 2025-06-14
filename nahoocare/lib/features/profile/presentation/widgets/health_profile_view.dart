import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/health_profile_bloc.dart';
import 'create_health_profile_form.dart';
import 'health_profile_details.dart';
import 'package:easy_localization/easy_localization.dart';

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
          // Don't show snackbar for auth errors as we're handling them in the UI
          if (state.message !=
              "server error : No authenticaion token availbale".tr()) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
      },
      builder: (context, state) {
        // Handle the actual display states
        if (state is HealthProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HealthProfileLoaded) {
          return HealthProfileDetails(profile: state.profile);
        } else if (state is HealthProfileEmpty) {
          return const CreateHealthProfileForm();
        } else if (state is HealthProfileError) {
          // Handle the no authentication token case
          if (state.message ==
              "Server error: No authentication token available".tr()) {
            return _buildLoginPrompt(context);
          }
          return Center(child: Text(state.message));
        }
        return Center(child: Text('Initializing...'.tr()));
      },
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You need to login first to access your health profile'.tr(),
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text('Login'.tr()),
          ),
        ],
      ),
    );
  }
}
