import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'provider_waiting_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ProviderRegistrationScreen extends StatefulWidget {
  const ProviderRegistrationScreen({super.key});

  @override
  State<ProviderRegistrationScreen> createState() =>
      _ProviderRegistrationScreenState();
}

class _ProviderRegistrationScreenState
    extends State<ProviderRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isRegistering = false;
  bool _isDetectingLocation = false;

  @override
  void initState() {
    super.initState();
    // Auto-detect location on screen load
    _detectLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    setState(() => _isDetectingLocation = true);

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode to get address
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // Format address: "Street, City" or "Locality, City"
        final address = [
          place.street,
          place.locality,
          place.subAdministrativeArea,
        ].where((e) => e != null && e.isNotEmpty).take(2).join(', ');

        setState(() {
          _locationController.text =
              address.isNotEmpty ? address : 'Current Location';
        });
      }
    } catch (e) {
      // Silently fail - user can enter location manually
      print('⚠️  Location detection failed: $e');
      if (mounted) {
        setState(() {
          _locationController.text = ''; // Leave empty for manual entry
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isDetectingLocation = false);
      }
    }
  }

  Future<void> _goOnline() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isRegistering = true);

    try {
      // Register with backend
      final response = await SessionService().createSession(
        providerName: _nameController.text.trim(),
        providerId: 'provider-${DateTime.now().millisecondsSinceEpoch}',
        location: _locationController.text.trim(),
      );

      if (mounted) {
        // Navigate to waiting screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderWaitingScreen(
              sessionId: response.sessionId,
              providerName: _nameController.text.trim(),
              location: _locationController.text.trim(),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to go online: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() => _isRegistering = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Provider Registration'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Go Online as Provider',
                style: TextStyle(
                  color: Color(0xFF00D4FF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your details to start receiving connection requests',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 32),

              // Provider Name Input
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Provider Name/Description',
                  labelStyle: const TextStyle(color: Color(0xFF00D4FF)),
                  hintText: 'e.g., Living Room Camera, Kitchen View',
                  hintStyle: const TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF00D4FF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF00D4FF), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a provider name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Location Input with auto-detect
              TextFormField(
                controller: _locationController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Location/Address',
                  labelStyle: const TextStyle(color: Color(0xFF00D4FF)),
                  hintText: _isDetectingLocation
                      ? 'Detecting location...'
                      : 'e.g., 123 Main St, Home Office',
                  hintStyle: const TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF00D4FF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF00D4FF), width: 2),
                  ),
                  suffixIcon: _isDetectingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF00D4FF)),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.my_location,
                              color: Color(0xFF00D4FF)),
                          onPressed: _detectLocation,
                          tooltip: 'Detect current location',
                        ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),

              const Spacer(),

              // Go Online Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isRegistering ? null : _goOnline,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isRegistering
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'Go Online',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
