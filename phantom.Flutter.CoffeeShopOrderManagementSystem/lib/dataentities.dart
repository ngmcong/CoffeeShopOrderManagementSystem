import 'package:flutter/material.dart';

String httpAddress = "http://localhost:8001/api";
BuildContext? rootContext;
String demoImageUrl =
    'https://static.vecteezy.com/system/resources/thumbnails/041/643/200/small_2x/ai-generated-a-cup-of-coffee-and-a-piece-of-coffee-bean-perfect-for-food-and-beverage-related-designs-or-promoting-cozy-moments-png.png';

class Product {
  final int id;
  final String name;
  final double price;
  int qty = 1;
  double get total => price * qty;
  String? imageUrl;

  Product({required this.id, required this.name, required this.price});

  static Future<Product> fromJson(item) async {
    Product product = Product(
      id: item['id'],
      name: item['name'],
      price: item['price'].toDouble(),
    );
    product.imageUrl = item['imageUrl'];
    return product;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
    };
  }
}

enum ShopTableStatus { available, occupied, reserved }

class ShopTable {
  final int id;
  final String name;

  ShopTableStatus status = ShopTableStatus.available;

  ShopTable({required this.id, required this.name});

  static Future<ShopTable> fromJson(item) async {
    return ShopTable(
      id: item['id'],
      name: item['name'],
    );
  }
}
