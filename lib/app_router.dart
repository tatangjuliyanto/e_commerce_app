import 'package:e_commerce_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:e_commerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_commerce_app/features/notification/presentation/pages/notification_page.dart';
import 'package:e_commerce_app/features/products/presentation/pages/product_page.dart';
import 'package:e_commerce_app/features/profile/presentation/pages/profile_page.dart';
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
import 'main_navigation.dart';
import 'shared/presentation/bloc/onboarding_bloc.dart';
import 'shared/presentation/pages/onboarding_page.dart';

class AppRouter {
  final AuthBloc authBloc = di.sl<AuthBloc>();

  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    // Auth guard di router level (bukan di widget)
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

      // Tunggu jika loading
      if (authState is AuthLoadingState) {
        return null;
      }

      // Redirect ke login jika belum login
      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }

      // Redirect ke home jika sudah login dan coba akses auth pages
      if (isLoggedIn &&
          isPublicRoute &&
          state.matchedLocation != '/onboarding') {
        return '/home';
      }

      return null;
    },

    routes: [
      // ========================================
      // PUBLIC ROUTES
      // ========================================
      GoRoute(
        path: '/onboarding',
        builder:
            (context, state) => BlocProvider(
              create: (_) => di.sl<OnboardingBloc>(),
              child: OnboardingPage(),
            ),
      ),
      GoRoute(
        path: '/login',
        builder:
            (context, state) => BlocProvider.value(
              value: di.sl<AuthBloc>(),
              child: const LoginPage(),
            ),
      ),
      GoRoute(
        path: '/register',
        builder:
            (context, state) => BlocProvider.value(
              value: di.sl<AuthBloc>(),
              child: const RegisterPage(),
            ),
      ),
      GoRoute(
        path: '/forgot-password',
        builder:
            (context, state) => BlocProvider.value(
              value: di.sl<AuthBloc>(),
              child: const ForgotPasswordPage(),
            ),
      ),

      // ========================================
      // AUTHENTICATED ROUTES WITH SHELL ROUTE
      // ========================================
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          // BlocProvider hanya di-create SEKALI untuk semua tab
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.sl<CartBloc>()),
              BlocProvider(
                create: (_) => di.sl<ProductBloc>()..add(LoadProducts()),
              ),
            ],
            // MainNavigationPage menerima child dari GoRouter
            child: MainNavigation(child: child),
          );
        },
        routes: [
          //  Setiap tab punya route sendiri
          GoRoute(
            path: '/home',
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ProductPage(),
                ),
          ),
          GoRoute(
            path: '/trending',
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const TrendingPage(),
                ),
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const NotificationPage(),
                ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) {
              final authState = context.read<AuthBloc>().state;
              final userId =
                  authState is AuthenticatedState
                      ? authState.user.uid
                      : 'guest';

              return NoTransitionPage(
                key: state.pageKey,
                child: ProfilePage(userId: userId),
              );
            },
          ),
        ],
      ),

      // ========================================
      // OTHER AUTHENTICATED ROUTES (without bottom nav)
      // ========================================
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
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  final Stream stream;

  GoRouterRefreshStream(this.stream) {
    stream.listen((_) {
      notifyListeners();
    });
  }
}
