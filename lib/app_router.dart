import 'package:e_commerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:e_commerce_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:e_commerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_commerce_app/features/cart/presentation/bloc/cart_event.dart';

import 'features/trending/presentation/pages/trending_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/bloc/product_event.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'package:e_commerce_app/injection_container.dart' as di;
import 'package:e_commerce_app/injection_container.dart';
import 'features/products/presentation/pages/product_detail_page.dart';
import 'features/search/search_page.dart';
import 'navigation/presentation/pages/main_navigation_page.dart';
import 'shared/presentation/bloc/onboarding_bloc.dart';
import 'shared/presentation/pages/onboarding_page.dart';

class AppRouter {
  final AuthBloc authBloc = sl<AuthBloc>();
  //TODO: Add to globaly route
  // final CartBloc cartBloc = sl<CartBloc>();

  late final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState is AuthenticatedState;
      final publicRoutes = [
        '/onboarding',
        '/login',
        '/register',
        '/forgot-password',
      ];
      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }

      if (isLoggedIn &&
          (state.matchedLocation == '/onboarding' ||
              state.matchedLocation == '/login' ||
              state.matchedLocation == '/register')) {
        return '/home';
      }
      if (authState is AuthLoadingState) {
        return null;
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
      GoRoute(
        path: '/forgot-password',
        builder:
            (context, state) => BlocProvider.value(
              value: sl<AuthBloc>(),
              child: ForgotPasswordPage(),
            ),
      ),

      //--------------------------------------------------
      // ALL Routes In Home Tab
      //--------------------------------------------------
      GoRoute(
        path: '/home',
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => di.sl<ProductBloc>()..add(LoadProducts()),
                ),
                BlocProvider(create: (_) => di.sl<CartBloc>()),
              ],
              child: MainNavigationPage(),
            ),
      ),
      GoRoute(
        path: '/products/:productId',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.sl<ProductBloc>()),
              BlocProvider(create: (_) => di.sl<CartBloc>()),
            ],
            child: ProductDetailPage(productId: productId),
          );
        },
      ),
      GoRoute(
        path: '/search',
        builder:
            (context, state) => BlocProvider(
              create: (_) => di.sl<ProductBloc>(),
              child: SearchPage(),
            ),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) {
          final authState = context.read<AuthBloc>().state;

          if (authState is AuthenticatedState) {
            return BlocProvider(
              create: (_) => sl<CartBloc>(),
              child: CartPage(userId: authState.user.uid),
            );
          } else {
            // kalau belum login redirect ke login
            return const LoginPage();
          }
        },
      ),

      //--------------------------------------------------
      // ALL Routes in Trending Tab
      //--------------------------------------------------
      GoRoute(
        path: '/trending',
        builder:
            (context, state) => BlocProvider(
              create: (_) => di.sl<ProductBloc>(),
              child: TrendingPage(),
            ),
      ),

      //--------------------------------------------------
      // ALL Routes in Notification Tab
      //--------------------------------------------------
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
