import 'package:flutter/material.dart';

class Quantity extends StatefulWidget {
  final int initialQuantity;
  final Function(int) onQuantityChange;

  const Quantity({
    Key? key,
    required this.initialQuantity,
    required this.onQuantityChange,
  }) : super(key: key);

  @override
  State<Quantity> createState() => _QuantityState();
}

class _QuantityState extends State<Quantity> {
  late int quantity;
  final TextEditingController setQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  _incCounter() {
    setState(() {
      quantity += 1;
      widget.onQuantityChange(quantity);
    });
  }

  _decCounter() {
    setState(() {
      if (quantity > 1) {
        quantity -= 1;
        widget.onQuantityChange(quantity);
      }
    });
  }

  _setCounter(int value) {
    setState(() {
      if (quantity > 1) {
        quantity = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * (size.width > 480 ? 0.20 : 0.30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _decCounter(),
              icon: const Icon(Icons.remove),
              color: Colors.white,
            ),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) => showSetQuantityModal(context),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _incCounter(),
              icon: const Icon(Icons.add),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  AlertDialog showSetQuantityModal(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Enter the quantity'),
      content: TextField(
        controller: setQuantityController,
        keyboardType: TextInputType.number,
        decoration:
            const InputDecoration(hintText: 'Enter a quantity greater than 1'),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  var quantity = int.tryParse(setQuantityController.text);

                  if (quantity != null) {
                    _setCounter(quantity);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
