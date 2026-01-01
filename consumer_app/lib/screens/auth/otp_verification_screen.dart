import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../shared/theme/jarvis_theme.dart';
import 'dart:async';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isVerifying = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOTP(String code) async {
    if (code.length != 6) return;

    setState(() {
      _isVerifying = true;
    });

    // TODO: Implement Firebase OTP verification
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isVerifying = false;
      });

      // Navigate to app on success
      // Navigator.pushReplacement to SessionListScreen
    }
  }

  Future<void> _resendOTP() async {
    if (_resendTimer > 0) return;

    // TODO: Implement resend OTP
    setState(() {
      _resendTimer = 60;
    });
    _startResendTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code sent!'),
        backgroundColor: JarvisTheme.primaryCyan,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JarvisTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: JarvisTheme.primaryCyan),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              Text(
                'Verify Phone Number',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  children: [
                    TextSpan(text: 'We sent a code to '),
                    TextSpan(
                      text: widget.phoneNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: JarvisTheme.primaryCyan,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // OTP Input
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 56,
                  fieldWidth: 48,
                  activeFillColor: JarvisTheme.surfaceColor,
                  inactiveFillColor: JarvisTheme.surfaceColor.withOpacity(0.3),
                  selectedFillColor: JarvisTheme.surfaceColor,
                  activeColor: JarvisTheme.primaryCyan,
                  inactiveColor: Colors.white.withOpacity(0.2),
                  selectedColor: JarvisTheme.primaryCyan,
                ),
                cursorColor: JarvisTheme.primaryCyan,
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                onCompleted: _verifyOTP,
                onChanged: (value) {},
              ),

              const SizedBox(height: 32),

              // Resend code
              Center(
                child: _resendTimer > 0
                    ? Text(
                        'Resend code in $_resendTimer seconds',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      )
                    : TextButton(
                        onPressed: _resendOTP,
                        child: Text(
                          'Resend Code',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: JarvisTheme.primaryCyan,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // Edit phone number
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Edit Phone Number',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Spacer(),

              // Verify button
              if (_isVerifying)
                Center(
                  child: CircularProgressIndicator(
                    color: JarvisTheme.primaryCyan,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
