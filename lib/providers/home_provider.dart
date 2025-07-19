import 'package:flutter/material.dart';
import 'package:mystore_assessment/model/product_model.dart';
import '../services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  List<Product> _products = [];
  int _currentPage = 0;
  final int _limit = 15;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  Map<Product, int> _cart = {};
  Map<Product, int> get cart => _cart;
  List<String> _categories = [];
  Map<String, bool> _hasMoreCategoryItems = {};

  String? _selectedCategory;

  int _categoryCurrentPage = 0;
  final int _limitCategory = 15;
  bool _isCategoryPaginating = false;
  Map<String, List<Product>> _categoryProductsMap = {};

  List<Product> get products {
    if (_selectedCategory != null) {
      return _categoryProductsMap[_selectedCategory] ?? [];
    }
    return _products;
  }

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  int get totalCartItems =>
      _cart.values.fold(0, (sum, quantity) => sum + quantity);
  double get totalCartPrice => _cart.entries.fold(
    0.0,
    (sum, entry) => sum + (entry.key.price * entry.value),
  );
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;

  Future<void> fetchInitialProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPage = 0;
      final fetched = await _homeService.fetchProducts(skip: 0, limit: _limit);
      _products = fetched;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final nextProducts = await _homeService.fetchProducts(
        skip: _currentPage * _limit,
        limit: _limit,
      );
      _products.addAll(nextProducts);
    } catch (e) {
      _error = e.toString();
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    if (_categories.isNotEmpty) return; 

    try {
      final fetched = await _homeService.fetchCategories();
      _categories = ['All', ...fetched];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> filterByCategory(String category) async {
    _isLoading = true;
    _selectedCategory = category;
    _categoryCurrentPage = 0;
    _categoryProductsMap[category] = [];
    _hasMoreCategoryItems[category] = true;
    notifyListeners();

    try {
      final fetched = await _homeService.fetchProductsByCategory(
        category,
        skip: 0,
        limit: _limit,
      );
      _categoryProductsMap[category] = fetched;

      if (fetched.length < _limit) {
        _hasMoreCategoryItems[category] = false;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNextCategoryPage() async {
    if (_isCategoryPaginating || _selectedCategory == null) return;

    _isCategoryPaginating = true;
    notifyListeners();

    try {
      _categoryCurrentPage++;
      final nextProducts = await _homeService.fetchProductsByCategory(
        _selectedCategory!,
        skip: _categoryCurrentPage * _limitCategory,
        limit: _limitCategory,
      );
      _categoryProductsMap[_selectedCategory!]!.addAll(nextProducts);
    } catch (e) {
      _error = e.toString();
    }

    _isCategoryPaginating = false;
    notifyListeners();
  }

  void addToCart(Product product) {
    if (_cart.containsKey(product)) {
      _cart[product] = _cart[product]! + 1;
    } else {
      _cart[product] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    if (_cart.containsKey(product)) {
      _cart.remove(product);
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void clearCategoryFilter() {
    _selectedCategory = null;
    fetchInitialProducts();
    notifyListeners();
  }
}
