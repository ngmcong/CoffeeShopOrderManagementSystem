import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:flutter/material.dart';

class ProductSelectionDialog extends StatefulWidget {
  final List<Product> items;

  const ProductSelectionDialog({super.key, required this.items});

  @override
  State<ProductSelectionDialog> createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select an Item',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, widget.items[index]);
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Card(
                        elevation: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              widget.items[index].imageUrl ?? demoImageUrl,
                              fit: BoxFit.cover,
                              height: 260,
                              width: 260,
                            ),
                            Text(
                              widget.items[index].name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Text(
                            //   '\$${widget.items[index].price?.toStringAsFixed(2)}',
                            //   textAlign: TextAlign.center,
                            //   style: const TextStyle(
                            //     fontSize: 12,
                            //     color: Colors.white70,
                            //   ),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: widget.items[index].option1!
                                  .map((e) => Column(
                                        children: [
                                          Text(e),
                                          const SizedBox(height: 4),
                                          Radio(
                                            value: e,
                                            groupValue: widget
                                                .items[index].option1Value,
                                            onChanged: (value) {
                                              setState(() {
                                                widget.items[index]
                                                    .option1Value = value;
                                              });
                                            },
                                            activeColor: Colors.deepPurple,
                                          )
                                        ],
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
