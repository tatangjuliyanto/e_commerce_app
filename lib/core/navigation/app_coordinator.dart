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
      return '/products';
    }
    return null;
  }

  static void navigateToProducts(BuildContext context) {
    context.go('/products');
  }

  static void navigateToProductDetails(BuildContext context, String productId) {
    debugPrint(
      'AppCoordinator: Navigating to product details for ID: $productId',
    );

    // Validate productId before navigation
    if (productId.isEmpty) {
      debugPrint('Error: Empty product ID');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid product ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      context.go('/products/$productId');
    } catch (e) {
      debugPrint('Navigation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static void navigateToRegister(BuildContext context) {
    context.go('/register');
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
