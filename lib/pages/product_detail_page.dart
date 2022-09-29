import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/quantity.dart';

import '../components/badge.dart';
import '../exceptions/http_exception.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../utils/app_routes.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int itemQuantity = 1;

  _changeItemQuantity(int quantity) {
    setState(() {
      itemQuantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product;
    final cart = Provider.of<Cart>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'R\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Quantity(
              initialQuantity: itemQuantity,
              onQuantityChange: _changeItemQuantity,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart),
              label: const Text(
                'BUY',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                try {
                  await cart.addItem(product, quantity: itemQuantity);

                  if (mounted) {
                    messenger.showSnackBar(SnackBar(
                      content:
                          const Text('Product successfully added to cart!'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        textColor: Theme.of(context).colorScheme.primary,
                        onPressed: () => cart.removeSingleItem(
                          product.id,
                          quantity: itemQuantity,
                        ),
                      ),
                    ));
                  }
                } on HttpException catch (error) {
                  messenger.showSnackBar(SnackBar(
                    content: Text(error.msg),
                    duration: const Duration(seconds: 2),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
