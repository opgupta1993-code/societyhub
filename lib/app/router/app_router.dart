import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/role_enum.dart';
import '../../core/providers/auth_provider.dart';
import '../../features/admin/screens/admin_owner_home_screen.dart';
import '../../features/admin/screens/hr_users_screen.dart';
import '../../features/admin/screens/assign_role_screen.dart';
import '../../features/admin/screens/manager_permissions_screen.dart';
import '../../features/admin/screens/collections_screen.dart';
import '../../features/admin/screens/complaints_screen.dart';
import '../../features/admin/screens/audit_log_screen.dart';
import '../../features/admin/screens/financial_reports_screen.dart';
import '../../features/admin/screens/society_settings_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_verify_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/common/screens/notifications_screen.dart';
import '../../features/common/screens/profile_screen.dart';
import '../../features/resident/screens/tenant_home_screen.dart';
import '../../features/resident/screens/pay_bill_screen.dart';
import '../../features/resident/screens/rent_payments_screen.dart';
import '../../features/resident/screens/documents_screen.dart';
import '../../features/resident/screens/share_with_landlord_screen.dart';
import '../../features/resident/screens/invite_visitor_screen.dart';
import '../../features/admin/screens/super_admin_home_screen.dart';
import '../../features/manager/screens/manager_home_screen.dart';
import '../../features/accountant/screens/accountant_home_screen.dart';
import '../../features/committee/screens/committee_home_screen.dart';
import '../../features/guard/screens/guard_home_screen.dart';
import '../../features/resident/screens/family_members_screen.dart';
import '../../features/resident/screens/vehicles_screen.dart';
import '../../features/resident/screens/notices_screen.dart';
import '../../features/resident/screens/polls_screen.dart';
import '../../features/resident/screens/amenity_booking_screen.dart';
import '../../features/resident/screens/directory_screen.dart';
import '../../features/resident/screens/important_contacts_screen.dart';
import '../../features/guard/screens/guard_walkin_screen.dart';
import '../../features/accountant/screens/generate_bills_screen.dart';
import '../../features/accountant/screens/log_expense_screen.dart';
import '../../features/resident/screens/visitor_log_screen.dart';
import '../../features/resident/screens/help_support_screen.dart';
import '../../features/resident/screens/records_hub_screen.dart';
import '../../features/resident/screens/charges_breakup_screen.dart';
import '../../features/committee/screens/committee_meetings_screen.dart';
import '../../features/guard/screens/guard_staff_check_screen.dart';
import '../../features/guard/screens/guard_approval_status_screen.dart';
import '../../features/manager/screens/manager_approvals_screen.dart';
import '../../features/manager/screens/manager_complaints_screen.dart';
import '../../features/manager/screens/create_notice_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier<bool>(false);

  ref.listen<AuthState>(authProvider, (previous, next) {
    if (previous?.isAuthenticated != next.isAuthenticated) {
      refreshNotifier.value = next.isAuthenticated;
    }
  });

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthFlow = state.matchedLocation == '/splash' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/verify-otp' ||
          state.matchedLocation == '/register';

      if (!authState.isAuthenticated && !isAuthFlow) {
        return '/login';
      }

      if (authState.isAuthenticated && isAuthFlow) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Auth & Splash Screens (Wireframe Screens 1, 2, 3, 4)
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(), // 1 · Splash
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(), // 2 · Login
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '+91 98765 43210';
          return OtpVerifyScreen(phone: phone); // 3 · Verify OTP
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final initialPhone = state.extra as String?;
          return RegisterScreen(initialPhone: initialPhone); // 4 · Register
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => Consumer(
          builder: (context, ref, _) {
            final authState = ref.watch(authProvider);
            final user = authState.user;
            final activeRole = user?.activeRole ?? UserRole.resident;

            switch (activeRole) {
              case UserRole.superAdmin:
                return const SuperAdminHomeScreen();
              case UserRole.admin:
                return const AdminOwnerHomeScreen();
              case UserRole.manager:
                return const ManagerHomeScreen();
              case UserRole.resident:
                return const TenantHomeScreen();
              case UserRole.accountant:
                return const AccountantHomeScreen();
              case UserRole.committee:
                return const CommitteeHomeScreen();
              case UserRole.guard:
                return const GuardHomeScreen();
            }
          },
        ),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(), // A4
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(), // A5
      ),

      // B. Resident Modules (B1 - B14)
      GoRoute(
        path: '/dues',
        builder: (context, state) => const PayBillScreen(), // B1 / Screen 3
      ),
      GoRoute(
        path: '/complaints',
        builder: (context, state) => const ComplaintsScreen(),
      ),
      GoRoute(
        path: '/visitors',
        builder: (context, state) => const InviteVisitorScreen(), // B3 / Invite Visitor & Gate Pass
      ),
      GoRoute(
        path: '/visitor-log',
        builder: (context, state) => const VisitorLogScreen(), // B4 / H4 Visitor Log
      ),
      GoRoute(
        path: '/notices',
        builder: (context, state) => const NoticesScreen(),
      ),
      GoRoute(
        path: '/polls',
        builder: (context, state) => const PollsScreen(),
      ),
      GoRoute(
        path: '/amenities',
        builder: (context, state) => const AmenityBookingScreen(),
      ),
      GoRoute(
        path: '/my-bookings',
        builder: (context, state) => const AmenityBookingScreen(),
      ),
      GoRoute(
        path: '/directory',
        builder: (context, state) => const DirectoryScreen(),
      ),
      GoRoute(
        path: '/contacts',
        builder: (context, state) => const ImportantContactsScreen(),
      ),
      GoRoute(
        path: '/documents',
        builder: (context, state) => const DocumentsScreen(), // B11 / Agreement & Documents
      ),
      GoRoute(
        path: '/family',
        builder: (context, state) => const FamilyMembersScreen(),
      ),
      GoRoute(
        path: '/vehicles',
        builder: (context, state) => const VehiclesScreen(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpSupportScreen(), // B14 Help & Support
      ),

      // C. Rent, Records & Sharing (C1 - C11)
      GoRoute(
        path: '/records-hub',
        builder: (context, state) => const RecordsHubScreen(), // C1 My Records Hub
      ),
      GoRoute(
        path: '/rent',
        builder: (context, state) => const RentPaymentsScreen(), // C2 / Rent & Payments
      ),
      GoRoute(
        path: '/charges-breakup',
        builder: (context, state) => const ChargesBreakupScreen(), // C4 Charges Breakup
      ),
      GoRoute(
        path: '/shared-access',
        builder: (context, state) => const ShareWithLandlordScreen(), // C9 / Share with landlord
      ),

      // D. Admin Screens (D1 - D7)
      GoRoute(
        path: '/admin-hr',
        builder: (context, state) => const HrUsersScreen(),
      ),
      GoRoute(
        path: '/assign-role',
        builder: (context, state) {
          final user = state.extra as HrUserItem? ??
              const HrUserItem(
                id: '1',
                name: 'Rahul S.',
                subtitle: 'B-402 · Tenant',
                roleLabel: 'Resident',
                category: 'resident',
              );
          return AssignRoleScreen(user: user);
        },
      ),
      GoRoute(
        path: '/admin-roles',
        builder: (context, state) => const ManagerPermissionsScreen(),
      ),
      GoRoute(
        path: '/admin-settings',
        builder: (context, state) => const SocietySettingsScreen(),
      ),
      GoRoute(
        path: '/admin-audit',
        builder: (context, state) => const AuditLogScreen(),
      ),

      // E. Manager Screens (E1 - E5)
      GoRoute(
        path: '/manager-complaints',
        builder: (context, state) => const ManagerComplaintsScreen(), // E2 / E3 Complaint Queue & Dispatch
      ),
      GoRoute(
        path: '/manager-approvals',
        builder: (context, state) => const ManagerApprovalsScreen(), // E4 Booking Approvals
      ),
      GoRoute(
        path: '/manager-create-notice',
        builder: (context, state) => const CreateNoticeScreen(), // E5 Create Notice
      ),

      // F. Accountant Screens (F1 - F5)
      GoRoute(
        path: '/accountant-bills',
        builder: (context, state) => const GenerateBillsScreen(),
      ),
      GoRoute(
        path: '/accountant-collections',
        builder: (context, state) => const CollectionsScreen(),
      ),
      GoRoute(
        path: '/accountant-expenses',
        builder: (context, state) => const LogExpenseScreen(),
      ),
      GoRoute(
        path: '/accountant-reports',
        builder: (context, state) => const FinancialReportsScreen(),
      ),

      // G. Committee Screens (G1 - G4)
      GoRoute(
        path: '/committee-polls',
        builder: (context, state) => const PollsScreen(),
      ),
      GoRoute(
        path: '/committee-meetings',
        builder: (context, state) => const CommitteeMeetingsScreen(), // G4 Meetings & MoM
      ),

      // H. Security Guard Desk (H1 - H5)
      GoRoute(
        path: '/guard-walkin',
        builder: (context, state) => const GuardWalkinScreen(),
      ),
      GoRoute(
        path: '/guard-approval-status',
        builder: (context, state) => const GuardApprovalStatusScreen(), // H3 Approval Status
      ),
      GoRoute(
        path: '/guard-log',
        builder: (context, state) => const VisitorLogScreen(), // H4 Visitor Log
      ),
      GoRoute(
        path: '/guard-vehicle-check',
        builder: (context, state) => const GuardStaffCheckScreen(), // H5 Staff & Vehicle Check
      ),
      GoRoute(
        path: '/amenity-booking',
        builder: (context, state) => const AmenityBookingScreen(),
      ),
    ],
  );
});
