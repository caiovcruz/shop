import 'dart:math';

import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import 'product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  String _search = '';

  void onSearchProduct(String value) {
    _search = value;
    notifyListeners();
  }

  List<Product> get items => [..._items];

  int get itemsCount => _items.length;

  List<Product> itemsWithFilters({bool showFavoriteOnly = false}) {
    var searchedItems = items;

    if (showFavoriteOnly) {
      searchedItems = searchedItems.where((prod) => prod.isFavorite).toList();
    }

    if (_search.isNotEmpty) {
      searchedItems = searchedItems
          .where((prod) =>
              prod.name.toLowerCase().contains(_search.toLowerCase()) ||
              prod.description.toLowerCase().contains(_search.toLowerCase()))
          .toList();
    }

    return searchedItems;
  }

  void saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final newProduct = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    hasId ? updateProduct(newProduct) : addProduct(newProduct);
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }

    notifyListeners();
  }
}
