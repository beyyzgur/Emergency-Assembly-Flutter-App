import 'package:go_router/go_router.dart';
import '../features/auth/login_screen.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/login', 
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);