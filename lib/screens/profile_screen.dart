import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF1B5E20),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(Icons.person,
                              size: 40, color: Color(0xFF1B5E20)),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Пользователь VeloShop KG',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ID: VM_123456',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 12),
                // Stats row
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      _statItem('${state.cart.itemCount}', 'В корзине'),
                      _divider(),
                      _statItem('${state.favorites.length}', 'Избранное'),
                      _divider(),
                      _statItem('0', 'Заказов'),
                      _divider(),
                      _statItem('0', 'Отзывов'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Order status
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Мои заказы',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _orderStatus(Icons.payment_outlined, 'Оплата'),
                          _orderStatus(Icons.local_shipping_outlined, 'Доставка'),
                          _orderStatus(Icons.inventory_2_outlined, 'Получение'),
                          _orderStatus(Icons.star_border_outlined, 'Отзывы'),
                          _orderStatus(Icons.replay_outlined, 'Возврат'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Menu items
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _menuItem(Icons.location_on_outlined, 'Мои адреса', context),
                      _menuItem(Icons.credit_card, 'Способы оплаты', context),
                      _menuItem(Icons.discount_outlined, 'Мои купоны', context),
                      _menuItem(Icons.history, 'История просмотров', context),
                      _menuItem(Icons.headset_mic_outlined, 'Поддержка', context),
                      _menuItem(Icons.settings_outlined, 'Настройки', context),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 30, color: Colors.grey[200]);
  }

  Widget _orderStatus(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 26, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
