import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../models/cart.dart';
import '../models/cart_item.dart';
import '../models/product_list.dart';
import 'quantity.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductList>(context, listen: false)
        .items
        .firstWhereOrNull((prod) => prod.id == cartItem.productId);

    _changeItemQuantity(int quantity) {
      if (product != null) {
        Provider.of<Cart>(context, listen: false).addItem(
          product,
          quantity: quantity,
          isAbsolutQuantity: true,
        );
      }
    }

    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      onDismissed: (_) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(cartItem.productId);
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: product?.imageUrl != null
                  ? Image.network(product!.imageUrl)
                  : const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white,
                    ),
            ),
            title: Text(cartItem.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Unit: R\$${cartItem.price.toStringAsFixed(2)}'),
                Text(
                  'Total: R\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.black),
                )
              ],
            ),
            trailing: Quantity(
              initialQuantity: cartItem.quantity,
              onQuantityChange: _changeItemQuantity,
            ),
          ),
        ),
      ),
    );
  }
}
