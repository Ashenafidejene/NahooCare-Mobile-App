import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/search_response.dart';

import '../blocs/symptom_search_bloc.dart';
import '../widgets/first_aid_card.dart';
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
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
    _symptomsController.addListener(_updateState);
  }

  @override
  void dispose() {
    _symptomsController.removeListener(_updateState);
    _symptomsController.dispose();
    super.dispose();
  }

  void _updateState() => setState(() {});

  Future<void> _fetchUserLocation() async {
    setState(() {
      _isLocationLoading = true;
      _locationError = null;
    });

    try {
      context.read<SymptomSearchBloc>().add(GetUserLocation());
    } catch (e) {
      setState(() {
        _locationError = 'Failed to get location: ${e.toString()}';
        _isLocationLoading = false;
      });
    }
  }

  void _performSearch() {
    if (_currentLocation != null &&
        _symptomsController.text.trim().isNotEmpty) {
      context.read<SymptomSearchBloc>().add(
        PerformSearch(
          symptoms: _symptomsController.text.trim(),
          latitude: _currentLocation!.latitude,
          longitude: _currentLocation!.longitude,
        ),
      );
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
    return Scaffold(
      appBar: AppBar(title: const Text('Health Center Finder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Symptoms Input Field
            TextField(
              controller: _symptomsController,
              decoration: const InputDecoration(
                labelText: 'Enter your symptoms (comma separated)',
                border: OutlineInputBorder(),
                hintText: 'e.g. Fever, Headache',
              ),
            ),
            const SizedBox(height: 20),

            // Location Status Section
            _buildLocationStatus(),

            // Search Button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _currentLocation != null &&
                          _symptomsController.text.trim().isNotEmpty
                      ? _performSearch
                      : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Find Health Centers'),
            ),

            // Results Section
            const SizedBox(height: 20),
            Expanded(
              child: BlocConsumer<SymptomSearchBloc, SymptomSearchState>(
                listener: (context, state) {
                  if (state is LocationLoaded) {
                    setState(() {
                      _currentLocation = state.position;
                      _isLocationLoading = false;
                      _locationError = null;
                    });
                  } else if (state is LocationError) {
                    setState(() {
                      _locationError = state.message;
                      _isLocationLoading = false;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchError) {
                    return Center(
                      child: Text(
                        'Search error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is SearchLoaded) {
                    return Column(
                      children: [
                        if (state.response.firstAid != null)
                          FirstAidCard(firstAid: state.response.firstAid!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _navigateToMap(state.response),
                          child: const Text('View on Map'),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStatus() {
    if (_isLocationLoading) {
      return const Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 10),
          Text('Fetching location...'),
        ],
      );
    } else if (_locationError != null) {
      return Column(
        children: [
          Text(_locationError!, style: const TextStyle(color: Colors.red)),
          TextButton(onPressed: _fetchUserLocation, child: const Text('Retry')),
        ],
      );
    } else if (_currentLocation != null) {
      return Text(
        'Location: ${_currentLocation!.latitude.toStringAsFixed(4)}, '
        '${_currentLocation!.longitude.toStringAsFixed(4)}',
      );
    } else {
      return const Text('Location not available');
    }
  }
}
