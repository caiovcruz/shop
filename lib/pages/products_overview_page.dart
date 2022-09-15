import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/product_item.dart';
import '../data/dummy_data.dart';
import '../models/product.dart';
import '../models/product_list.dart';

class ProductsOverviewPage extends StatelessWidget {
  const ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts = provider.items;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) =>
            ProductItem(product: loadedProducts[index]),
      ),
    );
  }
}
