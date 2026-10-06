import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController(text: '8109957672');
  final _otpController = TextEditingController(text: '5582');
  bool _otpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String _formattedPhone() {
    final raw = _phoneController.text.trim();
    if (raw.startsWith('+')) return raw;
    return '+91$raw';
  }

  Future<void> _handleSendOtp() async {
    final phone = _formattedPhone();
    if (_phoneController.text.trim().length >= 10) {
      final success = await ref.read(authProvider.notifier).requestOtp(phone);
      if (success) {
        setState(() {
          _otpSent = true;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
    }
  }

  void _handleVerifyOtp() {
    final phone = _formattedPhone();
    final otp = _otpController.text.trim();
    ref.read(authProvider.notifier).loginWithOtp(phone, otp);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // App Logo & Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SocietyHub',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Complete Gated Community Management App',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'API Connected: https://bahikhata.webenhancehub.com/',
                        style: TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Title Section
              Text(
                _otpSent ? 'Enter OTP Verification' : 'Login to Your Account',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _otpSent
                    ? (authState.infoMessage ?? 'OTP sent to ${_formattedPhone()}.')
                    : 'Enter your registered mobile number to receive OTP',
                style: TextStyle(
                  color: authState.infoMessage != null ? AppColors.secondary : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: authState.infoMessage != null ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 24),

              if (authState.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          authState.error!,
                          style: const TextStyle(color: AppColors.error, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (!_otpSent) ...[
                // Mobile Input Field (A1)
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: '8109957672',
                    prefixIcon: Icon(Icons.phone_android_rounded),
                    prefixText: '+91 ',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleSendOtp,
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Request OTP'),
                ),
              ] else ...[
                // OTP Input Field (A1)
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Verification Code',
                    hintText: '5582',
                    prefixIcon: Icon(Icons.lock_clock_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _otpSent = false),
                      child: const Text('Change Number'),
                    ),
                    TextButton(
                      onPressed: authState.isLoading ? null : _handleSendOtp,
                      child: const Text('Resend OTP'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleVerifyOtp,
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Verify & Login'),
                ),
              ],

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // Register CTA (A2)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => context.push('/register'),
                    child: const Text(
                      'Register Now (A2)',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
