import 'dart:convert';

import 'package:coffeeshopordermanagementsystem/bottomnavigationbar.dart';
import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:coffeeshopordermanagementsystem/products.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Order extends StatefulWidget {
  final ShopTable? shopTable;
  final void Function() onCompleted;
  final bool isEditing;

  const Order(
      {super.key,
      this.shopTable,
      required this.onCompleted,
      this.isEditing = false});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Future<List<Product>?> _fetchProducts() async {
    final url = Uri.parse('$httpAddress/products/load');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        var products =
            await Future.wait(data.map((item) async => Product.fromJson(item)));
        for (var e in products) {
          e.option1Value = e.option1?.isNotEmpty == true ? e.option1![0] : null;
          e.selectedPrice = e.prices?.isNotEmpty == true ? e.prices![0] : null;
        }
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    }
    return null;
  }

  List<Product>? orderItems;

  Future<void> _showProducts() async {
    var products = await _fetchProducts();
    showDialog(
      context: rootContext!,
      builder: (context) => ProductSelectionDialog(items: products ?? []),
    ).then((selectedItem) {
      if (selectedItem != null) {
        setState(() {
          orderItems ??= [];
          Product product = selectedItem;
          if (product.qty == 0) {
            product.qty = 1;
          }
          if (orderItems!.any((p) =>
              p.id == product.id &&
              p.option1Value == product.option1Value &&
              p.selectedPrice?.price == product.selectedPrice?.price)) {
            // If the product already exists, increase its quantity
            orderItems!.firstWhere((p) => p.id == product.id).qty++;
          } else {
            orderItems!.add(selectedItem);
          }
        });
      }
    });
  }

  Future<void> _saveTableProducts() async {
    final url = Uri.parse(
        '$httpAddress/tables/OccupiedAndOrderning/${widget.shopTable!.id}?employee=$employeeName'); // Replace with your API endpoint
    try {
      var models = await _fetchProductsBody(jsonEncode(orderItems));
      if (widget.isEditing && backup?.isNotEmpty == true) {
        for (var e in backup!) {
          if (models!.any((p) =>
              p.id == e.id &&
              p.option1Value == e.option1Value &&
              p.selectedPrice?.price == e.selectedPrice?.price)) {
            models
                .firstWhere((p) =>
                    p.id == e.id &&
                    p.option1Value == e.option1Value &&
                    p.selectedPrice?.price == e.selectedPrice?.price)
                .qty -= e.qty;
          }
        }
      }
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(models
            ?.map((product) => product.toJson())
            .toList()), // Convert the list of products to JSON
      );
      if (response.statusCode == 200) {
        var responseBody = APIRetVal.fromJson(jsonDecode(response.body));
        if (kDebugMode && responseBody.code == 0) {
          if (kDebugMode) {
            print('Table products saved successfully');
          }
        }
        if (responseBody.code != 0) throw Exception(responseBody.message);
      } else {
        throw Exception('Failed to save table products');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>?> _fetchProductsBody(String body) async {
    final List<dynamic> data = jsonDecode(body);
    var products =
        await Future.wait(data.map((item) async => Product.fromJson(item)));
    return products;
  }

  Future<List<Product>?> _fetchOrderedProducts() async {
    final url = Uri.parse(
        '$httpAddress/tables/loadOrderProducts/${widget.shopTable!.id}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return await _fetchProductsBody(response.body);
      } else {
        throw Exception(
            'Failed to load ordered products with code: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    }
    return null;
  }

  List<Product>? backup = [];
  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _fetchOrderedProducts().then((products) {
        setState(() {
          orderItems = products;
          _fetchProductsBody(jsonEncode(products)).then((value) {
            backup = value;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách món ăn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: orderItems?.length ?? 0,
                itemBuilder: (context, index) {
                  final product = orderItems?[index];
                  return Card(
                    elevation: 4.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          product?.imageUrl ?? demoImageUrl,
                          height: 100,
                          width: 100,
                        ),
                        Text(
                          product?.name ?? 'Unknown Product',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text('Loại: ${product?.option1Value}'),
                        const SizedBox(height: 8.0),
                        Text(
                            'Giá: ${numberFormat.format(product?.selectedPrice?.price ?? 0)}'),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Số lượng: '),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (product!.qty > 1 ||
                                      (widget.isEditing && product.qty == 1)) {
                                    product.qty--;
                                  }
                                });
                              },
                            ),
                            Text('${product?.qty ?? 0}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  product!.qty++;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                            'Tổng tiền: ${numberFormat.format(product?.selectedPrice?.price ?? 0 * (product?.qty ?? 0))}'),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showProducts();
            },
            heroTag: 'add_product',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16.0),
          FloatingActionButton(
            onPressed: () async {
              try {
                await _saveTableProducts();
                widget.onCompleted();
                Navigator.of(rootContext!).pop();
              } catch (e) {
                ScaffoldMessenger.of(rootContext!).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            heroTag: 'save_order',
            child: const Icon(Icons.check),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
