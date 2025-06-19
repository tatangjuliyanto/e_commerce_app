import 'package:e_commerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:e_commerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:e_commerce_app/features/auth/presentation/pages/register_page.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_event.dart';
import 'package:e_commerce_app/features/products/presentation/pages/cart/cart_page.dart';
import 'package:e_commerce_app/navigation/presentation/pages/main_navigation_page.dart';
import 'package:e_commerce_app/features/products/presentation/pages/product/product_detail_page.dart';
import 'package:e_commerce_app/injection_container.dart';
import 'package:e_commerce_app/injection_container.dart' as di;
import 'package:e_commerce_app/shared/presentation/bloc/onboarding_bloc.dart';
import 'package:e_commerce_app/shared/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/products/presentation/pages/search/search_page.dart';

class AppRouter {
  final AuthBloc authBloc = sl<AuthBloc>();

  late final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState is AuthenticatedState;
      final isGoingToLogin =
          state.matchedLocation == '/onboarding' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      if (!isLoggedIn &&
          !isGoingToLogin &&
          state.matchedLocation != '/onboarding') {
        return '/login';
      }
      if (isLoggedIn && isGoingToLogin) {
        return '/home';
      }
      return null;
    },
    routes: [
      //--------------------------------------------------
      // Onboarding Route
      //--------------------------------------------------
      GoRoute(
        path: '/onboarding',
        builder:
            (context, state) => BlocProvider(
              create: (_) => di.sl<OnboardingBloc>(),
              child: OnboardingPage(),
            ),
      ),
      //--------------------------------------------------
      // Authentication Routes
      //--------------------------------------------------
      GoRoute(
        path: '/login',
        builder:
            (context, state) =>
                BlocProvider.value(value: sl<AuthBloc>(), child: LoginPage()),
      ),
      GoRoute(
        path: '/register',
        builder:
            (context, state) => BlocProvider.value(
              value: sl<AuthBloc>(),
              child: RegisterPage(),
            ),
      ),

      //--------------------------------------------------
      // Product Routes
      //--------------------------------------------------
      GoRoute(
        path: '/home',
        builder:
            (context, state) => BlocProvider(
              create: (_) => di.sl<ProductBloc>()..add(LoadProducts()),
              child: MainNavigationPage(),
            ),
      ),
      GoRoute(
        path: '/products/:productId',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return BlocProvider(
            create: (_) => sl<ProductBloc>(),
            child: ProductDetailPage(productId: productId),
          );
        },
      ),
      GoRoute(
        path: '/cart',
        builder:
            (context, state) => BlocProvider(
              create: (_) => sl<ProductBloc>(),
              child: const CartPage(),
            ),
      ),
      GoRoute(
        path: '/search',
        builder:
            (context, state) => BlocProvider(
              create: (_) => di.sl<ProductBloc>(),
              child: SearchPage(),
            ),
      ),
    ],
  );

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

class GoRouterRefreshStream extends ChangeNotifier {
  final Stream stream;

  GoRouterRefreshStream(this.stream) {
    stream.listen((_) {
      notifyListeners();
    });
  }
}
