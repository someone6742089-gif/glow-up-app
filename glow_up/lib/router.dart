import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/dashboard_screen.dart';
import 'features/habits/habits_screen.dart';
import 'features/looks/looks_screen.dart';
import 'features/charisma/charisma_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/premium/premium_screen.dart';
import 'features/premium/payment_success_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/signup';
    
    if (session == null && !isLoggingIn) return '/login';
    if (session != null && isLoggingIn) return '/home/index';
    
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/index', // Logic handled in top-level redirect
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/premium',
      builder: (context, state) => const PremiumScreen(),
    ),
    GoRoute(
      path: '/payment_success',
      builder: (context, state) => const PaymentSuccessScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => HomeScreen(child: child),
      routes: [
        GoRoute(
          path: '/home/index',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/home/habits',
          builder: (context, state) => const HabitsScreen(),
        ),
        GoRoute(
          path: '/home/looks',
          builder: (context, state) => const LooksScreen(),
        ),
        GoRoute(
          path: '/home/charisma',
          builder: (context, state) => const CharismaScreen(),
        ),
        GoRoute(
          path: '/home/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
