import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Add this import

import '../../domain/entities/search_response.dart';
import '../blocs/symptom_search_bloc.dart';
import '../widgets/first_aid_card.dart';
import '../widgets/list_healthcare_center.dart';
import 'map_screen.dart';

class SymptomInputPage extends StatefulWidget {
  const SymptomInputPage({Key? key}) : super(key: key);

  @override
  State<SymptomInputPage> createState() => _SymptomInputPageState();
}

class _SymptomInputPageState extends State<SymptomInputPage> {
  final TextEditingController _symptomsController = TextEditingController();
  LatLng? _currentLocation;
  bool _isLocationLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
    _symptomsController.addListener(() {
      setState(() {}); // Refresh on text input
    });
  }

  Future<void> _fetchUserLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      context.read<SymptomSearchBloc>().add(GetUserLocation());
    } catch (_) {
      setState(() {
        _isLocationLoading = false;
      });
    }
  }

  void _performSearch() {
    final symptoms = _symptomsController.text.trim();

    if (symptoms.isEmpty) return;

    if (_currentLocation != null) {
      context.read<SymptomSearchBloc>().add(
        PerformSearch(
          symptoms: symptoms,
          latitude: _currentLocation!.latitude,
          longitude: _currentLocation!.longitude,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fetching your location. Please try again.'),
        ),
      );
      _fetchUserLocation();
    }
  }

  void _navigateToMap(SearchResponse response) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MapScreen(
              centers: response.centers,
              userLocation: response.userLocation,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SymptomSearchBloc, SymptomSearchState>(
          listener: (context, state) {
            if (state is LocationLoaded) {
              setState(() {
                _currentLocation = state.position;
                _isLocationLoading = false;
              });
            } else if (state is LocationError) {
              setState(() {
                _isLocationLoading = false;
              });
            }
          },
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate.fixed([
                          const SizedBox(height: 10),
                          Text(
                            '🩺 Symptom Checker',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Describe how you feel and we\'ll guide you to care.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),

                          TextField(
                            controller: _symptomsController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: 'Your symptoms',
                              hintText: 'e.g. headache, sore throat...',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed:
                                  (_symptomsController.text.trim().isNotEmpty &&
                                          _currentLocation != null)
                                      ? _performSearch
                                      : null,
                              icon:
                                  _isLocationLoading
                                      ? LoadingAnimationWidget.stretchedDots(
                                        color: Colors.white,
                                        size: 20,
                                      )
                                      : const Icon(Icons.search),
                              label:
                                  _isLocationLoading
                                      ? const Text('Getting Location...')
                                      : const Text('Search for Help'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                disabledBackgroundColor: Colors.blueAccent
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (state is SearchLoading)
                            Center(
                              child: LoadingAnimationWidget.halfTriangleDot(
                                color: Colors.blueAccent,
                                size: 50,
                              ),
                            ),

                          if (state is SearchError)
                            Center(
                              child: Text(
                                '⚠️ ${state.message}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),

                          if (state is SearchLoaded) ...[
                            if (state.response.firstAid != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: FirstAidCard(
                                  firstAid: state.response.firstAid!,
                                ),
                              ),
                            const SizedBox(height: 12),
                            HealthCenterList(
                              centers: state.response.centers,
                              userLocation: state.response.userLocation,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.map_outlined),
                                label: const Text('View Centers on Map'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () => _navigateToMap(state.response),
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }
}
