import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/role_enum.dart';
import '../network/api_service.dart';

class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final String? token;
  final String? latestOtp;
  final bool isLoading;
  final String? error;
  final String? infoMessage;

  const AuthState({
    required this.isAuthenticated,
    this.user,
    this.token,
    this.latestOtp,
    this.isLoading = false,
    this.error,
    this.infoMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    String? token,
    String? latestOtp,
    bool? isLoading,
    String? error,
    String? infoMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
      latestOtp: latestOtp ?? this.latestOtp,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      infoMessage: infoMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState(isAuthenticated: false);
  }

  Future<bool> requestOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null, infoMessage: null);

    final response = await ApiService.requestOtp(phone);
    if (response['success'] == true) {
      final otpReceived = response['otp']?.toString();
      final msg = otpReceived != null
          ? 'OTP sent successfully! (Server OTP: $otpReceived)'
          : (response['message'] ?? 'OTP sent successfully!');

      state = state.copyWith(
        isLoading: false,
        latestOtp: otpReceived ?? '5012',
        infoMessage: msg,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response['message'] ?? 'Failed to send OTP',
      );
      return false;
    }
  }

  Future<void> loginWithOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null, infoMessage: null);

    // Call live API verify-otp endpoint
    final response = await ApiService.verifyOtp(phone, otp);

    if (response['success'] == true) {
      final token = response['token'] as String?;
      final userData = response['user'] as Map<String, dynamic>?;

      final roleCode = userData?['role']?.toString().toUpperCase() ?? 'RES';
      final activeRole = UserRole.fromCode(roleCode);

      final user = UserModel(
        id: userData?['uid'] ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: userData?['name'] ?? 'Society Resident',
        phone: userData?['phone'] ?? phone,
        societyName: 'Greenwood Heights CHS',
        blockFlat: 'Tower A - 402',
        isOwner: true,
        activeRole: activeRole,
        availableRoles: UserRole.values.toList(),
      );

      state = AuthState(
        isAuthenticated: true,
        user: user,
        token: token,
        isLoading: false,
      );
    } else {
      // Fallback for offline or demo testing with 5012 / 5582
      if (otp == '5012' || otp == '5582' || otp == '123456') {
        state = AuthState(
          isAuthenticated: true,
          user: UserModel.dummyUser().copyWith(phone: phone),
          token: 'demo_jwt_token',
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'Invalid OTP code',
        );
      }
    }
  }

  Future<void> registerUser({
    required String name,
    required String phone,
    required String society,
    required String flat,
    required bool isOwner,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final res = await ApiService.registerUser(
      name: name,
      phone: phone,
      society: society,
      flat: flat,
      isOwner: isOwner,
    );

    final newUser = UserModel(
      id: res['user']?['uid'] ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      societyName: society,
      blockFlat: flat,
      isOwner: isOwner,
      activeRole: UserRole.resident,
      availableRoles: UserRole.values.toList(),
    );

    state = AuthState(
      isAuthenticated: true,
      user: newUser,
      token: res['token'],
      isLoading: false,
    );
  }

  void switchActiveRole(UserRole newRole) {
    if (state.user != null && state.user!.availableRoles.contains(newRole)) {
      state = state.copyWith(
        user: state.user!.copyWith(activeRole: newRole),
      );
    }
  }

  void logout() {
    state = const AuthState(isAuthenticated: false, user: null);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
