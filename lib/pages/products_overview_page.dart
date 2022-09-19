import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);

    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        leadingWidth: 20,
        title: Search(
          onSearch: provider.onSearchProduct,
        ),
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
      body: ProductGrid(
        showFavoriteOnly: _showFavoriteOnly,
      ),
    );
  }
}
