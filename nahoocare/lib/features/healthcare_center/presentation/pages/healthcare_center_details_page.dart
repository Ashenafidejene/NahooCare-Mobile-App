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
    context.read<HealthcareCenterBloc>().add(
      LoadHealthcareCenterDetails(centerId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthcare Center Details'),
        centerTitle: true,
        elevation: 0,
      ),
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
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HealthcareCenterBloc>()
                  ..add(LoadHealthcareCenterDetails(centerId))
                  ..add(LoadCenterRatings(centerId));
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CenterDetailsCard(center: state.center),

                    const SizedBox(height: 24),
                    Text(
                      'Rate this Center',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: RatingForm(centerId: centerId),
                      ),
                    ),

                    const SizedBox(height: 28),
                    Text(
                      'Patient Reviews',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (state.ratings == null)
                      const Center(child: CircularProgressIndicator())
                    else
                      RatingsList(ratings: state.ratings!),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
