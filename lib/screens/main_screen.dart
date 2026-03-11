import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final screens = [
      const HomeScreen(),
      const FavoritesScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: state.currentTab,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.currentTab,
        onTap: state.setCurrentTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1B5E20),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: state.favorites.isNotEmpty,
              label: Text('${state.favorites.length}'),
              child: const Icon(Icons.favorite_border),
            ),
            activeIcon: Badge(
              isLabelVisible: state.favorites.isNotEmpty,
              label: Text('${state.favorites.length}'),
              child: const Icon(Icons.favorite),
            ),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: state.cart.itemCount > 0,
              label: Text('${state.cart.itemCount}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: state.cart.itemCount > 0,
              label: Text('${state.cart.itemCount}'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Корзина',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
