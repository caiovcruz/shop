import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../models/cart.dart';
import '../models/order_list.dart';

class CartTotal extends StatefulWidget {
  final Cart cart;

  const CartTotal({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<CartTotal> createState() => _CartTotalState();
}

class _CartTotalState extends State<CartTotal> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Chip(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: Text(
                'R\$${widget.cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.headline6?.color,
                ),
              ),
            ),
            const Spacer(),
            _isLoading
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: widget.cart.itemsCount > 0
                        ? () async {
                            setState(() => _isLoading = true);

                            await Provider.of<OrderList>(
                              context,
                              listen: false,
                            ).addOrder(widget.cart);

                            widget.cart.clear();

                            messenger.showSnackBar(const SnackBar(
                              content: Text('Order successfully placed!'),
                              duration: Duration(seconds: 2),
                            ));

                            setState(() => _isLoading = false);
                          }
                        : null,
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('BUY'),
                  ),
          ],
        ),
      ),
    );
  }
}
