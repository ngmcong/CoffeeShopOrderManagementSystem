import 'dart:convert';

import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final ShopTable? shopTable;
  const PaymentPage({super.key, required this.shopTable});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'Tiền mặt';

  void _onPaymentMethodChanged(String? value) {
    setState(() {
      _selectedPaymentMethod = value!;
    });
  }

  Future<void> _processPayment() async {
    final url = Uri.parse(
        '$httpAddress/tables/payment/${widget.shopTable!.id}'); // Replace with your API endpoint
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(employeeName),
      );
      if (response.statusCode == 200) {
        var responseBody = APIRetVal.fromJson(jsonDecode(response.body));
        if (kDebugMode && responseBody.code == 0) {
          if (kDebugMode) {
            print('Table products saved successfully');
          }
        }
        if (responseBody.code != 0) throw Exception(responseBody.message);
        goHomePage();
      } else {
        throw Exception('Failed to save table products');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment processed error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tổng tiền cần thanh toán: 122.000 VNĐ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Số tiền được nhận:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '122.000 VNĐ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      // Handle amount change logic here
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Hình thức:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Cà thẻ'),
              leading: Radio<String>(
                value: 'Cà thẻ',
                groupValue: _selectedPaymentMethod,
                onChanged: _onPaymentMethodChanged,
              ),
            ),
            ListTile(
              title: const Text('Momo'),
              leading: Radio<String>(
                value: 'Momo',
                groupValue: _selectedPaymentMethod,
                onChanged: _onPaymentMethodChanged,
              ),
            ),
            ListTile(
              title: const Text('Tiền mặt'),
              leading: Radio<String>(
                value: 'Tiền mặt',
                groupValue: _selectedPaymentMethod,
                onChanged: _onPaymentMethodChanged,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _processPayment,
                child: const Text('Thanh toán'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
