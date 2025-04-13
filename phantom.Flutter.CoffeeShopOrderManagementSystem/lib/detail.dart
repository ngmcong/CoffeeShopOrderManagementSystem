import 'dart:convert';

import 'package:coffeeshopordermanagementsystem/bottomnavigationbar.dart';
import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:coffeeshopordermanagementsystem/order.dart';
import 'package:coffeeshopordermanagementsystem/payment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final ShopTable? shopTable;

  const DetailPage({
    super.key,
    this.shopTable,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Product>? orderItems;

  Future<List<Product>> _fetchTableProducts(int tableId) async {
    final url = Uri.parse(
        '$httpAddress/tables/loadproducts/$tableId'); // Replace with your API endpoint
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        var products =
            await Future.wait(data.map((item) async => Product.fromJson(item)));
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    }
    return []; // Return an empty list in case of error
  }

  void _loadProducts() {
    if (widget.shopTable != null) {
      _fetchTableProducts(widget.shopTable!.id).then((products) {
        setState(() {
          orderItems = products;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.shopTable != null ? widget.shopTable!.name : 'Detail Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.shopTable != null
                ? 'Name: ${widget.shopTable!.name}'
                : 'No table selected',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            widget.shopTable != null
                ? 'Status: ${widget.shopTable!.status}'
                : 'Status unavailable',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            orderItems != null && orderItems!.isNotEmpty
                ? 'Total Quantity: ${orderItems!.fold(0.0, (sum, item) => sum + item.qty).toStringAsFixed(0)}'
                : 'Total Quantity: 0',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            orderItems != null && orderItems!.isNotEmpty
                ? 'Total Amount: ${numberFormat.format(orderItems!.fold(0.0, (sum, item) => sum + (item.qty * (item.selectedPrice?.price ?? 0))))} VNĐ'
                : 'Total Amount: 0 VNĐ',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          orderItems != null && orderItems!.isNotEmpty
              ? Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: orderItems!.length,
                    itemBuilder: (context, index) {
                      final product = orderItems![index];
                      return Card(
                        elevation: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              product.imageUrl ?? demoImageUrl,
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              product.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Loại: ${product.option1Value ?? 'Unknown'}'),
                            const SizedBox(height: 8),
                            Text('Số lượng: ${product.qty}'),
                            const SizedBox(height: 8),
                            Text(
                                'Price: ${numberFormat.format(product.selectedPrice?.price)} VNĐ'),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Text(
                  'No items in the order',
                  style: TextStyle(fontSize: 16),
                ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(isEnabledOrder: true),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Order(
                    shopTable: widget.shopTable,
                    onCompleted: () {
                      _loadProducts();
                    },
                  ),
                ),
              );
            },
            heroTag: 'order',
            child: const Icon(Icons.menu_book),
          ),
          const SizedBox(width: 16.0),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentPage(),
                ),
              );
            },
            heroTag: 'payment',
            child: const Icon(Icons.payment),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
