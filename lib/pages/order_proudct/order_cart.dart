import 'package:ecommerc_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';

import '../../models/order_model.dart';
import '../../widgets/space_height.dart';
import '../orders/widgets/modal_contact.dart';
import '../orders/widgets/modal_coupon.dart';

class OrdersCart extends StatefulWidget {
  const OrdersCart({super.key});

  @override
  State<OrdersCart> createState() => _OrdersCartState();
}

class _OrdersCartState extends State<OrdersCart> {
  late double screenWidth;
  late double screenHeight;

  bool isOrder = true;
  bool isMarkReciver = false;
  bool isLoading = false;

  var number = '';
  var coupon = '';
  var location = '';
  List<Order> orders = [];

  String formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var selectedItems = arguments['selectedItems'];

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    double subtotal = 0.0;
    double discount = 0.0;
    for (var item in selectedItems) {
      var product = item['product'];
      var quantity = item['quantity'];
      subtotal += product.priceAsDouble * quantity;
    }
    double total = subtotal;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        title: const Text(
          "Orders",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Visibility(
                    visible: isMarkReciver,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      color: Colors.black,
                      child: const Column(
                        children: [
                          Text(
                            "We had received your order, our your customer service will contact you soon. Thanks for shopping with us.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SpaceHeight(),
                  Bounceable(
                    onTap: gotoLocationClick,
                    child: _buildDeliveryLocation(),
                  ),
                  const SpaceHeight(),
                  Bounceable(
                    onTap: showModalNumberClick,
                    child: _buildContactNumber(),
                  ),
                  const SpaceHeight(),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.payment);
                    },
                    child: _buildPayment(),
                  ),
                  const SpaceHeight(),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey.shade300,
                      height: 0,
                    ),
                    itemCount: selectedItems.length,
                    itemBuilder: (context, index) {
                      var item = selectedItems[index];
                      var product = item['product'];
                      var quantity = item['quantity'];
                      var color = item['color'];
                      return Container(
                        color: Colors.white,
                        height: screenHeight * 0.13,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: double.infinity,
                              child: Image.network(
                                "http:${product.image}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "USD ${product.priceSign}${product.price}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    "Color: ${color}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedItems[index]['quantity']++;
                                          });
                                        },
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text("+"),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child:
                                              Center(child: Text("$quantity")),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              if (selectedItems[index]
                                                      ['quantity'] >
                                                  1) {
                                                selectedItems[index]
                                                    ['quantity']--;
                                              }
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text("-"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  const SpaceHeight(),
                  Bounceable(
                    onTap: showModalCouponClick,
                    child: _buildCoupon(),
                  ),
                  const SpaceHeight(),
                  _buildOrderSummary(subtotal, discount, total, selectedItems),
                ],
              ),
            ),
          ),
          const SpaceHeight(),
          _buildBottomPlace(total, selectedItems, arguments),
        ],
      ),
    );
  }

  Widget _buildBottomPlace(double total, List<dynamic> selectedItems,
      Map<String, dynamic> arguments) {
    return SafeArea(
      bottom: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        color: Colors.white,
        child: Row(
          children: [
            if (isOrder)
              Text(
                "USD \$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              )
            else if (isMarkReciver)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PROCESS",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    "${DateFormat('hh:mm a').format(DateTime.now())}, $formattedDate",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "COMPLETED",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${DateFormat('hh:mm a').format(DateTime.now())}, $formattedDate",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            const Spacer(),
            if (isOrder)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(),
                ),
                onPressed: () async {
                  setState(() => isLoading = true);

                  List<int> orderedIndexes = [];

                  for (var item in selectedItems) {
                    var product = item['product'];
                    var quantity = item['quantity'];

                    final newOrder = Order(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      status: "PROCESS",
                      datetime: DateTime.now(),
                      image: product.image,
                      name: product.name,
                      price: product.priceAsDouble * quantity,
                    );

                    await DatabaseHelper().saveOrder(newOrder);
                    orders.add(newOrder);

                    orderedIndexes.add(item['index']);
                  }

                  var removeOrderedItems = arguments['removeOrderedItems'];
                  if (removeOrderedItems != null) {
                    removeOrderedItems(orderedIndexes);
                  }

                  setState(() {
                    isLoading = false;
                    isOrder = false;
                    isMarkReciver = true;
                  });
                },
                child: const Text("PLACE ORDER"),
              )
            else if (isMarkReciver)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black, width: 2),
                  minimumSize: const Size(200, 40),
                  shape: RoundedRectangleBorder(),
                ),
                onPressed: () async {
                  if (orders.isNotEmpty) {
                    final lastOrder = orders.last.copyWith(status: "COMPLETED");

                    await DatabaseHelper().updateOrderStatus(
                      lastOrder.id,
                      "COMPLETED",
                    );

                    setState(() {
                      isMarkReciver = false;
                      orders[orders.length - 1] = lastOrder;
                    });
                  }
                },
                child: const Text("MARK AS RECEIVED"),
              )
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 40),
                  shape: RoundedRectangleBorder(),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.mainScreen,
                    (route) => false,
                  );
                },
                child: const Text("COMPLETED"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryLocation() {
    return _buildItemSection(
      iconPath: "assets/Delivery Scooter@3x.png",
      title: "Delivery Location",
      subtitle:
          location.isEmpty ? "Enter your delivery address" : "📍$location",
    );
  }

  Widget _buildContactNumber() {
    return _buildItemSection(
      iconPath: "assets/Phone@3x.png",
      title: "Contact Number",
      subtitle: number.isEmpty ? "Enter your contact number" : number,
    );
  }

  Widget _buildPayment() {
    return _buildItemSection(
      iconPath: "assets/Cash in Hand@3x.png",
      title: "Payment",
      subtitle: "Cash on Delivery",
    );
  }

  Widget _buildCoupon() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Image.asset(
              "assets/Voucher@3x.png",
              width: screenWidth * 0.07,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Coupon"),
                coupon.isEmpty
                    ? const Text("Enter Code to get discount")
                    : Text(coupon),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal, double discount, double total,
      List<dynamic> selectedItems) {
    int totalItems =
        selectedItems.fold(0, (sum, item) => sum + item['quantity'] as int);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.asset(
                    "assets/Purchase Order@3x.png",
                    width: screenWidth * 0.07,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order Summary ($totalItems items)"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade300,
            height: 1,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Subtotal"),
                    SizedBox(height: 10),
                    Text("Discount"),
                    SizedBox(height: 10),
                    Text("Total"),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("\$${subtotal.toStringAsFixed(2)}"),
                    const SizedBox(height: 10),
                    Text("\$${discount.toStringAsFixed(2)}"),
                    const SizedBox(height: 10),
                    Text("\$${total.toStringAsFixed(2)}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void gotoLocationClick() async {
    var result = await Navigator.pushNamed(
      context,
      Routes.location,
      arguments: location,
    );

    if (result is String) {
      setState(() {
        location = result;
      });
    }
  }

  void showModalNumberClick() async {
    var result = await ContactNumberModalDailog.show(context, number);
    if (result is String) {
      setState(() {
        number = result;
      });
    }
  }

  void showModalCouponClick() async {
    var result = await CouponModalDailog.show(context, coupon);
    if (result is String) {
      setState(() {
        coupon = result;
      });
    }
  }

  Widget _buildItemSection({
    required String iconPath,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Image.asset(
              iconPath,
              width: screenWidth * 0.07,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
