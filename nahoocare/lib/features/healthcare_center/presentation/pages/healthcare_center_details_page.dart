import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nahoocare/features/healthcare_center/presentation/bloc/healthcare_center_bloc.dart';

import '../widgets/center_details_card.dart';
import '../widgets/rating_form.dart';
import '../widgets/ratings_list.dart';

class HealthcareCenterDetailsPage extends StatelessWidget {
  final String centerId;

  const HealthcareCenterDetailsPage({Key? key, required this.centerId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HealthcareCenterBloc>()
      ..add(LoadHealthcareCenterDetails(centerId))
      ..add(LoadCenterRatings(centerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Healthcare Center'), centerTitle: true),
      body: BlocConsumer<HealthcareCenterBloc, HealthcareCenterState>(
        listener: (context, state) {
          if (state is RatingSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Rating submitted successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HealthcareCenterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HealthcareCenterError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (state is HealthcareCenterLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CenterDetailsCard(center: state.center),
                  const SizedBox(height: 24),
                  const Text(
                    'Rate this Center',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Patient Reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (state.ratings == null)
                    const CircularProgressIndicator()
                  else if (state.ratings!.isEmpty)
                    const Text('No reviews yet. Be the first to review!')
                  else
                    RatingsList(ratings: state.ratings!),
                  const SizedBox(height: 8),
                  RatingForm(centerId: centerId),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
