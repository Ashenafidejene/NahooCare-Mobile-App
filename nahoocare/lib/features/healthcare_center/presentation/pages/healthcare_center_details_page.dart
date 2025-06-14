import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nahoocare/features/healthcare_center/presentation/bloc/healthcare_center_bloc.dart';
import '../widgets/center_details_card.dart';
import '../widgets/rating_form.dart';
import '../widgets/ratings_list.dart';
import 'package:easy_localization/easy_localization.dart';

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
        title: Text('Healthcare Center Details'.tr()),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.blueAccent,
          ), // Larger back icon
          onPressed: () => Navigator.maybePop(context), // Safer pop
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<HealthcareCenterBloc, HealthcareCenterState>(
        listener: (context, state) {
          if (state is RatingSubmissionSuccess) {
            // Reload both center details and ratings
            context.read<HealthcareCenterBloc>()
              ..add(LoadHealthcareCenterDetails(centerId))
              ..add(LoadCenterRatings(centerId));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Rating submitted successfully!'.tr()),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HealthcareCenterLoading) {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Colors.blueAccent,
                size: 70,
              ),
            );
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
                      'Rate this Center'.tr(),
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
                      'Patient Reviews'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (state.ratings == null)
                      Center(
                        child: LoadingAnimationWidget.halfTriangleDot(
                          color: Colors.blueAccent,
                          size: 70,
                        ),
                      )
                    else
                      RatingsList(ratings: state.ratings!),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: LoadingAnimationWidget.halfTriangleDot(
              color: Colors.blueAccent,
              size: 70,
            ),
          );
        },
      ),
    );
  }
}
