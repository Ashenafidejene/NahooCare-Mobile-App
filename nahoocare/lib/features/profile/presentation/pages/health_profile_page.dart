import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/health_profile_bloc.dart';
import '../widgets/health_profile_view.dart';

class HealthProfilePage extends StatelessWidget {
  const HealthProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HealthProfileBloc>().add(LoadHealthProfileEvent());
            },
          ),
        ],
      ),
      body: HealthProfileView(),
    );
  }
}
