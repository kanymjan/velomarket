import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../data/products_data.dart';

class AppState extends ChangeNotifier {
  final Cart _cart = Cart();
  final List<int> _favorites = [];
  String _selectedCategory = 'Все';
  String _searchQuery = '';
  int _currentTab = 0;

  Cart get cart => _cart;
  List<int> get favorites => _favorites;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  int get currentTab => _currentTab;

  List<Product> get filteredProducts {
    List<Product> result = sampleProducts;
    if (_selectedCategory != 'Все') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((p) =>
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  List<Product> get flashSaleProducts =>
      sampleProducts.where((p) => p.isFlashSale).toList();

  List<Product> get featuredProducts =>
      sampleProducts.where((p) => p.isFeatured).toList();

  List<Product> get favoriteProducts =>
      sampleProducts.where((p) => _favorites.contains(p.id)).toList();

  bool isFavorite(int productId) => _favorites.contains(productId);

  void toggleFavorite(int productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }

  void addToCart(Product product) {
    _cart.addItem(product);
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cart.removeItem(productId);
    notifyListeners();
  }

  void updateCartQuantity(int productId, int qty) {
    _cart.updateQuantity(productId, qty);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCurrentTab(int tab) {
    _currentTab = tab;
    notifyListeners();
  }
}
