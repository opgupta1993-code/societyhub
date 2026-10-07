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

    try {
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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error. Please try again.',
      );
      return false;
    } finally {
      if (state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<VerifyResult> verifyOtpWithStatus(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null, infoMessage: null);

    try {
      final response = await ApiService.verifyOtp(phone, otp);

      if (response['success'] == true && response['user'] != null) {
        final token = response['token'] as String?;
        final userData = response['user'] as Map<String, dynamic>;
        final rawRoleId = userData['role_id'];
        final rawRole = userData['role']?.toString();

        // Checking if role_id is null or empty
        final isNullOrInvalidRoleId = rawRoleId == null ||
            rawRoleId.toString() == 'null' ||
            rawRoleId.toString().trim().isEmpty;

        // User is registered ONLY IF role_id is NOT null (e.g. "1" for Owner or "2" for Tenant)
        final isRegistered = !isNullOrInvalidRoleId && userData['uid'] != null;

        if (isRegistered) {
          final activeRole = UserRole.fromRoleId(rawRoleId, rawRole);
          final int parsedRoleId = (int.tryParse(rawRoleId.toString()) ?? (activeRole == UserRole.admin ? 1 : 2));
          final isOwnerRole = parsedRoleId == 1 || activeRole == UserRole.admin;

          final user = UserModel(
            id: userData['uid'],
            name: userData['name'] ?? 'Rahul Sharma',
            phone: userData['phone'] ?? phone,
            societyName: 'Demo Housing Society',
            blockFlat: 'Tower B - 402',
            roleId: parsedRoleId,
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
        // Server returned success == false or user not found -> Redirect to Registration
        final serverMsg = response['message']?.toString() ?? 'User not found. Please request an OTP first.';
        final isNotReg = serverMsg.toLowerCase().contains('not registered') ||
            serverMsg.toLowerCase().contains('unregistered') ||
            serverMsg.toLowerCase().contains('user not found');

        final displayMsg = isNotReg
            ? 'Your mobile number is not registered. Please create your account.'
            : serverMsg;

        state = state.copyWith(
          isLoading: false,
          error: displayMsg,
        );
        return VerifyResult(VerifyStatus.needsRegistration, message: displayMsg);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Verification error');
      return VerifyResult(VerifyStatus.error, message: 'Verification error');
    } finally {
      if (state.isLoading) {
        state = state.copyWith(isLoading: false);
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
