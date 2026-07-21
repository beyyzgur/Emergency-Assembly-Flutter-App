import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/map/presentation/map_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/needs/presentation/needs_screen.dart';
import 'scaffold_with_nav_bar.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/map',
    redirect: (BuildContext context, GoRouterState state) {
      if (authState.isLoading) return null;

      final bool isLoggedIn = authState.valueOrNull != null;
      final bool isLoggingIn = state.uri.toString() == '/login';

      if (!isLoggedIn) return isLoggingIn ? null : '/login';
      if (isLoggingIn) return '/map';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          // Sekme 1: Harita
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/needs',
                builder: (context, state) => const NeedsScreen(),
              ),
            ],
          ),
          // Sekme 3: Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
