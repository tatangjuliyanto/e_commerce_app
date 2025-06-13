import 'package:e_commerce_app/core/navigation/app_coordinator.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:e_commerce_app/features/auth/presentation/pages/register_page.dart';
import 'package:e_commerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:e_commerce_app/features/product/presentation/bloc/product_event.dart';
import 'package:e_commerce_app/features/product/presentation/pages/product/product_detail_page.dart';
import 'package:e_commerce_app/features/product/presentation/pages/product/product_page.dart';
import 'package:e_commerce_app/injection_container.dart';
import 'package:e_commerce_app/injection_container.dart' as di;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthBloc authBloc = sl<AuthBloc>();

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect:
        (context, state) =>
            AppCoordinator.handelRedirect(context, state, authBloc.state),
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
        path: '/products',
        builder:
            (context, state) => BlocProvider(
              create: (_) => di.sl<ProductBloc>()..add(LoadProducts()),
              child: ProductPage(),
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
