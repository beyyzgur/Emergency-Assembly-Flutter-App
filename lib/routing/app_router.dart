// lib/routing/app_router.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/map/presentation/map_screen.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (BuildContext context, GoRouterState state) {
      // Durum hala yükleniyorsa bekle
      if (authState.isLoading) {
        return null;
      }

      final bool isLoggedIn = authState.valueOrNull != null;
      final bool isLoggingIn = state.uri.toString() == '/login';

      if (isLoggedIn) {
        if (isLoggingIn) {
          return '/map';
        }
      } else {
        if (!isLoggingIn) {
          return '/login';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/map', builder: (context, state) => const MapScreen()),
    ],
  );
});
