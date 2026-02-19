import 'package:flutter/material.dart';

import 'product.dart';

class CartItem {
  final Product product;
  final String size;
  final String gender;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    required this.gender,
    this.quantity = 1,
  });
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalPrice {
    double total = 0;
    for (final item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  int get totalItems {
    int total = 0;
    for (final item in _items) {
      total += item.quantity;
    }
    return total;
  }

  void addItem({
    required Product product,
    required String size,
    required String gender,
  }) {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.size == size &&
          item.gender == gender,
    );

    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(
        CartItem(
          product: product,
          size: size,
          gender: gender,
        ),
      );
    }
    notifyListeners();
  }

  void increaseQuantity(int index) {
    if (index < 0 || index >= _items.length) {
      return;
    }
    _items[index].quantity += 1;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (index < 0 || index >= _items.length) {
      return;
    }
    final item = _items[index];
    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class CartScope extends InheritedNotifier<CartModel> {
  const CartScope({
    super.key,
    required CartModel notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static CartModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'No CartScope found in context');
    return scope!.notifier!;
  }
}

