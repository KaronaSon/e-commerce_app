import 'package:ecommerc_app/pages/order_proudct/detail_order_screen.dart';
import 'package:ecommerc_app/widgets/space_height.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';

import '../../models/order_model.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  List<Order> orders = [];
  bool isLoading = true;

  String formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final savedOrders = await DatabaseHelper().getOrders();
      setState(() {
        orders = savedOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error loading orders: $e");
    }
  }

  Future<void> _deleteOrder(String id) async {
    try {
      await DatabaseHelper().deleteOrder(id);
      _loadOrders();
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  void _confirmDelete(String orderId) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Delete Order"),
        content: const Text("Are you sure you want to delete this order?"),
        actions: [
          CupertinoDialogAction(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Delete"),
            onPressed: () {
              Navigator.pop(context);
              _deleteOrder(orderId);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: const Text("My Orders"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orders.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => SpaceHeight(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];

                    return Dismissible(
                      key: Key(order.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        _confirmDelete(order.id);
                        return false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: Bounceable(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => OrderDetailsScreen(
                                  order: order,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "#${order.id}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              DateFormat('hh:mm a, MMM dd yyyy')
                                                  .format(order.datetime),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\$${order.price}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "${order.status}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: order.status ==
                                                          "COMPLETED"
                                                      ? Colors.blue
                                                      : Colors.amber,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 20,
                                  thickness: 0.3,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        "https:${order.image}",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            "assets/images/placeholder.png",
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    "No orders found",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
    );
  }
}
