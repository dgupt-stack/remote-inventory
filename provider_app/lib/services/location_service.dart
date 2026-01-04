import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check and request location permissions
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print('Error getting position: $e');
      return null;
    }
  }

  // Convert coordinates to address
  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return null;
      }

      final place = placemarks.first;

      // Format address
      final parts = [
        place.street,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((part) => part != null && part.isNotEmpty);

      return parts.join(', ');
    } catch (e) {
      print('Error geocoding: $e');
      return null;
    }
  }

  // Get current address (convenience method)
  Future<String?> getCurrentAddress() async {
    final position = await getCurrentPosition();
    if (position == null) {
      return null;
    }

    return await getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );
  }

  // Get short address (street + city only)
  Future<String?> getShortAddress() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) {
        return null;
      }

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return null;
      }

      final place = placemarks.first;
      final parts = [
        place.street,
        place.locality,
      ].where((part) => part != null && part.isNotEmpty);

      return parts.join(', ');
    } catch (e) {
      print('Error getting short address: $e');
      return null;
    }
  }
}
