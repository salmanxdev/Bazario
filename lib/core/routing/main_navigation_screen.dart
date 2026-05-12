import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/feed/presentation/screens/home_feed_screen.dart';
import '../../features/shop/presentation/screens/shop_explore_screen.dart';
import '../../features/live/presentation/screens/live_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/shop/presentation/screens/orders_cart_screen.dart';
import '../../features/shop/presentation/screens/add_post_live_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(currentUserProvider);
    final user = userState.value;
    final isSeller = user?.role == 'seller';

    // Removed ProfileScreen from Bottom Nav as requested -> Restored!
    final buyerScreens = [
      const HomeFeedScreen(),      // Home
      const ShopExploreScreen(),   // Shop
      const LiveScreen(),          // Live
      const HomeFeedScreen(),      // Feed (Search)
      const OrdersCartScreen(),    // Orders & Cart
      const ChatListScreen(),      // Chat
      const ProfileScreen(),       // Profile
    ];

    final sellerScreens = [
      const HomeFeedScreen(),      // Home
      const ShopExploreScreen(),   // Shop
      const LiveScreen(),          // Live
      const HomeFeedScreen(),      // Feed (Search)
      const AddPostLiveScreen(),   // Create (+)
      const OrdersCartScreen(),    // Orders & Cart
      const ChatListScreen(),      // Chat
      const ProfileScreen(),       // Profile
    ];

    final screens = isSeller ? sellerScreens : buyerScreens;

    if (_currentIndex >= screens.length) {
      _currentIndex = 0;
    }

    final buyerNavItems = [
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.house_fill), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.bag_fill), label: 'Shop'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.tv_circle_fill), label: 'Live'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: 'Feed'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.cart_fill), label: 'Orders'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_2_fill), label: 'Chat'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_solid), label: 'Profile'),
    ];

    final sellerNavItems = [
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.house_fill), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.bag_fill), label: 'Shop'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.tv_circle_fill), label: 'Live'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: 'Feed'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.add_circled_solid), label: 'Create'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.cart_fill), label: 'Orders'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_2_fill), label: 'Chat'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_solid), label: 'Profile'),
    ];

    final navItems = isSeller ? sellerNavItems : buyerNavItems;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xff6C63FF),
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
          items: navItems,
        ),
      ),
    );
  }
}
