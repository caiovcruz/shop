import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late Order order;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemsHeight = (order.products.length * 25.0) + 10;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? itemsHeight + 80 : 80,
      child: Card(
        child: Column(
          children: [
            ListTile(
              onTap: () => setState(() => _expanded = !_expanded),
              title: Text('R\$${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
              trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: _expanded ? itemsHeight : 0,
              child: ListView(
                children: order.products
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * 0.4,
                              child: Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: size.width * 0.05),
                            SizedBox(
                              width: size.width * 0.2,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${product.quantity}x R\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: size.width * 0.05),
                            SizedBox(
                              width: size.width * 0.2,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'R\$${(product.quantity * product.price).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
