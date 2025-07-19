import 'package:flutter/material.dart';
import 'package:mystore_assessment/providers/login_provider.dart';
import 'package:mystore_assessment/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final user = loginProvider.user;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeProvider.products.isEmpty && !homeProvider.isLoading) {
        homeProvider.fetchInitialProducts();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingText(user?['firstName'], user?['lastName']),
              const SizedBox(height: 16),
              Expanded(child: _buildProductList(context, homeProvider)),
            ],
          ),
        ),
      ),
    );
  }
  

  Widget _buildGreetingText(String? firstName, String? lastName) {
    final fullName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hi,", style: TextStyle(fontSize: 16)),
            Text(
              fullName.isEmpty ? 'User' : fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        CircleAvatar(child: Icon(Icons.shopping_bag_outlined, color: Colors.black,), backgroundColor: Colors.grey[200],),
      ],
    );
  }

  Widget _buildProductList(BuildContext context, HomeProvider provider) {
    if (provider.isLoading && provider.products.isEmpty) {
      return Center(child: _buildShimmerLoading());
    }

    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!provider.isLoadingMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          provider.fetchNextPage();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: provider.products.length + (provider.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= provider.products.length) {
            return Center(child: _buildShimmerLoadingPagination());
          }

          final product = provider.products[index];

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.thumbnail,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () => provider.addToCart(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ShimmerLoadingWidget(width: 150, height: 60),
                ),
              ),
              const SizedBox(height: 8),
              ShimmerLoadingWidget(width: 300, height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoadingPagination() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ShimmerLoadingWidget(width: 150, height: 60),
            ),
          ),
          const SizedBox(height: 8),
          ShimmerLoadingWidget(width: 300, height: 50),
        ],
      ),
    );
  }
}
