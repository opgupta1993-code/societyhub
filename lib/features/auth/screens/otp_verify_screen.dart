import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';

/// Screen 3: Verify OTP Screen (from wireframe image)
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
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsRemaining = 27;
  Timer? _timer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Auto-fill default test OTP digits (4 8 2 9 5 0 or from server info)
    final info = ref.read(authProvider).infoMessage;
    final match = RegExp(r'\d{4,6}').firstMatch(info ?? '');
    final otpStr = match != null ? match.group(0)! : '482950';

    for (int i = 0; i < otpStr.length && i < 6; i++) {
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
      setState(() => _error = 'Please enter the complete verification code');
      return;
    }
    setState(() => _error = null);

    await ref.read(authProvider.notifier).loginWithOtp(widget.phone, otp);

    final authState = ref.read(authProvider);
    if (authState.isAuthenticated) {
      if (mounted) context.go('/home');
    } else if (authState.error != null) {
      setState(() => _error = authState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final authState = ref.watch(authProvider);

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
                  text: 'We sent a 6-digit code to\n',
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
              const SizedBox(height: 32),

              // 6 Digit Input Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _digitBox(index)),
              ),

              const SizedBox(height: 24),

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
                        onPressed: () {
                          ref.read(authProvider.notifier).requestOtp(widget.phone);
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
                  onPressed: authState.isLoading ? null : _verifyOtp,
                  child: authState.isLoading
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
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
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
