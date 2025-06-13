import 'package:flutter/material.dart';
import '../../notification/notification_page.dart';
import '../../product/presentation/pages/product/product_page.dart';
import '../../profile/profile_page.dart';
import '../../trending/trending_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ProductPage(),
    TrendingPage(),
    NotificationPage(),
    ProfilePage(),
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
