import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../data/app_state.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isFav = state.isFavorite(widget.product.id);
    final p = widget.product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: const Color(0xFF1B5E20),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const CartScreen())),
                  ),
                  if (state.cart.itemCount > 0)
                    Positioned(
                      right: 6, top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Text('${state.cart.itemCount}',
                            style: const TextStyle(color: Color(0xFF1B5E20), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                onPressed: () => state.toggleFavorite(p.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Фон — зелёный градиент
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Фото товара
                  Padding(
                    padding: const EdgeInsets.only(top: 60, bottom: 10, left: 20, right: 20),
                    child: Image.asset(
                      p.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pedal_bike, size: 100, color: Colors.white.withOpacity(0.5)),
                          const SizedBox(height: 8),
                          Text('Добавьте фото\n${p.imageUrl}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              // Фон всей детайл страницы
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF1F8E9), Color(0xFFFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Цена
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.formattedPrice,
                            style: const TextStyle(color: Color(0xFF1B5E20), fontSize: 28, fontWeight: FontWeight.bold)),
                        if (p.originalPrice != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(p.formattedOriginalPrice,
                                  style: TextStyle(color: Colors.grey[400], fontSize: 15, decoration: TextDecoration.lineThrough)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFF4B4B).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text('-${p.discountPercent.toInt()}%',
                                    style: const TextStyle(color: Color(0xFFFF4B4B), fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Название и рейтинг
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.title,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.4)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber[600], size: 16),
                            Text(' ${p.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF1B5E20).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(p.category,
                                  style: const TextStyle(color: Color(0xFF1B5E20), fontSize: 11, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Описание
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline, color: Color(0xFF1B5E20), size: 18),
                            SizedBox(width: 6),
                            Text('Описание', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(p.description,
                            style: TextStyle(color: Colors.grey[700], height: 1.6, fontSize: 14)),
                      ],
                    ),
                  ),
                  // Магазин
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.storefront, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.shopName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('Официальный магазин', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                          ],
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1B5E20)),
                            foregroundColor: const Color(0xFF1B5E20),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text('В магазин'),
                        ),
                      ],
                    ),
                  ),
                  // Количество
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        const Text('Количество:', style: TextStyle(fontSize: 15)),
                        const Spacer(),
                        _QuantityControl(quantity: _quantity, onChanged: (v) => setState(() => _quantity = v)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -3))],
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => state.toggleFavorite(p.id),
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  for (int i = 0; i < _quantity; i++) state.addToCart(p);
                  setState(() => _added = true);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Добавлено в корзину!'),
                    backgroundColor: const Color(0xFF4CAF50),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'Корзина', textColor: Colors.white,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                    ),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _added ? const Color(0xFF4CAF50) : const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(_added ? '✓ В корзине' : 'В корзину',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  state.addToCart(p);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4B4B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Купить сейчас', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  const _QuantityControl({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btn(Icons.remove, () { if (quantity > 1) onChanged(quantity - 1); }),
        Container(width: 40, alignment: Alignment.center,
            child: Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        _btn(Icons.add, () => onChanged(quantity + 1)),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32, height: 32,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(4)),
      child: Icon(icon, size: 16),
    ),
  );
}