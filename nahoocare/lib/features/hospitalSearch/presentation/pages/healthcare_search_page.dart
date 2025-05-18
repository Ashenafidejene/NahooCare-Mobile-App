import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../healthcare_center/presentation/pages/healthcare_center_details_page.dart';
import '../blocs/healthcare_search_bloc.dart';
import '../blocs/healthcare_search_event.dart';
import '../blocs/healthcare_search_state.dart';
import '../widgets/healthcare_card.dart';
import '../widgets/search_filter_chip.dart';
import '../widgets/distance_indicator.dart';

class HealthcareSearchPage extends StatefulWidget {
  const HealthcareSearchPage({Key? key}) : super(key: key);

  @override
  State<HealthcareSearchPage> createState() => _HealthcareSearchPageState();
}

class _HealthcareSearchPageState extends State<HealthcareSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  String _searchType = 'name'; // 'name', 'specialty', 'location'
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    // Get current location from your existing location service
    // _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Healthcare Centers')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText:
                        _searchType == 'name'
                            ? 'Search by name...'
                            : 'Enter specialties separated by comma',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SearchFilterChip(
                      label: 'Name',
                      selected: _searchType == 'name',
                      onSelected: () => setState(() => _searchType = 'name'),
                    ),
                    const SizedBox(width: 8),
                    SearchFilterChip(
                      label: 'Specialty',
                      selected: _searchType == 'specialty',
                      onSelected:
                          () => setState(() => _searchType = 'specialty'),
                    ),
                    const SizedBox(width: 8),
                    SearchFilterChip(
                      label: 'Near Me',
                      selected: _searchType == 'location',
                      onSelected: () {
                        if (_currentLocation != null) {
                          setState(() => _searchType = 'location');
                          _performSearch();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Location not available'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                if (_searchType == 'location' && _currentLocation != null)
                  DistanceIndicator(
                    currentDistance: 10,
                    onChanged: (value) {
                      // Handle distance slider change
                      _performSearch();
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<HealthcareSearchBloc, HealthcareSearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchError) {
                  return Center(child: Text(state.message));
                } else if (state is SearchLoaded) {
                  return ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final center =
                          state.results[index]; // renamed for clarity

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => HealthcareCenterDetailsPage(
                                    centerId: center.centerId,
                                  ),
                            ),
                          );
                        },
                        child: HealthcareCard(
                          healthcare: center,
                          currentLocation: _currentLocation,
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('Start your search'));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();

    if (_searchType == 'name' && query.isNotEmpty) {
      context.read<HealthcareSearchBloc>().add(SearchByName(query));
    } else if (_searchType == 'specialty' && query.isNotEmpty) {
      final specialties = query.split(',').map((e) => e.trim()).toList();
      context.read<HealthcareSearchBloc>().add(SearchBySpecialty(specialties));
    } else if (_searchType == 'location' && _currentLocation != null) {
      context.read<HealthcareSearchBloc>().add(
        SearchByLocation(
          latitude: _currentLocation!.latitude,
          longitude: _currentLocation!.longitude,
          maxDistanceKm: 10, // Default or from slider
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }
}
