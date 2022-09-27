import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../models/product.dart';
import '../models/product_list.dart';
import '../utils/app_routes.dart';
import 'confirmation_dialog.dart';
import 'image_modal.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(
        AppRoutes.productForm,
        arguments: product,
      ),
      leading: ImageModal(
        imageName: product.name,
        imageUrl: product.imageUrl,
        child: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
      ),
      title: Text(product.name),
      subtitle: Text('R\$${product.price.toStringAsFixed(2)}'),
      trailing: IconButton(
        color: Theme.of(context).errorColor,
        icon: const Icon(Icons.delete),
        onPressed: () => showDialog<bool>(
          context: context,
          builder: (ctx) => const ConfirmationDialog(
            warningWidget: Text(
                'Do you really want to remove this product from the catalog?'),
          ),
        ).then((isRemove) async {
          if (isRemove ?? false) {
            try {
              await Provider.of<ProductList>(context, listen: false)
                  .removeProduct(product);

              messenger.showSnackBar(const SnackBar(
                content: Text('Product successfully removed!'),
                duration: Duration(seconds: 2),
              ));
            } on HttpException catch (error) {
              messenger.showSnackBar(SnackBar(
                content: Text(error.msg),
                duration: const Duration(seconds: 2),
              ));
            }
          }
        }),
      ),
    );
  }
}
