import 'dart:convert';

import 'package:coffeeshopordermanagementsystem/bottomnavigationbar.dart';
import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:coffeeshopordermanagementsystem/products.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Future<List<Product>?> _fetchProducts() async {
    final url = Uri.parse(
        '$httpAddress/products/load');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        var products =
            await Future.wait(data.map((item) async => Product.fromJson(item)));
        for (var e in products) {
          e.option1Value = e.option1?.isNotEmpty == true ? e.option1![0] : null;
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
          if (orderItems!.any((p) => p.id == product.id)) {
            // If the product already exists, increase its quantity
            orderItems!.firstWhere((p) => p.id == product.id).qty++;
          } else {
            orderItems!.add(selectedItem);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
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
                        Text('\$${product?.price?.toStringAsFixed(2)}'),
                        Text('Qty: ${product?.qty ?? 0}'),
                        const SizedBox(height: 8.0),
                        Text(
                            'Amount: \$${(product?.price ?? 0 * (product?.qty ?? 0)).toStringAsFixed(2)}'),
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
            onPressed: () {
              Navigator.of(context).pop();
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
