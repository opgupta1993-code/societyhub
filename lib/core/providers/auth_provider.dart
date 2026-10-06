import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/role_enum.dart';
import '../network/api_service.dart';

enum VerifyStatus { registered, needsRegistration, error }

class VerifyResult {
  final VerifyStatus status;
  final String? message;
  final UserModel? user;

  VerifyResult(this.status, {this.message, this.user});
}

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
        latestOtp: otpReceived ?? '5582',
        infoMessage: msg,
      );
      return true;
    } else {
      final serverMsg = response['message']?.toString() ?? 'Failed to send OTP';
      final isNotReg = serverMsg.toLowerCase().contains('not registered') ||
          serverMsg.toLowerCase().contains('unregistered') ||
          serverMsg.toLowerCase().contains('user not found');

      final displayErr = isNotReg
          ? 'Your mobile number is not registered. Please create your account.'
          : serverMsg;

      state = state.copyWith(
        isLoading: false,
        error: displayErr,
      );
      return false;
    }
  }

  Future<VerifyResult> verifyOtpWithStatus(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null, infoMessage: null);

    final response = await ApiService.verifyOtp(phone, otp);

    if (response['success'] == true && response['user'] != null) {
      final token = response['token'] as String?;
      final userData = response['user'] as Map<String, dynamic>;

      final rawRole = userData['role']?.toString() ?? 'resident';
      final activeRole = UserRole.fromCode(rawRole);
      final isOwnerRole = rawRole.toLowerCase() == 'owner' || rawRole.toLowerCase() == 'admin';

      final isRegistered = userData['uid'] != null &&
          userData['name'] != null &&
          userData['name'] != 'New User';

      if (isRegistered) {
        final user = UserModel(
          id: userData['uid'],
          name: userData['name'] ?? 'Rahul Sharma',
          phone: userData['phone'] ?? phone,
          societyName: 'Demo Housing Society',
          blockFlat: 'Tower B - 402',
          isOwner: isOwnerRole,
          activeRole: activeRole,
          availableRoles: UserRole.values.toList(),
        );

        state = AuthState(
          isAuthenticated: true,
          user: user,
          token: token,
          isLoading: false,
        );

        return VerifyResult(VerifyStatus.registered, user: user);
      } else {
        // User data missing/unregistered -> redirect to Registration
        state = state.copyWith(isLoading: false);
        return VerifyResult(VerifyStatus.needsRegistration);
      }
    } else {
      // Fallback for testing with 5582 / 5012 / 123456
      if (otp == '5582' || otp == '5012' || otp == '123456') {
        final user = UserModel.dummyUser().copyWith(phone: phone);
        state = AuthState(
          isAuthenticated: true,
          user: user,
          token: 'demo_jwt_token',
          isLoading: false,
        );
        return VerifyResult(VerifyStatus.registered, user: user);
      } else {
        // Data not received or unregistered -> redirect to Registration
        state = state.copyWith(isLoading: false);
        return VerifyResult(VerifyStatus.needsRegistration);
      }
    }
  }

  Future<void> loginWithOtp(String phone, String otp) async {
    await verifyOtpWithStatus(phone, otp);
  }

  Future<void> registerUser({
    required String name,
    required String phone,
    required String email,
    required String society,
    required String tower,
    required String flat,
    required bool isOwner,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final fullFlat = 'Tower $tower - $flat';
    final res = await ApiService.registerUser(
      name: name,
      phone: phone,
      society: society,
      flat: fullFlat,
      isOwner: isOwner,
    );

    final newUser = UserModel(
      id: res['user']?['uid'] ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      societyName: society,
      blockFlat: fullFlat,
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
