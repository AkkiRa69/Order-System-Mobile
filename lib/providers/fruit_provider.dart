import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/model/category_model.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/services/local_api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FruitProvider extends ChangeNotifier {
  FruitProvider({LocalApiService? apiService})
      : _apiService = apiService ?? LocalApiService() {
    _initialize();
  }

  final LocalApiService _apiService;

  final List<String> _fallbackCategoryIcons = const [
    'assets/icons/speii.png',
    'assets/icons/pom.png',
    'assets/icons/Beverages.png',
    'assets/icons/cartbag.png',
    'assets/icons/potion.png',
    'assets/icons/Household.png',
    'assets/icons/baby.png',
  ];

  List<CategoryModel> _categories = [];
  List<FruitModel> _fruits = [];
  final Set<int> _favoriteProductIds = {};

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<CategoryModel> get categories => _categories;
  List<FruitModel> get fruitList => _fruits;

  List get cates => _categories.map((c) => [c.name, c.icon]).toList();

  Future<void> _initialize() async {
    await _loadFavorites();
    await fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await fetchCategories(notify: false);
      await fetchProducts(notify: false);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _setError(error);
    }
  }

  Future<void> fetchCategories({bool notify = true}) async {
    try {
      final apiCategories = await _apiService.listCategories();
      _categories = List.generate(apiCategories.length, (index) {
        final category = apiCategories[index];
        return category.copyWith(
          icon: category.icon.isEmpty
              ? _fallbackCategoryIcons[index % _fallbackCategoryIcons.length]
              : category.icon,
        );
      });
      _errorMessage = null;
      if (notify) notifyListeners();
    } catch (error) {
      _setError(error, notify: notify);
      rethrow;
    }
  }

  Future<void> fetchProducts({bool notify = true}) async {
    try {
      final apiProducts = await _apiService.listProducts();
      final categoryNameById = {
        for (final category in _categories)
          if (category.id != null) category.id!: category.name,
      };

      _fruits = apiProducts
          .map(
            (product) => FruitModel(
              id: product.id,
              categoryId: product.categoryId,
              categoryName: product.categoryName ??
                  (product.categoryId != null
                      ? categoryNameById[product.categoryId]
                      : null),
              name: product.name,
              description: product.description,
              image: product.image,
              price: product.price,
              rate: product.rate,
              review: product.review,
              weight: product.weight,
              color: product.color,
              qty: product.qty,
              stock: product.stock,
              isFav: product.id != null &&
                  _favoriteProductIds.contains(product.id),
            ),
          )
          .toList();

      _shoppingCart.removeWhere((cartItem) => !_fruits
          .any((product) => product.id != null && product.id == cartItem.id));
      final existingProductIds = _fruits
          .where((product) => product.id != null)
          .map((product) => product.id!)
          .toSet();
      _favoriteProductIds.removeWhere((id) => !existingProductIds.contains(id));
      _rebuildFavoriteList();
      await _saveFavorites();

      _errorMessage = null;
      if (notify) notifyListeners();
    } catch (error) {
      _setError(error, notify: notify);
      rethrow;
    }
  }

  List<FruitModel> productsByCategoryName(String categoryName) {
    return _fruits
        .where((fruit) =>
            (fruit.categoryName ?? '').toLowerCase() ==
            categoryName.toLowerCase())
        .toList();
  }

  Future<CatalogSearchResult> searchCatalog(String query) async {
    try {
      final result = await _apiService.searchCatalog(query);
      final categoryNameById = {
        for (final category in [..._categories, ...result.categories])
          if (category.id != null) category.id!: category.name,
      };

      final categories = List.generate(result.categories.length, (index) {
        final category = result.categories[index];
        return category.copyWith(
          icon: category.icon.isEmpty
              ? _fallbackCategoryIcons[index % _fallbackCategoryIcons.length]
              : category.icon,
        );
      });

      final products = result.products
          .map(
            (product) => FruitModel(
              id: product.id,
              categoryId: product.categoryId,
              categoryName: product.categoryName ??
                  (product.categoryId != null
                      ? categoryNameById[product.categoryId]
                      : null),
              name: product.name,
              description: product.description,
              image: product.image,
              price: product.price,
              rate: product.rate,
              review: product.review,
              weight: product.weight,
              color: product.color,
              qty: product.qty,
              stock: product.stock,
              isFav: product.id != null &&
                  _favoriteProductIds.contains(product.id),
            ),
          )
          .toList();

      _errorMessage = null;
      return CatalogSearchResult(
        query: result.query,
        categories: categories,
        products: products,
      );
    } catch (error) {
      _setError(error);
      rethrow;
    }
  }

  Future<bool> createCategory({
    required String name,
    String description = '',
    XFile? imageFile,
  }) async {
    try {
      final createdCategory = await _apiService.createCategory(
        {'name': name, 'description': description},
      );
      if (imageFile != null && createdCategory.id != null) {
        await _apiService.updateCategoryImage(createdCategory.id!, imageFile);
      }
      await fetchCategories(notify: false);
      await fetchProducts(notify: false);
      notifyListeners();
      return true;
    } catch (error) {
      _setError(error);
      return false;
    }
  }

  Future<bool> updateCategory({
    required int id,
    required String name,
    String description = '',
    XFile? imageFile,
  }) async {
    try {
      await _apiService.updateCategory(
        id,
        {'name': name, 'description': description},
      );
      if (imageFile != null) {
        await _apiService.updateCategoryImage(id, imageFile);
      }
      await fetchCategories(notify: false);
      await fetchProducts(notify: false);
      notifyListeners();
      return true;
    } catch (error) {
      _setError(error);
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      await _apiService.deleteCategory(id);
      await fetchCategories(notify: false);
      await fetchProducts(notify: false);
      notifyListeners();
      return true;
    } catch (error) {
      _setError(error);
      return false;
    }
  }

  Future<bool> createProduct(FruitModel product, {XFile? imageFile}) async {
    try {
      final createdProduct =
          await _apiService.createProduct(product.toApiJson());
      if (imageFile != null && createdProduct.id != null) {
        await _apiService.updateProductImage(createdProduct.id!, imageFile);
      }
      await fetchProducts(notify: false);
      notifyListeners();
      return true;
    } catch (error) {
      _setError(error);
      return false;
    }
  }

  Future<bool> updateProduct(FruitModel product, {XFile? imageFile}) async {
    if (product.id == null) return false;

    try {
      await _apiService.updateProduct(
        product.id!,
        product.toApiJson(),
      );
      if (imageFile != null) {
        await _apiService.updateProductImage(product.id!, imageFile);
      }
      await fetchProducts(notify: false);
      notifyListeners();
      return true;
    } catch (error) {
      _setError(error);
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _apiService.deleteProduct(id);
      await fetchProducts(notify: false);
      notifyListeners();
      return true;
    } catch (error) {
      _setError(error);
      return false;
    }
  }

  void _setError(Object error, {bool notify = true}) {
    _errorMessage = error.toString();
    if (notify) notifyListeners();
  }

  final List<FruitModel> _shoppingCart = [];
  List<FruitModel> get shoppingCart => _shoppingCart;

  int isCartEmpty() {
    return _shoppingCart.isEmpty ? 1 : 0;
  }

  int cartQuantity(FruitModel fruit) {
    return fruit.qty;
  }

  void addProductToCart(FruitModel fruit) {
    if (fruit.qty <= 0) {
      fruit.qty = 1;
    }
    if (!_shoppingCart.contains(fruit)) {
      _shoppingCart.add(fruit);
    }
    notifyListeners();
  }

  void removeProductFromCart(FruitModel fruit) {
    _shoppingCart.remove(fruit);
    fruit.qty = 0;
    notifyListeners();
  }

  void incrementCartQuantity(FruitModel fruit) {
    if (!_shoppingCart.contains(fruit)) {
      _shoppingCart.add(fruit);
    }
    fruit.qty++;
    notifyListeners();
  }

  void decrementCartQuantity(FruitModel fruit) {
    if (fruit.qty <= 0) return;
    fruit.qty--;
    if (fruit.qty == 0) {
      _shoppingCart.remove(fruit);
    }
    notifyListeners();
  }

  void clearCart() {
    for (final item in _shoppingCart) {
      item.qty = 0;
    }
    _shoppingCart.clear();
    notifyListeners();
  }

  double totalPrice(List<FruitModel> cart) {
    double total = 0;
    for (int i = 0; i < cart.length; i++) {
      total += cart[i].price * cart[i].qty;
    }
    return total;
  }

  final List<FruitModel> _favList = [];
  List<FruitModel> get favList => _favList;

  void addProductToFavorites(FruitModel fruit) {
    if (fruit.id == null) return;
    _favoriteProductIds.add(fruit.id!);
    fruit.isFav = true;
    _rebuildFavoriteList();
    _saveFavorites();
    notifyListeners();
  }

  void removeProductFavorite(FruitModel fruit) {
    if (fruit.id != null) {
      _favoriteProductIds.remove(fruit.id!);
    }
    fruit.isFav = false;
    _rebuildFavoriteList();
    _saveFavorites();
    notifyListeners();
  }

  void _rebuildFavoriteList() {
    _favList
      ..clear()
      ..addAll(_fruits.where(
        (fruit) => fruit.id != null && _favoriteProductIds.contains(fruit.id),
      ));
  }

  Future<File> _favoriteFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/favorite_product_ids.json');
  }

  Future<void> _loadFavorites() async {
    try {
      final file = await _favoriteFile();
      if (!await file.exists()) return;
      final content = await file.readAsString();
      if (content.trim().isEmpty) return;
      final decoded = jsonDecode(content);
      if (decoded is List) {
        _favoriteProductIds
          ..clear()
          ..addAll(decoded.whereType<num>().map((value) => value.toInt()));
      }
    } catch (_) {
      // Ignore persisted-data errors to avoid blocking app startup.
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final file = await _favoriteFile();
      await file.writeAsString(jsonEncode(_favoriteProductIds.toList()));
    } catch (_) {
      // Ignore persisted-data errors; favorites remain in-memory.
    }
  }
}
