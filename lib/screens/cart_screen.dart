import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../services/audio_service.dart';
import '../models/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    final items = context.read<AppState>().cart.items;
    _selected.addAll(items.map((i) => i.product.id));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = state.cart.items;

    final selectedItems =
    items.where((i) => _selected.contains(i.product.id)).toList();
    final total = selectedItems.fold(0.0, (sum, i) => sum + i.total);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Корзина (${state.cart.itemCount})',
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                state.clearCart();
                setState(() => _selected.clear());
              },
              child: const Text('Очистить',
                  style: TextStyle(color: Color(0xFF1B5E20))),
            ),
        ],
      ),
      body: items.isEmpty
          ? _buildEmpty()
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _CartItemCard(
                    item: items[index],
                    isSelected: _selected.contains(items[index].product.id),
                    onToggleSelect: () {
                      setState(() {
                        final id = items[index].product.id;
                        if (_selected.contains(id)) {
                          _selected.remove(id);
                        } else {
                          _selected.add(id);
                        }
                      });
                    },
                    onQuantityChange: (qty) {
                      state.updateCartQuantity(
                          items[index].product.id, qty);
                    },
                    onRemove: () {
                      setState(() =>
                          _selected.remove(items[index].product.id));
                      state.removeFromCart(items[index].product.id);
                    },
                  ),
            ),
          ),
          _buildBottomBar(context, total, selectedItems.length),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Корзина пуста',
              style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          const SizedBox(height: 8),
          Text('Добавьте товары, чтобы начать покупки',
              style: TextStyle(color: Colors.grey[400])),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('За покупками'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, double total, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: _selected.length ==
                context.read<AppState>().cart.items.length,
            activeColor: const Color(0xFF1B5E20),
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selected.addAll(context
                      .read<AppState>()
                      .cart
                      .items
                      .map((i) => i.product.id));
                } else {
                  _selected.clear();
                }
              });
            },
          ),
          const Text('Все'),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Итого: ${total.toStringAsFixed(0)} сом',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1B5E20),
                ),
              ),
              Text(
                '$count товаров',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: count == 0
                ? null
                : () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Оформление заказа'),
                  content: Text(
                      'Товаров: $count\nСумма: ¥${total.toStringAsFixed(1)}\n\nСпасибо за покупку!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AppState>().clearCart();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ Заказ оформлен!'),
                            backgroundColor: Color(0xFF4CAF50),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                      ),
                      child: const Text('Оформить',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Оформить',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool isSelected;
  final VoidCallback onToggleSelect;
  final ValueChanged<int> onQuantityChange;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.isSelected,
    required this.onToggleSelect,
    required this.onQuantityChange,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF1B5E20).withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            activeColor: const Color(0xFF1B5E20),
            onChanged: (_) => onToggleSelect(),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(width: 80, height: 80, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 6),
                Text(
                  'с ${item.product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color(0xFF1B5E20),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _qBtn(Icons.remove, () {
                      if (item.quantity > 1) {
                        onQuantityChange(item.quantity - 1);
                      } else {
                        onRemove();
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _qBtn(Icons.add, () => onQuantityChange(item.quantity + 1)),
                    const Spacer(),
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(Icons.delete_outline,
                          color: Colors.grey[400], size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }
}