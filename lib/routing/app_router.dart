import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../firebase_options.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/checkin/presentation/check_in_screen.dart';
import '../features/map/presentation/map_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/needs/presentation/needs_screen.dart';
import 'scaffold_with_nav_bar.dart';

final firebaseInitProvider = FutureProvider<void>((ref) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
});

final authStateProvider = StreamProvider<User?>((ref) async* {
  await ref.watch(firebaseInitProvider.future);
  yield* FirebaseAuth.instance.authStateChanges();
});

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    _sub = ref.listen<AsyncValue<User?>>(authStateProvider, (_, next) {
      value = next;
      notifyListeners();
    }, fireImmediately: true);
  }

  late final ProviderSubscription<AsyncValue<User?>> _sub;
  AsyncValue<User?> value = const AsyncValue.loading();

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = _AuthRefreshNotifier(ref);
  ref.onDispose(auth.dispose);

  final router = GoRouter(
    initialLocation: '/map',
    refreshListenable: auth,
    redirect: (BuildContext context, GoRouterState state) {
      if (auth.value.isLoading) return null;

      final bool isLoggedIn = auth.value.valueOrNull != null;
      final bool isAuthPage =
          state.uri.path == '/login' || state.uri.path == '/register';

      if (!isLoggedIn) return isAuthPage ? null : '/login';
      if (isAuthPage) return '/map';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/checkin',
        builder: (context, state) => const CheckInScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
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
  ref.onDispose(router.dispose);
  return router;
});
