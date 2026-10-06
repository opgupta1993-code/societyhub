import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';

/// Screen 1: Login with mobile number + OTP (Live API + Multi-Language Supported).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController(text: '8109957672');
  final _otp = TextEditingController(text: '5582');
  bool _otpSent = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  String _formattedPhone() {
    final raw = _phone.text.trim();
    if (raw.startsWith('+')) return raw;
    return '+91$raw';
  }

  Future<void> _sendOtp() async {
    if (_phone.text.length < 10) {
      setState(() => _error = 'Enter a 10-digit mobile number');
      return;
    }
    setState(() => _error = null);

    final success = await ref.read(authProvider.notifier).requestOtp(_formattedPhone());
    if (success) {
      setState(() {
        _otpSent = true;
      });
    } else {
      final authError = ref.read(authProvider).error;
      setState(() => _error = authError ?? 'Failed to send OTP');
    }
  }

  Future<void> _verify() async {
    if (_otp.text.length != 4 && _otp.text.length != 6) {
      setState(() => _error = 'Enter valid OTP verification code');
      return;
    }
    setState(() => _error = null);

    await ref.read(authProvider.notifier).loginWithOtp(
          _formattedPhone(),
          _otp.text.trim(),
        );

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
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, box) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.primary2],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('🏛️', style: TextStyle(fontSize: 38)),
                                // Language Switcher Button
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.language_rounded, color: Colors.white),
                                  tooltip: context.tr('switch_language'),
                                  onSelected: (String langCode) {
                                    ref.read(localeProvider.notifier).changeLocale(langCode);
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'en',
                                      child: Row(
                                        children: [
                                          if (currentLocale.languageCode == 'en')
                                            const Icon(Icons.check, size: 18, color: AppColors.primary),
                                          const SizedBox(width: 8),
                                          const Text('English'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'hi',
                                      child: Row(
                                        children: [
                                          if (currentLocale.languageCode == 'hi')
                                            const Icon(Icons.check, size: 18, color: AppColors.primary),
                                          const SizedBox(width: 8),
                                          const Text('हिंदी (Hindi)'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'mr',
                                      child: Row(
                                        children: [
                                          if (currentLocale.languageCode == 'mr')
                                            const Icon(Icons.check, size: 18, color: AppColors.primary),
                                          const SizedBox(width: 8),
                                          const Text('मराठी (Marathi)'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'gu',
                                      child: Row(
                                        children: [
                                          if (currentLocale.languageCode == 'gu')
                                            const Icon(Icons.check, size: 18, color: AppColors.primary),
                                          const SizedBox(width: 8),
                                          const Text('ગુજરાતી (Gujarati)'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Your society,\nin your pocket',
                              style: text.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bills, visitors and complaints in one app.',
                              style: text.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: .85)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SafeArea(
                      top: false,
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _otpSent ? context.tr('enter_otp_sub') : context.tr('mobile_number'),
                              style: text.bodySmall?.copyWith(color: AppColors.mute),
                            ),
                            const SizedBox(height: 6),
                            if (!_otpSent)
                              TextField(
                                controller: _phone,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: text.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                                decoration: const InputDecoration(
                                  prefixText: '+91  ',
                                  counterText: '',
                                  border: InputBorder.none,
                                  hintText: '98765 43210',
                                ),
                              )
                            else
                              TextField(
                                controller: _otp,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                autofocus: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: text.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 8),
                                decoration: const InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  hintText: '••••••',
                                ),
                              ),
                            if (authState.infoMessage != null && _otpSent)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  authState.infoMessage!,
                                  style: text.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (_error != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  _error!,
                                  style: text.bodySmall?.copyWith(color: AppColors.red),
                                ),
                              ),
                            const SizedBox(height: 8),
                            FilledButton(
                              onPressed: authState.isLoading ? null : (_otpSent ? _verify : _sendOtp),
                              child: authState.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(_otpSent ? context.tr('verify_login') : context.tr('request_otp')),
                            ),
                            if (_otpSent)
                              Center(
                                child: TextButton(
                                  onPressed: () => setState(() {
                                    _otpSent = false;
                                    _otp.clear();
                                    _error = null;
                                  }),
                                  child: Text(context.tr('change_number')),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () => context.push('/register'),
                      child: Text.rich(
                        TextSpan(
                          text: context.tr('no_account'),
                          style: text.bodySmall?.copyWith(color: AppColors.mute),
                          children: [
                            TextSpan(
                              text: context.tr('register_now'),
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
