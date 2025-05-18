class SearchByLocationParams {
  final double latitude;
  final double longitude;
  final int maxDistanceKm;

  SearchByLocationParams({
    required this.latitude,
    required this.longitude,
    this.maxDistanceKm = 10,
  });
}
