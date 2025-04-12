String httpAddress = "http://localhost:8001/api";

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

class ShopTable {
  final int id;
  final String name;

  ShopTable({required this.id, required this.name});

  static Future<ShopTable> fromJson(item) async {
    return ShopTable(
      id: item['id'],
      name: item['name'],
    );
  }
}
