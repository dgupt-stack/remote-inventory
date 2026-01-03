import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'provider_waiting_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:math';

class ProviderRegistrationScreen extends StatefulWidget {
  const ProviderRegistrationScreen({super.key});

  @override
  State<ProviderRegistrationScreen> createState() =>
      _ProviderRegistrationScreenState();
}

class _ProviderRegistrationScreenState
    extends State<ProviderRegistrationScreen> {
  String _location = "Detecting location...";
  String _deviceName = "Camera";
  bool _isDetectingLocation = false;
  bool _locationWarning = false;
  bool _isGoingOnline = false;

  @override
  void initState() {
    super.initState();
    _detectLocation();
    _getDeviceName();
  }

  Future<void> _getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        final model = androidInfo.model.replaceAll(' ', '');
        final random = Random().nextInt(9999).toString().padLeft(4, '0');
        setState(() {
          _deviceName = 'Camera-$model-$random';
        });
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        final model = iosInfo.utsname.machine.replaceAll(',', '');
        final random = Random().nextInt(9999).toString().padLeft(4, '0');
        setState(() {
          _deviceName = 'Camera-$model-$random';
        });
      }
    } catch (e) {
      // Use default if device info fails
      final random = Random().nextInt(9999).toString().padLeft(4, '0');
      setState(() {
        _deviceName = 'Camera-Device-$random';
      });
    }
  }

  Future<void> _detectLocation() async {
    setState(() => _isDetectingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        );

        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final address = [
            place.street,
            place.locality,
            place.subAdministrativeArea,
          ].where((e) => e != null && e.isNotEmpty).take(2).join(', ');

          if (address.isNotEmpty) {
            setState(() {
              _location = address;
              _locationWarning = false;
              _isDetectingLocation = false;
            });
            return;
          }
        }
      }
    } catch (e) {
      print('⚠️  Location detection failed: $e');
    }

    // Fallback to default
    if (mounted) {
      setState(() {
        _location = 'San Francisco, CA';
        _locationWarning = true;
        _isDetectingLocation = false;
      });
    }
  }

  Future<void> _goOnline() async {
    setState(() => _isGoingOnline = true);

    try {
      final response = await SessionService().createSession(
        providerName: _deviceName,
        providerId: 'provider-${DateTime.now().millisecondsSinceEpoch}',
        location: _location,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderWaitingScreen(
              sessionId: response.sessionId,
              providerName: _deviceName,
              location: _location,
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
        setState(() => _isGoingOnline = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Provider Mode'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              const Text(
                'Go Online as Provider',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF00D4FF),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              // Location Display
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _locationWarning
                        ? Colors.orangeAccent.withOpacity(0.5)
                        : const Color(0xFF00D4FF).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _isDetectingLocation
                          ? Icons.location_searching
                          : Icons.location_on,
                      color: _locationWarning
                          ? Colors.orangeAccent
                          : const Color(0xFF00D4FF),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Location',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _location,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_locationWarning) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orangeAccent.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orangeAccent,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Using default location',
                              style: TextStyle(
                                color: Colors.orangeAccent.shade200,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 64),

              // Go Online Button
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed:
                      _isGoingOnline || _isDetectingLocation ? null : _goOnline,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4FF),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  child: _isGoingOnline
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'Go Online',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Device name hint
              Text(
                'Camera Name: $_deviceName',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
