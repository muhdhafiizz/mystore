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

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  int get totalCartItems =>
      _cart.values.fold(0, (sum, quantity) => sum + quantity);
  double get totalCartPrice => _cart.entries.fold(
    0.0,
    (sum, entry) => sum + (entry.key.price * entry.value),
  );

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
}
