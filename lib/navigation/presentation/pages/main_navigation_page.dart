import 'package:flutter/material.dart';
import '../../../features/notification/presentation/pages/notification_page.dart';
import '../../../features/products/presentation/pages/product_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/trending/presentation/pages/trending_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  _MainNavigationPagesState createState() => _MainNavigationPagesState();
}

class _MainNavigationPagesState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const ProductPage(),
    const TrendingPage(),
    const NotificationPage(),
    ProfilePage(userId: 'current_user_id'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black54),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up, color: Colors.black54),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.black54),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2, color: Colors.black54),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}
