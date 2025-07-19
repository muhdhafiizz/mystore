import 'package:flutter/material.dart';
import 'package:mystore_assessment/providers/cart_summary_provider.dart';
import 'package:mystore_assessment/providers/home_provider.dart';
import 'package:mystore_assessment/widgets/empty_list.dart';
import 'package:provider/provider.dart';
import '../model/product_model.dart';

class CartSummaryView extends StatelessWidget {
  const CartSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final cartProvider = Provider.of<CartSummaryProvider>(context);
    final cart = cartProvider.cart;


    return Scaffold(
      body: SafeArea(
        child: cart.isEmpty
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: _topNav(context),
                  ),
                  const Expanded(
                    child: Center(child: EmptyList(text: "Your cart is empty.")),
                  ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: _topNav(context),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final entry = cart.entries.elementAt(index);
                        final Product product = entry.key;
                        final int quantity = entry.value;

                        return ListTile(
                          leading: Image.network(
                            product.thumbnail,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.title),
                          subtitle: Text("Quantity: $quantity"),
                          trailing: Text(
                            "\$${(product.price * quantity).toStringAsFixed(2)}",
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              cartProvider.showConfirmationDialog(context, () {
                                cartProvider.clearCart();
                                homeProvider.clearCart();
                                Navigator.of(
                                  context,
                                ).popUntil((route) => route.isFirst);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              "Place Order",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget _topNav(BuildContext context) {
  return Row(
    children: [
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
      SizedBox(width: 10,),
      Text("Your Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
    ],
  );
}
