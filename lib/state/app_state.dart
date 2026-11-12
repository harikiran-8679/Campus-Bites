
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Represents one food item.
class CartItem {
  final String name;
  final String description;
  final int price;
  final double rating;
  final String emoji;
  int quantity;

  CartItem({
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.emoji,
    this.quantity = 1,
  });

  CartItem copy() {
    return CartItem(
      name: name,
      description: description,
      price: price,
      rating: rating,
      emoji: emoji,
      quantity: quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'emoji': emoji,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      emoji: json['emoji'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  int get itemTotal => price * quantity;
}

// Represents a completed order.
class CampusOrder {
  final String id;
  final List<CartItem> items;
  final int totalAmount;
  final String orderType;
  final String paymentMethod;
  final String status;
  final DateTime placedAt;

  CampusOrder({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderType,
    required this.paymentMethod,
    required this.status,
    required this.placedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderType': orderType,
      'paymentMethod': paymentMethod,
      'status': status,
      'placedAt': placedAt.toIso8601String(),
    };
  }

  factory CampusOrder.fromJson(Map<String, dynamic> json) {
    return CampusOrder(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(
        Map<String, dynamic>.from(item),
      ))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toInt(),
      orderType: json['orderType'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      placedAt: DateTime.parse(json['placedAt'] as String),
    );
  }
}

// Shared application data.
class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  static const String _cartKey = 'campusbites_cart';
  static const String _ordersKey = 'campusbites_orders';

  final List<CartItem> cartItems = [];
  final List<CampusOrder> orders = [];

  // Load saved cart and orders.
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Restore cart.
    final savedCart = prefs.getString(_cartKey);

    if (savedCart != null) {
      try {
        final List<dynamic> decodedCart = jsonDecode(savedCart);

        cartItems
          ..clear()
          ..addAll(
            decodedCart.map(
                  (item) => CartItem.fromJson(
                Map<String, dynamic>.from(item),
              ),
            ),
          );
      } catch (e) {
        cartItems.clear();
        await prefs.remove(_cartKey);
      }
    }

    // Restore order history.
    final savedOrders = prefs.getString(_ordersKey);

    if (savedOrders != null) {
      try {
        final List<dynamic> decodedOrders = jsonDecode(savedOrders);

        orders
          ..clear()
          ..addAll(
            decodedOrders.map(
                  (order) => CampusOrder.fromJson(
                Map<String, dynamic>.from(order),
              ),
            ),
          );
      } catch (e) {
        orders.clear();
        await prefs.remove(_ordersKey);
      }
    }
  }

  // Save cart.
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedCart = jsonEncode(
      cartItems.map((item) => item.toJson()).toList(),
    );

    await prefs.setString(_cartKey, encodedCart);
  }

  // Save order history.
  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedOrders = jsonEncode(
      orders.map((order) => order.toJson()).toList(),
    );

    await prefs.setString(_ordersKey, encodedOrders);
  }

  void addToCart({
    required String name,
    required String description,
    required int price,
    required double rating,
    required String emoji,
    int quantity = 1,
  }) {
    final index = cartItems.indexWhere(
          (item) => item.name == name,
    );

    if (index != -1) {
      cartItems[index].quantity += quantity;
    } else {
      cartItems.add(
        CartItem(
          name: name,
          description: description,
          price: price,
          rating: rating,
          emoji: emoji,
          quantity: quantity,
        ),
      );
    }

    _saveCart();
    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (index < 0 || index >= cartItems.length) return;

    if (quantity <= 0) {
      cartItems.removeAt(index);
    } else {
      cartItems[index].quantity = quantity;
    }

    _saveCart();
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index < 0 || index >= cartItems.length) return;

    cartItems.removeAt(index);

    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();

    _saveCart();
    notifyListeners();
  }

  int get subtotal {
    return cartItems.fold(
      0,
          (sum, item) => sum + item.itemTotal,
    );
  }

  int deliveryFeeFor(String orderType) {
    if (cartItems.isEmpty ||
        orderType.toLowerCase() == 'pickup' ||
        subtotal >= 300) {
      return 0;
    }

    return 30;
  }

  int get deliveryFee => deliveryFeeFor('Delivery');

  int get packagingFee {
    return cartItems.isEmpty ? 0 : 10;
  }

  int totalAmountFor(String orderType) {
    return subtotal +
        deliveryFeeFor(orderType) +
        packagingFee;
  }

  int get totalAmount => totalAmountFor('Delivery');

  // Save an order and clear the cart.
  CampusOrder placeOrder({
    required String orderType,
    required String paymentMethod,
  }) {
    final order = CampusOrder(
      id: '#CB${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: cartItems.map((item) => item.copy()).toList(),
      totalAmount: totalAmountFor(orderType),
      orderType: orderType,
      paymentMethod: paymentMethod,
      status: 'Preparing',
      placedAt: DateTime.now(),
    );

    orders.insert(0, order);
    cartItems.clear();

    _saveCart();
    _saveOrders();

    notifyListeners();
    return order;
  }
}
