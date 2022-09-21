import 'package:flutter/material.dart';

class CartTotal extends StatelessWidget {
  final double total;

  const CartTotal({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'R\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.headline6?.color,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
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
