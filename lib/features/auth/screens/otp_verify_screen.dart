import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';

/// Screen 3: Verify OTP Screen (4-Digit OTP Verification + Conditional Registration Route)
class OtpVerifyScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpVerifyScreen({
    super.key,
    required this.phone,
  });

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  // 4 Digit Controllers & Focus Nodes
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _secondsRemaining = 27;
  Timer? _timer;
  String? _error;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Auto-fill dynamic server OTP received from POST /auth/request-otp
    final latestOtp = ref.read(authProvider).latestOtp;
    final info = ref.read(authProvider).infoMessage;

    String otpStr = '5582';
    if (latestOtp != null && latestOtp.isNotEmpty) {
      otpStr = latestOtp;
    } else if (info != null) {
      final match = RegExp(r'\d{4}').firstMatch(info);
      if (match != null) otpStr = match.group(0)!;
    }

    for (int i = 0; i < otpStr.length && i < 4; i++) {
      _controllers[i].text = otpStr[i];
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 27);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    final otp = _otpCode.trim();
    if (otp.length < 4) {
      setState(() => _error = 'Please enter the complete 4-digit verification code');
      return;
    }
    setState(() {
      _error = null;
      _isSubmitting = true;
    });

    try {
      final result = await ref
          .read(authProvider.notifier)
          .verifyOtpWithStatus(widget.phone, otp);

      if (!mounted) return;

      if (result.status == VerifyStatus.registered) {
        // Success API data -> Home Screen
        context.go('/home');
      } else if (result.status == VerifyStatus.needsRegistration) {
        // User not registered -> Show message & navigate to Registration Screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your mobile number is not registered. Please create your account.'),
            backgroundColor: AppColors.red,
            duration: Duration(seconds: 3),
          ),
        );
        context.push('/register', extra: widget.phone);
      } else {
        setState(() => _error = result.message ?? 'Invalid OTP code');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Headline Title
              Text(
                'Verify your number',
                style: text.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text.rich(
                TextSpan(
                  text: 'We sent a 4-digit code to\n',
                  style: text.bodyMedium?.copyWith(
                    color: AppColors.mute,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: widget.phone,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // 4 Digit Input Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _digitBox(index)),
              ),

              const SizedBox(height: 28),

              // Resend Timer Below OTP Boxes
              Center(
                child: _secondsRemaining > 0
                    ? Text.rich(
                        TextSpan(
                          text: 'Resend code in ',
                          style: text.bodyMedium?.copyWith(
                            color: AppColors.mute,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Color(0xFF0062E0),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : TextButton(
                        onPressed: () async {
                          await ref.read(authProvider.notifier).requestOtp(widget.phone);
                          final newOtp = ref.read(authProvider).latestOtp;
                          if (newOtp != null && newOtp.length >= 4) {
                            for (int i = 0; i < 4; i++) {
                              _controllers[i].text = newOtp[i];
                            }
                          }
                          _startTimer();
                        },
                        child: const Text(
                          'Resend code now',
                          style: TextStyle(
                            color: Color(0xFF0062E0),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: AppColors.red, fontSize: 13),
                  ),
                ),
              ],

              const Spacer(),

              // Bottom Fixed CTA Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0062E0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _verifyOtp,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Verify and log in'),
                ),
              ),
              const SizedBox(height: 8),

              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: const Text(
                    'Change number',
                    style: TextStyle(
                      color: Color(0xFF0062E0),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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

  Widget _digitBox(int index) {
    return Container(
      width: 60,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? const Color(0xFF0062E0)
              : AppColors.line,
          width: _focusNodes[index].hasFocus ? 2 : 1,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}
