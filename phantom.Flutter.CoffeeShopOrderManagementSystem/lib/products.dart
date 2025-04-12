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
              'Chọn món',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Card(
                    // elevation: 2,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image.network(
                        //   widget.items[index].imageUrl ?? demoImageUrl,
                        //   fit: BoxFit.cover,
                        //   height: 140,
                        //   width: 140,
                        // ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.items[index].option1!
                              .map((e) => Column(
                                    children: [
                                      Text(e),
                                      const SizedBox(height: 4),
                                      Radio(
                                        value: e,
                                        groupValue:
                                            widget.items[index].option1Value,
                                        onChanged: (value) {
                                          setState(() {
                                            widget.items[index].option1Value =
                                                value;
                                          });
                                        },
                                        activeColor: Colors.deepPurple,
                                      )
                                    ],
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.items[index].prices!
                              .map((e) => Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Column(
                                    children: [
                                      Text(numberFormat.format(e.price)),
                                      const SizedBox(height: 4),
                                      Radio(
                                        value: e,
                                        groupValue:
                                            widget.items[index].selectedPrice,
                                        onChanged: (value) {
                                          setState(() {
                                            widget.items[index].selectedPrice =
                                                value;
                                          });
                                        },
                                        activeColor: Colors.deepPurple,
                                      ),
                                    ],
                                  )))
                              .toList(),
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, widget.items[index]);
                          },
                          child: const Text('Add'),
                        ),
                      ],
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
