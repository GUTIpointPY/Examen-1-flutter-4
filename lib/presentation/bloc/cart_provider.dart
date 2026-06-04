import 'package:flutter/material.dart';
import '../../data/models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      name: 'Rose Petal Silk Blindfold',
      variant: 'Color: Midnight Black',
      price: 24.99,
      quantity: 1,
      imagePath: 'assets/images/rose_blindfold.png',
    ),
    CartItem(
      id: '2',
      name: 'Scented Soy Massage Candle',
      variant: 'Scent: Vanilla Musk',
      price: 18.50,
      quantity: 2,
      imagePath: 'assets/images/soy_candle.png',
    ),
  ];

  List<CartItem> get items => List.unmodifiable(_items);

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get shipping {
    return _items.isEmpty ? 0.0 : 5.00;
  }

  double get tax {
    if (_items.isEmpty) return 0.0;
    // To match the screenshot precisely (61.99 subtotal -> 4.95 tax):
    // 61.99 * 0.08 = 4.9592. Let's make it match exactly for the initial state.
    // 61.99 * 0.07985 = 4.95. Let's use a standard 8% rate and format it cleanly.
    return double.parse((subtotal * 0.08).toStringAsFixed(2));
  }

  double get total {
    if (_items.isEmpty) return 0.0;
    return subtotal + shipping + tax;
  }

  void incrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void addItem(CartItem item) {
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(item.copyWith(quantity: 1));
    }
    notifyListeners();
  }

  void decrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1 && _items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  /// Removes an item from the cart and returns both the removed item and its original index.
  /// This is useful for AnimatedList to animate the removal.
  MapEntry<int, CartItem>? removeItem(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final removedItem = _items.removeAt(index);
      notifyListeners();
      return MapEntry(index, removedItem);
    }
    return null;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
