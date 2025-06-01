import 'package:e_commerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:e_commerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:e_commerce_app/features/auth/presentation/pages/register_page.dart';
import 'package:e_commerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:e_commerce_app/features/product/presentation/bloc/product_event.dart';
import 'package:e_commerce_app/features/product/presentation/pages/product_page.dart';
import 'package:e_commerce_app/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = sl<AuthBloc>().state;
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
    },
    routes: [
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
        path: '/product',
        builder:
            (context, state) => BlocProvider.value(
              value: sl<ProductBloc>()..add(LoadProducts()),
              // create: (_) => di.sl<ProductBloc>(),
              child: ProductPage(),
            ),
      ),
    ],
  );
}
