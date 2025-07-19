import 'package:flutter/material.dart';
import 'package:mystore_assessment/widgets/custom_button.dart';
import '../model/product_model.dart';

class CartSummaryProvider extends ChangeNotifier {
  final Map<Product, int> _cart = {};

  Map<Product, int> get cart => _cart;

  int get totalItems => _cart.values.fold(0, (sum, quantity) => sum + quantity);
  double get totalPrice => _cart.entries.fold(
    0.0,
    (sum, entry) => sum + (entry.key.price * entry.value),
  );

  void addItem(Product product) {
    if (_cart.containsKey(product)) {
      _cart[product] = _cart[product]! + 1;
    } else {
      _cart[product] = 1;
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    if (_cart.containsKey(product)) {
      if (_cart[product]! > 1) {
        _cart[product] = _cart[product]! - 1;
      } else {
        _cart.remove(product);
      }
      notifyListeners();
    }
  }


  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void showConfirmationDialog(BuildContext context, VoidCallback onConfirmed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: const Text(
          "Your order has been placed successfully!",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        actions: [
          CustomButton(
            onTap: () {
              Navigator.of(context).pop();
              onConfirmed();
            },
            text: "Okay",
            backgroundColor: Colors.black,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
