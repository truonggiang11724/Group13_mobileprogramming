import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String image_url;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.image_url,
  });

  // Phương thức chuyển CartItem thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image_url': image_url,
    };
  }
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future<void> addItem(String productId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('medicines')
          .doc(productId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        if (_items.containsKey(productId)) {
          _items.update(
            productId,
                (existingItem) => CartItem(
              id: existingItem.id,
              name: existingItem.name,
              quantity: existingItem.quantity + 1,
              price: existingItem.price,
                  image_url: existingItem.image_url,
            ),
          );
        } else {
          _items.putIfAbsent(
            productId,
                () => CartItem(
              id: productId,
              name: data['name'],
              quantity: 1,
              price: data['price'],
                  image_url: data['image_url']
            ),
          );
        }
        notifyListeners();
      }
    } catch (e) {
      print('Lỗi khi thêm sản phẩm vào giỏ hàng: $e');
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId) && _items[productId]!.quantity > 1) {
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
              image_url: existingCartItem.image_url,
        ),
      );
      notifyListeners();
    }
  }

  // Phương thức chuyển CartProvider thành List<CartItem>
  List<CartItem> get cartItemList {
    return _items.values.toList();
  }
}
