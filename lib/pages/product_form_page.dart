import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/image_modal.dart';
import '../models/product.dart';
import '../models/product_list.dart';
import '../utils/text_field_validator.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context)?.settings.arguments as Product?;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      Provider.of<ProductList>(context, listen: false).saveProduct(_formData);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product successfully created!'),
        duration: Duration(seconds: 2),
      ));

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Form'),
        actions: [
          TextButton(
            child: Text(
              'Done',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () => _submitForm(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['name']?.toString(),
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocus),
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: nameValidator,
              ),
              TextFormField(
                initialValue: _formData['price']?.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionFocus),
                onSaved: (price) =>
                    _formData['price'] = double.parse(price ?? '0'),
                validator: priceValidator,
              ),
              TextFormField(
                initialValue: _formData['description']?.toString(),
                decoration: const InputDecoration(labelText: 'Description'),
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_imageUrlFocus),
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
                validator: descriptionValidator,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      decoration:
                          const InputDecoration(labelText: 'Image\'s URL'),
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocus,
                      keyboardType: TextInputType.url,
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl ?? '',
                      validator: imageUrlValidator,
                    ),
                  ),
                  ImageModal(
                    imageName: _formData['name']?.toString() ??
                        'Image loaded from URL',
                    imageUrl: _imageUrlController.text,
                    child: Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: _imageUrlController.text.isEmpty
                          ? const Text('Enter an URL')
                          : FittedBox(
                              fit: BoxFit.contain,
                              child: Image.network(_imageUrlController.text),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? nameValidator(name) {
    final trimmedName = (name ?? '').trim();

    final validations = [
      TextFieldValidator.required('Description', trimmedName),
      TextFieldValidator.minLength('Description', trimmedName, 3),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }

  String? descriptionValidator(description) {
    final trimmedDescription = (description ?? '').trim();

    final validations = [
      TextFieldValidator.required('Description', trimmedDescription),
      TextFieldValidator.minLength('Description', trimmedDescription, 10),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }

  String? priceValidator(price) {
    final trimmedPrice = (price ?? '').trim();

    final validations = [
      TextFieldValidator.required('Price', trimmedPrice),
      TextFieldValidator.greaterThan('Price', trimmedPrice, 0),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }

  String? imageUrlValidator(imageUrl) {
    final trimmedImageUrl = (imageUrl ?? '').trim();

    final validations = [
      TextFieldValidator.required('Image URL', trimmedImageUrl),
      TextFieldValidator.validUrl('Image URL', trimmedImageUrl),
      TextFieldValidator.allowedFileExtensions('Image URL', trimmedImageUrl, [
        '.png',
        '.jpg',
        '.jpeg',
      ]),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }
}
