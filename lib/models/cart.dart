import 'dart:math';

import 'package:flutter/material.dart';

import 'cart_item.dart';
import 'product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemsCount => _items.length;

  double get totalAmount {
    double totalAmount = 0;

    _items.forEach((key, cartItem) {
      totalAmount += cartItem.price * cartItem.quantity;
    });

    return totalAmount;
  }

  void addItem(Product product,
      {int? quantity, bool isAbsolutQuantity = false}) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: quantity != null
              ? (isAbsolutQuantity
                  ? quantity
                  : existingItem.quantity + quantity)
              : existingItem.quantity,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantity: quantity ?? 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId, {int? quantity}) {
    if (_items.containsKey(productId)) {
      if (_items[productId]?.quantity == 1) {
        _items.remove(productId);
      } else {
        _items.update(
          productId,
          (existingItem) => CartItem(
            id: existingItem.id,
            productId: existingItem.productId,
            name: existingItem.name,
            quantity: existingItem.quantity - (quantity ?? 1),
            price: existingItem.price,
          ),
        );
      }

      notifyListeners();
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
