import 'package:flutter/material.dart';

class ImageModal extends StatelessWidget {
  final String imageName;
  final String imageUrl;
  final Widget? child;

  const ImageModal({
    Key? key,
    required this.imageName,
    required this.imageUrl,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          scrollable: true,
          titlePadding: const EdgeInsets.only(left: 24, top: 12, right: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(imageName),
                    InkWell(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Container(
                height: size.width * 0.7,
                width: size.width * 0.7,
                decoration: BoxDecoration(
                  border: imageUrl.isEmpty
                      ? Border.all(
                          color: Theme.of(context).errorColor,
                          width: 2,
                        )
                      : null,
                ),
                child: Center(
                  child: imageUrl.isEmpty
                      ? Text(
                          'Image URL not provided',
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}
