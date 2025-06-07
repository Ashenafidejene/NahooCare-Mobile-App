import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // Add this import

import '../blocs/healthcare_search_bloc.dart';
import '../widgets/healthcare_card.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_filter_chip.dart';

class HealthcareCentersPage extends StatelessWidget {
  const HealthcareCentersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    context.read<HealthcareBloc>().add(LoadHealthcareCenters());
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: SizedBox.shrink(),
      ),
      body: BlocConsumer<HealthcareBloc, HealthcareState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.isInitial || state.isLoading) {
            return _buildShimmerLoading(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HealthcareBloc>().add(LoadHealthcareCenters());
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'HealthCare Center Search',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchBarWidget(
                          initialQuery: state.searchQuery,
                          onSearch: (query) {
                            context.read<HealthcareBloc>().add(
                              SearchHealthcareCenters(query),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.sort,
                          color:
                              state.sortByDistance
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[700],
                        ),
                        onPressed: () {
                          context.read<HealthcareBloc>().add(
                            SortHealthcareCenters(
                              sortByDistance: !state.sortByDistance,
                            ),
                          );
                        },
                        tooltip: 'Sort by distance',
                      ),
                      const SizedBox(width: 4),
                      Badge(
                        isLabelVisible: state.selectedSpecialties.isNotEmpty,
                        child: IconButton(
                          icon: const Icon(Icons.filter_alt),
                          color: Theme.of(context).colorScheme.primary,
                          onPressed:
                              () => _showFilterBottomSheet(context, state),
                          tooltip: 'Filter options',
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.filteredCenters.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No centers found matching your criteria',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: state.filteredCenters.length,
                      itemBuilder: (context, index) {
                        final center = state.filteredCenters[index];
                        return HealthcareCard(healthcareCenter: center);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: BlocBuilder<HealthcareBloc, HealthcareState>(
        builder: (context, state) {
          if (state.searchQuery.isNotEmpty ||
              state.selectedSpecialties.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () {
                context.read<HealthcareBloc>().add(ResetHealthcareFilters());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(width: 200, height: 24, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: 5, // Number of shimmer items to show
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, HealthcareState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FilterBottomSheet(
          allSpecialties: state.allSpecialties,
          selectedSpecialties: state.selectedSpecialties,
          onApply: (selected) {
            context.read<HealthcareBloc>().add(
              FilterHealthcareCenters(selected),
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
