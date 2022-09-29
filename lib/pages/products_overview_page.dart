import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/utils/app_routes.dart';

import '../components/badge.dart';
import '../components/product_grid.dart';
import '../components/search.dart';
import '../models/cart.dart';
import '../models/product_list.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  Future<void> _refreshProducts(BuildContext context) async {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts();
  }

  @override
  void initState() {
    super.initState();

    _refreshProducts(context).then((_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });

    Provider.of<Cart>(context, listen: false).loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Search(
          hintText: 'Search on Shop',
          onSearch: (search) => provider.onSearchProduct(search),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.filter_alt),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Only favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('All'),
              ),
            ],
            onSelected: (FilterOptions selectedFilter) => setState(() {
              _showFavoriteOnly = selectedFilter == FilterOptions.favorites;
            }),
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cart),
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: ProductGrid(
                showFavoriteOnly: _showFavoriteOnly,
              ),
            ),
    );
  }
}
