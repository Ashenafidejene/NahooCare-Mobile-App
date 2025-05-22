import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/first_aid_entity.dart';
import '../blocs/first_aid_bloc.dart';
import '../widgets/first_aid_card.dart';
import '../widgets/search_filter_bar.dart';
import 'first_aid_detail_page.dart';

class FirstAidListPage extends StatelessWidget {
  const FirstAidListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Add this to trigger initial load

    context.read<FirstAidBloc>().add(LoadFirstAidGuides());
    return Scaffold(
      appBar: AppBar(title: const Text('First Aid Guides')),
      body: BlocBuilder<FirstAidBloc, FirstAidState>(
        builder: (context, state) {
          return _buildBodyContent(context, state);
        },
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, FirstAidState state) {
    if (state is FirstAidLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FirstAidError) {
      return Center(child: Text(state.message));
    }

    if (state is FirstAidLoaded) {
      return Column(
        children: [
          SearchFilterBar(
            categories: _getUniqueCategories(state.allGuides),
            onSearch:
                (query) =>
                    context.read<FirstAidBloc>().add(SearchFirstAid(query)),
            onFilter:
                (category) =>
                    context.read<FirstAidBloc>().add(FilterFirstAid(category)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.displayedGuides.length,
              itemBuilder:
                  (context, index) => FirstAidCard(
                    guide: state.displayedGuides[index],
                    onTap:
                        () => _navigateToDetail(
                          context,
                          state.displayedGuides[index],
                        ),
                  ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
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
