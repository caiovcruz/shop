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

  List<Product> itemsWithFilters({bool showFavoriteOnly = false}) {
    var searchedItems = items;

    if (showFavoriteOnly) {
      searchedItems = searchedItems.where((prod) => prod.isFavorite).toList();
    }

    if (_search.isNotEmpty) {
      searchedItems = searchedItems
          .where((prod) =>
              prod.title.toLowerCase().contains(_search.toLowerCase()) ||
              prod.description.toLowerCase().contains(_search.toLowerCase()))
          .toList();
    }

    return searchedItems;
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.remove(product);
    notifyListeners();
  }
}
