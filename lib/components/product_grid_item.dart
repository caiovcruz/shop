import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../models/product.dart';
import '../utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.productDetail,
            arguments: product,
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 5,
                    ),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              GridTileBar(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                title: Text(
                  product.name,
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  'R\$${product.price.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                ),
                trailing: Consumer<Product>(builder: (cxt, product, _) {
                  return IconButton(
                    onPressed: () async {
                      try {
                        await product.toggleFavorite();

                        messenger.showSnackBar(SnackBar(
                          content: Text(product.isFavorite
                              ? 'Product favorited!'
                              : 'Product removed from favorites!'),
                          duration: const Duration(seconds: 2),
                        ));
                      } on HttpException catch (error) {
                        messenger.showSnackBar(SnackBar(
                          content: Text(error.msg),
                          duration: const Duration(seconds: 2),
                        ));
                      }
                    },
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Theme.of(context).colorScheme.secondary,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
