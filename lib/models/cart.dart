import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../utils/constants.dart';
import 'cart_item.dart';
import 'product.dart';

class Cart with ChangeNotifier {
  final String _token;
  final String _userId;
  Map<String, CartItem> _items;

  Cart([
    this._token = '',
    this._userId = '',
    this._items = const {},
  ]);

  Map<String, CartItem> get items => {..._items};

  int get itemsCount => _items.length;

  double get totalAmount {
    double totalAmount = 0;

    _items.forEach((key, cartItem) {
      totalAmount += cartItem.price * cartItem.quantity;
    });

    return totalAmount;
  }

  Future<void> loadCart() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.cartsBaseUrl}/$_userId.json?auth=$_token'),
    );

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((cartItemId, cartItemData) {
      _items.putIfAbsent(
        cartItemData['productId'],
        () => CartItem(
          id: cartItemId,
          productId: cartItemData['productId'],
          name: cartItemData['name'],
          quantity: cartItemData['quantity'],
          price: cartItemData['price'],
        ),
      );
    });

    notifyListeners();
  }

  Future<void> addItem(Product product,
      {int? quantity, bool isAbsolutQuantity = false}) async {
    if (_items.containsKey(product.id)) {
      await _updateItem(product, quantity, isAbsolutQuantity);
    } else {
      await _addItem(product, quantity, isAbsolutQuantity);
    }
    notifyListeners();
  }

  Future<void> _updateItem(
      Product product, int? quantity, bool isAbsolutQuantity) async {
    final item = _items[product.id]!;

    final response = await http.patch(
      Uri.parse(
        '${Constants.cartsBaseUrl}/$_userId/${item.id}.json?auth=$_token',
      ),
      body: jsonEncode({
        'productId': item.productId,
        'name': item.name,
        'quantity': quantity != null
            ? (isAbsolutQuantity ? quantity : item.quantity + quantity)
            : item.quantity,
        'price': item.price,
      }),
    );

    _items.update(
      product.id,
      (existingItem) => CartItem(
        id: existingItem.id,
        productId: existingItem.productId,
        name: product.name,
        quantity: quantity != null
            ? (isAbsolutQuantity ? quantity : existingItem.quantity + quantity)
            : existingItem.quantity,
        price: product.price,
      ),
    );

    if (response.statusCode >= 400) {
      _items[product.id] = item;
      throw HttpException(
        msg: 'Could not add product to cart. Try again later!',
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> _addItem(
      Product product, int? quantity, bool isAbsolutQuantity) async {
    final response = await http.post(
      Uri.parse('${Constants.cartsBaseUrl}/$_userId.json?auth=$_token'),
      body: jsonEncode({
        'productId': product.id,
        'name': product.name,
        'quantity': quantity ?? 1,
        'price': product.price,
      }),
    );

    final id = jsonDecode(response.body)['name'];

    _items.putIfAbsent(
      product.id,
      () => CartItem(
        id: id,
        productId: product.id,
        name: product.name,
        quantity: quantity ?? 1,
        price: product.price,
      ),
    );

    if (response.statusCode >= 400) {
      _items.remove(product.id);
      throw HttpException(
        msg: 'Could not update cart\'s item. Try again later!',
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> removeItem(String productId) async {
    if (_items.containsKey(productId)) {
      final item = _items[productId]!;

      final response = await http.delete(
        Uri.parse(
          '${Constants.cartsBaseUrl}/$_userId/${item.id}.json?auth=$_token',
        ),
      );

      _items.remove(productId);

      if (response.statusCode >= 400) {
        _items.putIfAbsent(productId, () => item);
        throw HttpException(
          msg: 'Something went wrong on removing cart\'s item. Try again later',
          statusCode: response.statusCode,
        );
      }

      notifyListeners();
    }
  }

  Future<void> removeSingleItem(String productId, {int? quantity}) async {
    if (_items.containsKey(productId)) {
      if (_items[productId]?.quantity == 1) {
        _items.remove(productId);
      } else {
        final item = _items[productId]!;

        final response = await http.patch(
          Uri.parse(
            '${Constants.cartsBaseUrl}/$_userId/${item.id}.json?auth=$_token',
          ),
          body: jsonEncode({
            'quantity': item.quantity - (quantity ?? 1),
          }),
        );

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

        if (response.statusCode >= 400) {
          _items[productId] = item;
          throw HttpException(
            msg:
                'Something went wrong on updating cart\'s item. Try again later!',
            statusCode: response.statusCode,
          );
        }
      }

      notifyListeners();
    }
  }

  Future<void> updateCart(List<Product> products) async {
    for (var cartItem in _items.values.toList()) {
      final product =
          products.firstWhereOrNull((prod) => prod.id == cartItem.productId);

      try {
        if (product != null) {
          if (cartItem.name != product.name ||
              cartItem.price != product.price) {
            addItem(product);
          }
        } else {
          removeItem(cartItem.productId);
        }
      } on HttpException catch (error) {
        throw HttpException(
            msg: 'Something went wrong updating cart. Try again later!',
            statusCode: error.statusCode);
      }
    }
  }

  Future<void> clear() async {
    final items = _items;

    final response = await http.delete(
      Uri.parse('${Constants.cartsBaseUrl}/$_userId.json?auth=$_token'),
    );

    _items.clear();

    if (response.statusCode >= 400) {
      _items = items;
      throw HttpException(
        msg: 'Something went wrong on cleaning cart. Try again later',
        statusCode: response.statusCode,
      );
    }

    notifyListeners();
  }
}
