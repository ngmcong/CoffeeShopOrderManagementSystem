import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String httpAddress = "http://localhost:8001/api";
BuildContext? rootContext;
String demoImageUrl =
    'https://static.vecteezy.com/system/resources/thumbnails/041/643/200/small_2x/ai-generated-a-cup-of-coffee-and-a-piece-of-coffee-bean-perfect-for-food-and-beverage-related-designs-or-promoting-cozy-moments-png.png';
var numberFormat = NumberFormat('###,###', 'en_US');
String employeeName = "bmjDom4gc%2BG7sSAx";

class ProductPrice {
  final int id;
  final String name;
  final double price;

  ProductPrice({required this.id, required this.name, required this.price});

  factory ProductPrice.fromJson(item) {
    try {
      return ProductPrice(
        id: item['id'],
        name: item['name'],
        price: item['price']?.toDouble(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing product price: $e');
      }
      throw Exception('Failed to parse product price');
    }
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

class Product {
  final int id;
  final String name;
  double? price;
  int qty = 1;
  double get total => (price ?? 0) * qty;
  String? imageUrl;
  List<String>? option1;
  List<ProductPrice>? prices;
  String? option1Value;
  ProductPrice? selectedPrice;

  Product(
      {required this.id,
      required this.name,
      this.option1,
      required this.prices,
      this.option1Value,
      this.selectedPrice,
      this.qty = 0});

  static Future<Product> fromJson(item) async {
    try {
      var priceList = item['prices']
          ?.map((priceItem) => ProductPrice.fromJson(priceItem))
          .toList()
          .cast<ProductPrice>();
      Product product = Product(
        id: item['id'],
        name: item['name'],
        option1:
            item['option1'] != null ? List<String>.from(item['option1']) : null,
        prices: priceList,
        option1Value: item['option1Value'],
        selectedPrice: item['selectedPrice'] != null
            ? ProductPrice.fromJson(item['selectedPrice'])
            : null,
        qty: item['qty'] ?? 0,
      );
      product.imageUrl = item['imageUrl'];
      return product;
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing prices: $e');
      }
      throw Exception('Failed to parse prices');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'option1Value': option1Value,
      'selectedPrice': selectedPrice?.toJson(),
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
    var itemModel = ShopTable(
      id: item['id'],
      name: item['name'],
    );
    switch (item['status']) {
      case 0:
        itemModel.status = ShopTableStatus.available;
        break;
      case 2:
        itemModel.status = ShopTableStatus.reserved;
        break;
      default:
        itemModel.status = ShopTableStatus.occupied;
    }
    return itemModel;
  }
}

class APIRetVal {
  int code = 0;
  String message = "Thành công";
  Object? data;

  APIRetVal({required this.code, required this.message, this.data});

  factory APIRetVal.fromJson(item) {
    try {
      return APIRetVal(
        code: item['code'],
        message: item['message'],
        data: item['data'],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing product price: $e');
      }
      throw Exception('Failed to parse product price');
    }
  }
}
