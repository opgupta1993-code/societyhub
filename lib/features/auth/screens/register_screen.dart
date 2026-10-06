import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Rajesh Sharma');
  final _phoneController = TextEditingController(text: '9876543210');
  final _societyController = TextEditingController(text: 'Greenwood Heights CHS');
  final _flatController = TextEditingController(text: 'Tower A - 402');
  bool _isOwner = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _societyController.dispose();
    _flatController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).registerUser(
            name: _nameController.text.trim(),
            phone: '+91 ${_phoneController.text.trim()}',
            society: _societyController.text.trim(),
            flat: _flatController.text.trim(),
            isOwner: _isOwner,
          );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Account (A2)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join Your Society Community',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              const Text(
                'Fill in your details to register. Default role assigned will be Resident.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter full name' : null,
              ),
              const SizedBox(height: 16),

              // Mobile
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone_android_outlined),
                  prefixText: '+91 ',
                ),
                validator: (val) => val == null || val.length < 10 ? 'Enter 10-digit number' : null,
              ),
              const SizedBox(height: 16),

              // Society
              TextFormField(
                controller: _societyController,
                decoration: const InputDecoration(
                  labelText: 'Society Name',
                  prefixIcon: Icon(Icons.apartment_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter society name' : null,
              ),
              const SizedBox(height: 16),

              // Flat
              TextFormField(
                controller: _flatController,
                decoration: const InputDecoration(
                  labelText: 'Tower / Wing & Flat Number',
                  prefixIcon: Icon(Icons.home_outlined),
                  hintText: 'e.g. Building B - 104',
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter flat number' : null,
              ),
              const SizedBox(height: 24),

              // Occupant Type Switch (Owner vs Tenant)
              const Text(
                'Occupant Type',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Flat Owner')),
                      selected: _isOwner,
                      onSelected: (selected) {
                        if (selected) setState(() => _isOwner = true);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Tenant')),
                      selected: !_isOwner,
                      onSelected: (selected) {
                        if (selected) setState(() => _isOwner = false);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: authState.isLoading ? null : _handleRegister,
                child: authState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Complete Registration & Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
