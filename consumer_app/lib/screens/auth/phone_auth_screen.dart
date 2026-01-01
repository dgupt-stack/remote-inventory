import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../shared/theme/jarvis_theme.dart';
import 'otp_verification_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String _selectedCountryCode = '+1';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final phoneNumber = _selectedCountryCode + _phoneController.text;

    // TODO: Implement Firebase phone auth
    // For now, navigate to OTP screen
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            phoneNumber: phoneNumber,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JarvisTheme.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // Logo and title
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 80,
                              color: JarvisTheme.primaryCyan,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Welcome to',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'J.A.R.V.I.S',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: JarvisTheme.primaryCyan,
                                shadows: [
                                  Shadow(
                                    color: JarvisTheme.primaryCyan
                                        .withOpacity(0.5),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sign in to continue',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Phone number input
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        decoration: BoxDecoration(
                          color: JarvisTheme.surfaceColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: JarvisTheme.primaryCyan.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Country code picker
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownButton<String>(
                                value: _selectedCountryCode,
                                underline: SizedBox(),
                                dropdownColor: JarvisTheme.surfaceColor,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                items: [
                                  DropdownMenuItem(
                                      value: '+1', child: Text('+1 🇺🇸')),
                                  DropdownMenuItem(
                                      value: '+91', child: Text('+91 🇮🇳')),
                                  DropdownMenuItem(
                                      value: '+44', child: Text('+44 🇬🇧')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCountryCode = value!;
                                  });
                                },
                              ),
                            ),

                            // Divider
                            Container(
                              height: 24,
                              width: 1,
                              color: JarvisTheme.primaryCyan.withOpacity(0.3),
                            ),

                            // Phone input
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: '(555) 555-5555',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Send code button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: JarvisTheme.primaryCyan,
                            foregroundColor: JarvisTheme.darkBackground,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      JarvisTheme.darkBackground,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Send Code',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Social login buttons
                      _buildSocialButton(
                        icon: Icons.g_mobiledata,
                        label: 'Continue with Google',
                        color: Colors.white,
                        onTap: _signInWithGoogle,
                      ),

                      const SizedBox(height: 12),

                      _buildSocialButton(
                        icon: Icons.apple,
                        label: 'Continue with Apple',
                        color: Colors.white,
                        onTap: _signInWithApple,
                      ),

                      const SizedBox(height: 32),

                      // Email option
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navigate to email auth screen
                          },
                          child: Text(
                            'Use Email Instead →',
                            style: TextStyle(
                              color: JarvisTheme.primaryCyan,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Terms and privacy
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: JarvisTheme.surfaceColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signInWithGoogle() {
    // TODO: Implement Google Sign-In
    print('Google Sign-In');
  }

  void _signInWithApple() {
    // TODO: Implement Apple Sign-In
    print('Apple Sign-In');
  }
}
