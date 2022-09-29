import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/quantity.dart';

import '../components/badge.dart';
import '../components/image_modal.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.name),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: product.id,
                    child: FadeInImage(
                      placeholder: const AssetImage(
                          'assets/images/image-coming-soon.png'),
                      image: NetworkImage(product.imageUrl),
                      imageErrorBuilder: (ctx, error, stackTrace) =>
                          Image.asset('assets/images/image-coming-soon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  ImageModal(
                    imageName: product.name,
                    imageUrl: product.imageUrl,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0, 0.8),
                          end: Alignment(0, 0),
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.6),
                            Color.fromRGBO(0, 0, 0, 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            automaticallyImplyLeading: false,
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ],
              ),
              child: BackButton(onPressed: () => Navigator.of(context).pop()),
            ),
            actions: [
              Consumer<Cart>(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.cart),
                    icon: const Icon(Icons.shopping_cart),
                  ),
                ),
                builder: (ctx, cart, child) => Badge(
                  value: cart.itemsCount.toString(),
                  child: child!,
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                              content: const Text(
                                  'Product successfully added to cart!'),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'UNDO',
                                textColor:
                                    Theme.of(context).colorScheme.primary,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
