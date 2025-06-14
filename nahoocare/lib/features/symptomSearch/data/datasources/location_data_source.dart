import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';

abstract class LocationDataSource {
  Future<LatLng> getCurrentLocation();
}

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('location_services_disabled'.tr());
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('location_permission_denied'.tr());
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('location_permission_denied_permanently'.tr());
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }
}
