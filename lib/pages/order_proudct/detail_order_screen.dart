import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Order Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "http:${order.image}",
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              order.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Order ID: ${order.id}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "Status: ${order.status}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    order.status == "COMPLETED" ? Colors.green : Colors.amber,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Total Price: USD \$${order.price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Ordered on: ${DateFormat('MMM dd, yyyy hh:mm a').format(order.datetime)}",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back to Orders"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
