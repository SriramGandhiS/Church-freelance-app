import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../shared/widgets/main_shell.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/about/about_screen.dart';
import '../../features/home/region_details_screen.dart';
import '../../features/churches/church_directory_screen.dart';
import '../../features/churches/church_detail_screen.dart';
import '../../features/bishop/bishop_detail_screen.dart';
import '../../features/events/events_list_screen.dart';
import '../../features/events/event_detail_screen.dart';
import '../../features/members/members_screen.dart';
import '../../features/members/member_detail_screen.dart';
import '../../features/synod/synod_screen.dart';
import '../../features/donations/donate_screen.dart';
import '../../features/donations/donation_qr_screen.dart';
import '../../features/donations/donation_success_screen.dart';
import '../../features/prayer/prayer_request_screen.dart';
import '../../features/gallery/gallery_screen.dart';
import '../../features/gallery/album_detail_screen.dart';
import '../../features/gallery/photo_viewer_screen.dart';
import '../../features/contact/contact_screen.dart';
import '../../features/register_pastor/join_intro_screen.dart';
import '../../features/register_pastor/registration_form_screen.dart';
import '../../features/register_pastor/registration_payment.dart';
import '../../features/register_pastor/registration_success_screen.dart';
import '../../features/pastor/pastor_dashboard.dart';
import '../../features/pastor/pastor_meetings_screen.dart';
import '../../features/pastor/pastor_profile_screen.dart';
import '../../features/admin/admin_dashboard.dart';
import '../../features/admin/admin_approvals_screen.dart';
import '../../features/admin/admin_pastor_detail.dart';
import '../../features/admin/admin_add_event.dart';
import '../../features/admin/admin_add_update.dart';
import '../../features/admin/admin_gallery_upload.dart';
import '../../features/admin/application_admin_login.dart';
import '../../features/admin/application_admin_dashboard.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/support/support_screen.dart';

final _rootKey  = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final loc  = state.uri.path;
    const free = ['/splash', '/onboarding', '/login', '/register', '/join', '/home',
                  '/about', '/churches', '/bishop', '/events', '/members', '/synod', '/donate',
                  '/prayer', '/gallery', '/contact', '/support', '/admin-login', '/app-admin'];
    final isFree = free.any((p) => loc == p) || loc.startsWith('/join') || loc.startsWith('/churches/') || loc.startsWith('/events/') || loc.startsWith('/members/') || loc.startsWith('/gallery/') || loc.startsWith('/donate/') || loc.startsWith('/region') || loc.startsWith('/admin-login') || loc.startsWith('/app-admin');
    if (user == null && !isFree) return '/login';
    return null;
  },
  routes: [
    GoRoute(path: '/splash',       builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding',   builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login',        builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register',     builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/join',         builder: (_, __) => const JoinIntroScreen()),
    GoRoute(path: '/join/form',    builder: (_, __) => const RegistrationFormScreen()),
    GoRoute(path: '/join/payment', builder: (_, s)  => RegistrationPaymentScreen(data: s.extra as Map<String, dynamic>? ?? {})),
    GoRoute(path: '/join/success', builder: (_, s)  => RegistrationSuccessScreen(data: s.extra as Map<String, dynamic>? ?? {})),

    ShellRoute(
      navigatorKey: _shellKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home',    builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/synod',   builder: (_, __) => const SynodScreen()),
        GoRoute(path: '/support', builder: (_, __) => const SupportScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),

    GoRoute(path: '/about',  builder: (_, __) => const AboutScreen()),
    GoRoute(
      path: '/region',
      builder: (_, s) {
        final data = s.extra as Map<String, dynamic>? ?? {};
        return RegionDetailsScreen(
          dioceseName: data['diocese'] as String? ?? 'Diocese',
          districtName: data['district'] as String? ?? 'All',
          validDistricts: (data['districts'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? <String>[],
        );
      },
    ),
    GoRoute(path: '/churches',          builder: (_, __) => const ChurchDirectoryScreen()),
    GoRoute(path: '/churches/:churchId',builder: (_, s)  => ChurchDetailScreen(churchId: s.pathParameters['churchId']!)),
    GoRoute(path: '/bishop', builder: (_, __) => const BishopDetailScreen()),
    GoRoute(path: '/events', builder: (_, __) => const EventsListScreen()),
    GoRoute(path: '/events/:id', builder: (_, s) => EventDetailScreen(eventId: s.pathParameters['id']!)),
    GoRoute(path: '/members', builder: (_, __) => const MembersScreen()),
    GoRoute(path: '/members/:id', builder: (_, s) => MemberDetailScreen(pastorId: s.pathParameters['id']!)),
    GoRoute(path: '/donate',  builder: (_, __) => const DonateScreen()),
    GoRoute(path: '/donate/qr', builder: (_, s) => DonationQRScreen(
      amount: double.tryParse(s.uri.queryParameters['amount'] ?? '0') ?? 0,
      purpose: s.uri.queryParameters['purpose'] ?? 'General Offering',
    )),
    GoRoute(path: '/donate/success', builder: (_, __) => const DonationSuccessScreen()),
    GoRoute(path: '/prayer',  builder: (_, __) => const PrayerRequestScreen()),
    GoRoute(path: '/gallery', builder: (_, __) => const GalleryScreen()),
    GoRoute(path: '/gallery/photo', builder: (_, s) => PhotoViewerScreen(photoUrl: Uri.decodeComponent(s.uri.queryParameters['url'] ?? ''))),
    GoRoute(path: '/gallery/:albumId', builder: (_, s) => AlbumDetailScreen(albumId: s.pathParameters['albumId']!)),
    GoRoute(path: '/contact', builder: (_, __) => const ContactScreen()),

    GoRoute(path: '/pastor/home',     builder: (_, __) => const PastorDashboard()),
    GoRoute(path: '/pastor/meetings', builder: (_, __) => const PastorMeetingsScreen()),
    GoRoute(path: '/pastor/profile',  builder: (_, __) => const PastorProfileScreen()),

    GoRoute(path: '/admin/home',           builder: (_, __) => const AdminDashboard()),
    GoRoute(path: '/admin/approvals',      builder: (_, __) => const AdminApprovalsScreen()),
    GoRoute(path: '/admin/approvals/:id',  builder: (_, s) => AdminPastorDetailScreen(pastorId: s.pathParameters['id']!)),
    GoRoute(path: '/admin/add-event',      builder: (_, __) => const AdminAddEventScreen()),
    GoRoute(path: '/admin/add-update',     builder: (_, __) => const AdminAddUpdateScreen()),
    GoRoute(path: '/admin/gallery-upload', builder: (_, __) => const AdminGalleryUploadScreen()),

    GoRoute(path: '/admin-login', builder: (_, __) => const ApplicationAdminLoginScreen()),
    GoRoute(path: '/app-admin',   builder: (_, __) => const ApplicationAdminDashboard()),
  ],
);
