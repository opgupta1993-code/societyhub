import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';

/// Screen 4: Create Account / Registration Screen (from wireframe image)
class RegisterScreen extends ConsumerStatefulWidget {
  final String? initialPhone;

  const RegisterScreen({
    super.key,
    this.initialPhone,
  });

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  String _selectedSociety = 'Demo Housing Society';
  String _selectedTower = 'B';
  String _selectedFlat = '402';
  bool _agreedToTerms = true;
  String? _error;

  final List<String> _societies = [
    'Demo Housing Society',
    'Greenwood Heights CHS',
    'Sunrise Towers',
    'Royal Palms Society',
  ];

  final List<String> _towers = ['A', 'B', 'C', 'D'];
  final List<String> _flats = ['101', '102', '201', '202', '301', '302', '401', '402', '501'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Rahul Sharma');
    _phoneController = TextEditingController(
      text: widget.initialPhone ?? '+91 98765 43210',
    );
    _emailController = TextEditingController(text: 'name@email.com');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your full name');
      return;
    }
    if (!_agreedToTerms) {
      setState(() => _error = 'Please agree to the Terms and Privacy Policy');
      return;
    }
    setState(() => _error = null);

    await ref.read(authProvider.notifier).registerUser(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          society: _selectedSociety,
          tower: _selectedTower,
          flat: _selectedFlat,
          isOwner: true,
        );

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 8.0),
            child: Image.asset(
              'assets/images/app_icon.png',
              height: 38,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                'Create account',
                style: text.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 20),

              // Full Name Card
              _buildInputCard(
                label: 'Full name',
                child: TextField(
                  controller: _nameController,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: 'Rahul Sharma',
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Mobile Number Card
              _buildInputCard(
                label: 'Mobile number',
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: '+91 98765 43210',
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Email Card (Optional)
              _buildInputCard(
                label: 'Email (optional)',
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: 'name@email.com',
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Society Dropdown Card
              _buildInputCard(
                label: 'Society',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSociety,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.ink),
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                    onChanged: (String? val) {
                      if (val != null) setState(() => _selectedSociety = val);
                    },
                    items: _societies.map((soc) {
                      return DropdownMenuItem(value: soc, child: Text(soc));
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tower & Flat Side-by-side Row
              Row(
                children: [
                  Expanded(
                    child: _buildInputCard(
                      label: 'Tower',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTower,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.ink),
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                          onChanged: (String? val) {
                            if (val != null) setState(() => _selectedTower = val);
                          },
                          items: _towers.map((t) {
                            return DropdownMenuItem(value: t, child: Text(t));
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInputCard(
                      label: 'Flat',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFlat,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.ink),
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                          onChanged: (String? val) {
                            if (val != null) setState(() => _selectedFlat = val);
                          },
                          items: _flats.map((f) {
                            return DropdownMenuItem(value: f, child: Text(f));
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Terms & Conditions Checkbox
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreedToTerms,
                      activeColor: const Color(0xFF0062E0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) {
                        setState(() => _agreedToTerms = val ?? false);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'I agree to the Terms and Privacy Policy',
                      style: text.bodySmall?.copyWith(
                        color: AppColors.mute,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(color: AppColors.red, fontSize: 13),
                ),
              ],
              const SizedBox(height: 24),

              // Register CTA Button
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
                  onPressed: authState.isLoading ? null : _handleRegister,
                  child: authState.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Register'),
                ),
              ),
              const SizedBox(height: 16),

              // Already have an account? Log in
              Center(
                child: GestureDetector(
                  onTap: () => context.go('/login'),
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.mute,
                        fontSize: 14,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Log in',
                          style: TextStyle(
                            color: Color(0xFF0062E0),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({required String label, required Widget child}) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.mute,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}
