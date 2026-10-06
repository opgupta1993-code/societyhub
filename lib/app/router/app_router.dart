import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/role_enum.dart';
import '../../core/providers/auth_provider.dart';
import '../../features/admin/screens/admin_owner_home_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_verify_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/common/screens/notifications_screen.dart';
import '../../features/common/screens/profile_screen.dart';
import '../../features/common/screens/feature_placeholder_screen.dart';
import '../../features/resident/screens/tenant_home_screen.dart';
import '../../features/resident/screens/pay_bill_screen.dart';
import '../../features/resident/screens/rent_payments_screen.dart';
import '../../features/resident/screens/documents_screen.dart';
import '../../features/resident/screens/raise_issue_screen.dart';
import '../../features/resident/screens/share_with_landlord_screen.dart';
import '../../features/resident/screens/invite_visitor_screen.dart';

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
            final isOwnerOrAdmin = user?.activeRole == UserRole.admin || user?.isOwner == true;
            if (isOwnerOrAdmin) {
              return const AdminOwnerHomeScreen(); // Owner / Admin Dashboard
            }
            return const TenantHomeScreen(); // Tenant Home Dashboard
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
        builder: (context, state) => const RaiseIssueScreen(), // B2 / Raise Issue
      ),
      GoRoute(
        path: '/visitors',
        builder: (context, state) => const InviteVisitorScreen(), // B3 / Invite Visitor & Gate Pass
      ),
      GoRoute(
        path: '/visitor-log',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'B4',
          screenTitle: 'Visitor Log',
          category: 'B. Resident',
          description: 'In/Out history, allow or deny gate entry requests',
        ),
      ),
      GoRoute(
        path: '/notices',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'B5',
          screenTitle: 'Notice Board',
          category: 'B. Resident',
          description: 'Society notices, announcements, event RSVP',
        ),
      ),
      GoRoute(
        path: '/polls',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'B6',
          screenTitle: 'Polls & Voting',
          category: 'B. Resident',
          description: 'Voting options, cast vote, view real-time percentage results',
        ),
      ),
      GoRoute(
        path: '/amenities',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'B7',
          screenTitle: 'Amenity Booking',
          category: 'B. Resident',
          description: 'Amenity list, date picker, slot selection, fee calculation',
        ),
      ),
      GoRoute(
        path: '/my-bookings',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'B8',
          screenTitle: 'My Bookings',
          category: 'B. Resident',
          description: 'Cancel or reschedule booked slots',
        ),
      ),
      GoRoute(
        path: '/directory',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'B9',
          screenTitle: 'Society Directory',
          category: 'B. Resident',
          description: 'Search residents, direct call/chat buttons',
        ),
      ),
      GoRoute(
        path: '/contacts',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'B10',
          screenTitle: 'Important Contacts',
          category: 'B. Resident',
          description: 'Security, plumber, electrician, emergency contacts',
        ),
      ),
      GoRoute(
        path: '/documents',
        builder: (context, state) => const DocumentsScreen(), // B11 / Agreement & Documents
      ),
      GoRoute(
        path: '/family',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'B12',
          screenTitle: 'Family Members',
          category: 'B. Resident',
          description: 'Add, edit, or remove linked family members',
        ),
      ),
      GoRoute(
        path: '/vehicles',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'B13',
          screenTitle: 'My Vehicles',
          category: 'B. Resident',
          description: 'Add vehicles, parking slot mapping, RFID status',
        ),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'B14',
          screenTitle: 'Help & Support',
          category: 'B. Resident',
          description: 'Contact society office, ticketing desk',
        ),
      ),

      // C. Rent, Records & Sharing (C1 - C11)
      GoRoute(
        path: '/records-hub',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'C1',
          screenTitle: 'My Records Hub',
          category: 'C. Records & Sharing',
          description: 'Rent, utility charges, payments, issues summary',
        ),
      ),
      GoRoute(
        path: '/rent',
        builder: (context, state) => const RentPaymentsScreen(), // C2 / Rent & Payments
      ),
      GoRoute(
        path: '/charges-breakup',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'C4',
          screenTitle: 'Charges Breakup',
          category: 'C. Records & Sharing',
          description: 'Maintenance, water, parking, late fee details',
        ),
      ),
      GoRoute(
        path: '/shared-access',
        builder: (context, state) => const ShareWithLandlordScreen(), // C9 / Share with landlord
      ),

      // D. Admin Screens (D1 - D7)
      GoRoute(
        path: '/admin-hr',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'D2',
          screenTitle: 'HR: Users List',
          category: 'D. Admin',
          description: 'Search, filter users by role',
        ),
      ),
      GoRoute(
        path: '/admin-roles',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'D5',
          screenTitle: 'Roles & Permissions',
          category: 'D. Admin',
          description: 'Edit what each role can view and execute',
        ),
      ),
      GoRoute(
        path: '/admin-settings',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'D6',
          screenTitle: 'Society Settings',
          category: 'D. Admin',
          description: 'Society profile, flats, rates, late fee, payment gateway',
        ),
      ),
      GoRoute(
        path: '/admin-audit',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'D7',
          screenTitle: 'Audit Log',
          category: 'D. Admin',
          description: 'All administrative, role and data modifications history',
        ),
      ),

      // E. Manager Screens (E1 - E5)
      GoRoute(
        path: '/manager-complaints',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'E2',
          screenTitle: 'Complaint Queue',
          category: 'E. Manager',
          description: 'Filter complaints, assign priority & dispatch staff',
        ),
      ),
      GoRoute(
        path: '/manager-approvals',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'E4',
          screenTitle: 'Booking Approvals',
          category: 'E. Manager',
          description: 'Approve or reject amenity booking requests & calendar slots',
        ),
      ),
      GoRoute(
        path: '/manager-create-notice',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'E5',
          screenTitle: 'Create Notice',
          category: 'E. Manager',
          description: 'Audience selection, attachments, push notifications',
        ),
      ),

      // F. Accountant Screens (F1 - F5)
      GoRoute(
        path: '/accountant-bills',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'F2',
          screenTitle: 'Generate Monthly Bills',
          category: 'F. Accountant',
          description: 'Batch generate maintenance bills by flat type & due date',
        ),
      ),
      GoRoute(
        path: '/accountant-collections',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'F3',
          screenTitle: 'Collections & Ledger',
          category: 'F. Accountant',
          description: 'Paid, pending, overdue, manual cash entry, send payment reminders',
        ),
      ),
      GoRoute(
        path: '/accountant-expenses',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'F4',
          screenTitle: 'Log Expenses',
          category: 'F. Accountant',
          description: 'Add society expense with physical bill photo proof',
        ),
      ),
      GoRoute(
        path: '/accountant-reports',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'F5',
          screenTitle: 'Financial Reports',
          category: 'F. Accountant',
          description: 'Download PDF or Excel for Collection, Defaulters, Balance Sheet',
        ),
      ),

      // G. Committee Screens (G1 - G4)
      GoRoute(
        path: '/committee-polls',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'G2',
          screenTitle: 'Create Committee Poll',
          category: 'G. Committee',
          description: 'Question, options, target audience, end date setup',
        ),
      ),
      GoRoute(
        path: '/committee-meetings',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'G4',
          screenTitle: 'Meetings & Minutes',
          category: 'G. Committee',
          description: 'Schedule meetings, RSVP tracking, MoM upload',
        ),
      ),

      // H. Security Guard Desk (H1 - H5)
      GoRoute(
        path: '/guard-walkin',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'H2',
          screenTitle: 'Walk-in Entry Gate Desk',
          category: 'H. Security Guard',
          description: 'Capture visitor photo, phone, flat destination, purpose',
        ),
      ),
      GoRoute(
        path: '/guard-approval-status',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'H3',
          screenTitle: 'Live Approval Monitor',
          category: 'H. Security Guard',
          description: 'Real-time resident approval or denial status indicator',
        ),
      ),
      GoRoute(
        path: '/guard-log',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'H4',
          screenTitle: 'Visitor In/Out Logbook',
          category: 'H. Security Guard',
          description: 'Track inside visitors, mark exit timestamp',
        ),
      ),
      GoRoute(
        path: '/guard-vehicle-check',
        builder: (context, state) => const FeaturePlaceholderScreen(
          screenId: 'H5',
          screenTitle: 'Staff & Vehicle Check',
          category: 'H. Security Guard',
          description: 'Daily staff attendance, vehicle check, emergency SOS alert trigger',
        ),
      ),
    ],
  );
});
