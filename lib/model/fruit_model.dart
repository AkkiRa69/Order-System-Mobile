import 'dart:ui';

class FruitModel {
  int? id;
  int? categoryId;
  String? categoryName;
  String name;
  String weight;
  String description;
  String image;
  double price;
  int qty;
  int stock;
  int rate;
  int review;
  Color color;
  bool isFav;

  FruitModel({
    this.id,
    this.categoryId,
    this.categoryName,
    this.name = 'no-name',
    this.description = 'no description',
    this.image = 'assets/icons/grocery.png',
    this.price = 0.00,
    this.rate = 4,
    this.review = 90,
    this.weight = 'no-weight',
    this.color = const Color(0xFFFFE3E2),
    this.qty = 0,
    this.stock = 0,
    this.isFav = false,
  });

  factory FruitModel.fromJson(
    Map<String, dynamic> json, {
    String? baseUrl,
  }) {
    return FruitModel(
      id: _asInt(json['id'] ?? json['product_id']),
      categoryId: _asInt(json['category_id'] ?? json['categoryId']),
      categoryName:
          (json['category_name'] ?? json['categoryName'] ?? json['category'])
              ?.toString(),
      name: (json['name'] ?? json['title'] ?? 'no-name').toString(),
      description: (json['description'] ?? '').toString(),
      image: _resolveImagePath(
        (json['image_url'] ?? json['image'] ?? json['imageUrl'])?.toString(),
        baseUrl: baseUrl,
      ),
      price: _asDouble(json['price']) ?? 0,
      rate: _asInt(json['rate'] ?? json['rating']) ?? 4,
      review: _asInt(json['review'] ?? json['reviews']) ?? 90,
      weight: (json['weight'] ?? json['unit'] ?? json['size'] ?? 'no-weight')
          .toString(),
      color: _parseColor(json['color']) ?? const Color(0xFFFFE3E2),
      qty: _asInt(json['qty'] ?? json['quantity']) ?? 0,
      stock: _asInt(json['stock']) ?? 0,
      isFav: (json['is_fav'] ?? json['isFav']) == true,
    );
  }

  Map<String, dynamic> toApiJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': categoryName ?? '',
      'stock': stock,
    };
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _asDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static Color? _parseColor(dynamic value) {
    if (value == null) return null;
    final raw = value.toString().replaceAll('#', '');
    if (raw.length == 6) {
      final parsed = int.tryParse('FF$raw', radix: 16);
      if (parsed != null) return Color(parsed);
    }
    if (raw.length == 8) {
      final parsed = int.tryParse(raw, radix: 16);
      if (parsed != null) return Color(parsed);
    }
    return null;
  }

  static String _resolveImagePath(String? rawPath, {String? baseUrl}) {
    final value = (rawPath ?? '').trim();
    if (value.isEmpty) return 'assets/icons/grocery.png';

    final lower = value.toLowerCase();
    if (lower.startsWith('http://') ||
        lower.startsWith('https://') ||
        lower.startsWith('asset') ||
        lower.startsWith('data:') ||
        lower.startsWith('file:')) {
      return value;
    }

    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return value;
    }

    final normalizedBase = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final normalizedPath = value.startsWith('/') ? value : '/$value';
    return '$normalizedBase$normalizedPath';
  }
}
