import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/health_profile_bloc.dart';
import '../widgets/health_profile_view.dart';

class HealthProfilePage extends StatelessWidget {
  const HealthProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HealthProfileBloc>().add(LoadHealthProfileEvent());
    return Scaffold(body: HealthProfileView());
  }
}
