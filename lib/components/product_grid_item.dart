import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

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
                    onPressed: () => product.toggleFavorite(),
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
