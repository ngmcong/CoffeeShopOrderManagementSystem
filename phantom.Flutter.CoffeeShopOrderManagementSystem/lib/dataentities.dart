class Product {
  final int id;
  final String name;
  final double price;
  int qty = 1;
  double get total => price * qty;

  Product({required this.id, required this.name, required this.price});
}

class ShopTable {
  final int id;
  final String name;

  ShopTable({required this.id, required this.name});
}
