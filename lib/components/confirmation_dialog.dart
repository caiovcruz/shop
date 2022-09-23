import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final Widget warningWidget;

  const ConfirmationDialog({
    Key? key,
    required this.warningWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: warningWidget,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('NO'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('YES'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
