import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/product_list.dart';
import 'product_grid_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  const ProductGrid({
    Key? key,
    required this.showFavoriteOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final size = MediaQuery.of(context).size;

    final List<Product> searchedItems = provider.itemsWithFilters(
      showFavoriteOnly: showFavoriteOnly,
    );

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: searchedItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: size.width > 480 ? 3 : 2,
        childAspectRatio: (size.width > 480 ? 4 : 3) / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: searchedItems[index],
        // ignore: prefer_const_constructors
        child: ProductGridItem(),
      ),
    );
  }
}
