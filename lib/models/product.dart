class Product {
  final int id;
  final String title;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final String category;
  final int sold;
  final int favorites;
  final double rating;
  final bool isFeatured;
  final bool isFlashSale;
  final String? badge;
  final String shopName;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.sold,
    required this.favorites,
    required this.rating,
    this.isFeatured = false,
    this.isFlashSale = false,
    this.badge,
    required this.shopName,
    required this.description,
  });

  double get discountPercent {
    if (originalPrice == null || originalPrice == 0) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  String get formattedPrice => '${price.toStringAsFixed(0)} сом';
  String get formattedOriginalPrice =>
      originalPrice != null ? '${originalPrice!.toStringAsFixed(0)} сом' : '';
}