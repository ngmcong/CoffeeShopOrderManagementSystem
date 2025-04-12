import 'package:coffeeshopordermanagementsystem/bottomnavigationbar.dart';
import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:coffeeshopordermanagementsystem/payment.dart';
import 'package:flutter/material.dart';

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
                ? 'Total Quantity: ${orderItems!.length}'
                : 'Total Quantity: 0',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            orderItems != null && orderItems!.isNotEmpty
                ? 'Total Amount: \$${orderItems!.fold(0.0, (sum, item) => sum + (item.price ?? 0)).toStringAsFixed(2)}'
                : 'Total Amount: \$0.00',
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
                            Text(
                              product.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                'Price: \$${product.price?.toStringAsFixed(2)}'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentPage(),
            ),
          );
        },
        child: const Icon(Icons.payment),
      ),
    );
  }
}
