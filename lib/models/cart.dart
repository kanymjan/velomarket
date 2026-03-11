import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

class Cart {
  final List<CartItem> items = [];

  void addItem(Product product) {
    final idx = items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      items[idx].quantity++;
    } else {
      items.add(CartItem(product: product));
    }
  }

  void removeItem(int productId) {
    items.removeWhere((i) => i.product.id == productId);
  }

  void updateQuantity(int productId, int qty) {
    final idx = items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      if (qty <= 0) {
        items.removeAt(idx);
      } else {
        items[idx].quantity = qty;
      }
    }
  }

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => items.fold(0.0, (sum, i) => sum + i.total);

  void clear() => items.clear();
}
