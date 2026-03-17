import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/welcome/welcome_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/application_screen.dart';
import '../../features/waitlist/waitlist_screen.dart';
import '../../features/onboarding/approved_screen.dart';
import '../../features/onboarding/add_dog_screen.dart';
import '../../features/discovery/discovery_screen.dart';
import '../../features/discovery/discovery_locked_screen.dart';
import '../../features/dog_profile/dog_profile_detail_screen.dart';
import '../../features/dog_profile/edit_dog_screen.dart';
import '../../features/requests/requests_inbox_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/walk_planning/walk_planning_screen.dart';
import '../../features/owner_profile/owner_profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/premium/premium_screen.dart';
import '../widgets/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/application',
        builder: (context, state) => const ApplicationScreen(),
      ),
      GoRoute(
        path: '/waitlist',
        builder: (context, state) => const WaitlistScreen(),
      ),
      GoRoute(
        path: '/approved',
        builder: (context, state) => const ApprovedScreen(),
      ),
      GoRoute(
        path: '/add-dog',
        builder: (context, state) => const AddDogScreen(),
      ),
      GoRoute(
        path: '/edit-dog/:dogId',
        builder: (context, state) => EditDogScreen(
          dogId: state.pathParameters['dogId']!,
        ),
      ),
      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/discover',
            builder: (context, state) => const DiscoveryScreen(),
          ),
          GoRoute(
            path: '/discover/locked',
            builder: (context, state) => const DiscoveryLockedScreen(),
          ),
          GoRoute(
            path: '/requests',
            builder: (context, state) => const RequestsInboxScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const OwnerProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/dog/:dogId',
        builder: (context, state) => DogProfileDetailScreen(
          dogId: state.pathParameters['dogId']!,
        ),
      ),
      GoRoute(
        path: '/chat/:threadId',
        builder: (context, state) => ChatScreen(
          threadId: state.pathParameters['threadId']!,
        ),
      ),
      GoRoute(
        path: '/walk-plan/:threadId',
        builder: (context, state) => WalkPlanningScreen(
          threadId: state.pathParameters['threadId']!,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/premium',
        builder: (context, state) => const PremiumScreen(),
      ),
    ],
  );
});
