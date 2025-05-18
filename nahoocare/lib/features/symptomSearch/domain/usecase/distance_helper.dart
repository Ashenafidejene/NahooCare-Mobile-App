import 'package:latlong2/latlong.dart';

class DistanceHelper {
  static double calculate(LatLng point1, LatLng point2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, point1, point2);
  }
}
