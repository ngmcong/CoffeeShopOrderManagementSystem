import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'Credit Card';

  void _onPaymentMethodChanged(String? value) {
    setState(() {
      _selectedPaymentMethod = value!;
    });
  }

  void _processPayment() {
    // Add payment processing logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Payment processed using $_selectedPaymentMethod')),
    );

    // Navigate to Home
    Navigator.of(rootContext!).popUntil((route) => route.isFirst);
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
