import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/bloc/cart_state.dart';

class MainNavigation extends StatelessWidget {
  final Widget child; // ✅ Child dari GoRouter (current tab page)

  const MainNavigation({super.key, required this.child});

  // Calculate index berdasarkan URL current
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/trending')) return 1;
    if (location.startsWith('/notifications')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  // Navigate menggunakan GoRouter (bukan setState)
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/trending');
        break;
      case 2:
        context.go('/notifications');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Listen auth changes untuk auto logout
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          context.go('/login');
        }
      },
      child: Scaffold(
        // ✅ Child dari GoRouter (tab content)
        body: child,
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        if (cartState is CartLoaded) {
          final cartItemCount = cartState.cartEntity.items.length;
        }
        return BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Trending',
            ),
            BottomNavigationBarItem(
              icon: _buildNotificationIcon(3),
              label: 'Notifications',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_2),
              label: 'Profile',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.black54,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => _onItemTapped(context, index),
        );
      },
    );
  }

  Widget _buildNotificationIcon(int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.notifications),
        if (count > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
