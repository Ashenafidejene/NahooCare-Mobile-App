import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/first_aid_entity.dart';
import '../blocs/first_aid_bloc.dart';
import '../widgets/first_aid_card.dart';
import '../widgets/search_filter_bar.dart';
import 'first_aid_detail_page.dart';

class FirstAidListPage extends StatelessWidget {
  const FirstAidListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<FirstAidBloc>().add(LoadFirstAidGuides());
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<FirstAidBloc, FirstAidState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🩺 First Aid Guides',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is FirstAidLoaded)
                  SearchFilterBar(
                    categories: _getUniqueCategories(state.allGuides),
                    onSearch:
                        (query) => context.read<FirstAidBloc>().add(
                          SearchFirstAid(query),
                        ),
                    onFilter:
                        (category) => context.read<FirstAidBloc>().add(
                          FilterFirstAid(category),
                        ),
                  ),
                Expanded(child: _buildBodyContent(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, FirstAidState state) {
    if (state is FirstAidLoading) {
      return _buildShimmerLoading();
    }

    if (state is FirstAidError) {
      return Center(child: Text(state.message));
    }

    if (state is FirstAidLoaded) {
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: state.displayedGuides.length,
        itemBuilder:
            (context, index) => FirstAidCard(
              guide: state.displayedGuides[index],
              onTap:
                  () =>
                      _navigateToDetail(context, state.displayedGuides[index]),
            ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: 6, // Number of shimmer placeholders
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(width: 150, height: 16, color: Colors.white),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Container(width: 100, height: 16, color: Colors.white),
              ],
            ),
          );
        },
      ),
    );
  }

  List<String> _getUniqueCategories(List<FirstAidEntity> guides) {
    return ['All', ...guides.map((e) => e.category).toSet().toList()];
  }

  void _navigateToDetail(BuildContext context, FirstAidEntity guide) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirstAidDetailPage(guide: guide)),
    );
  }
}
