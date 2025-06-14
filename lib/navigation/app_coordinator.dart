import 'package:e_commerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppCoordinator {
  static String? handelRedirect(
    BuildContext context,
    GoRouterState state,
    AuthState authState,
  ) {
    final isLoggedIn = authState is AuthenticatedState;
    final isGoingToLogin =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';
    if (!isLoggedIn && !isGoingToLogin) {
      return '/login';
    }
    if (isLoggedIn && isGoingToLogin) {
      return '/home';
    }
    return null;
  }

  static void navigateToHome(BuildContext context) {
    context.go('/home');
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
