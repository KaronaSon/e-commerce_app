import 'package:ecommerc_app/data/coupons_code.dart';
import 'package:ecommerc_app/models/product_model.dart';
import 'package:ecommerc_app/pages/orders/widgets/modal_contact.dart';
import 'package:ecommerc_app/pages/orders/widgets/modal_coupon.dart';
import 'package:ecommerc_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late double screenWidth;
  late double screenHeight;
  int itemCount = 1;
  var number = '';
  String coupon = '';
  var location = '';

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var product = arguments['product'] as ProductModel;
    var colornameProduct = arguments['color'] as String;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    double subtotal = product.priceAsDouble * itemCount;
    double discount = calculateDiscount(subtotal, coupon);
    double total = subtotal - discount;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Orders",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Bounceable(
                    onTap: gotoLocationClick,
                    child: _buildDeliveryLocation(),
                  ),
                  const SizedBox(height: 12),
                  Bounceable(
                    onTap: showModalNumberClick,
                    child: _buildContactNumber(),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.payment);
                    },
                    child: _buildPayment(),
                  ),
                  const SizedBox(height: 12),
                  Container(
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
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                "Color: $colornameProduct",
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
                                        itemCount++;
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
                                      child: Center(child: Text("$itemCount")),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(
                                        () {
                                          if (itemCount > 1) {
                                            itemCount--;
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
                  ),
                  const SizedBox(height: 12),
                  Bounceable(
                    onTap: showModalCouponClick,
                    child: _buildCoupon(),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderSummary(subtotal, discount, total),
                ],
              ),
            ),
          ),
          _buildBottomPlace(total),
        ],
      ),
    );
  }

  double calculateDiscount(double subtotal, String couponCode) {
    var selectedCoupon = coupons.firstWhere(
      (c) => c['code'] == couponCode,
      orElse: () => {},
    );
    if (selectedCoupon.isNotEmpty) {
      return subtotal * (selectedCoupon['value'] / 100);
    }

    return 0.0;
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

  Widget _buildBottomPlace(double total) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "USD \$${total.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(),
              minimumSize: Size(screenWidth * 0.3, screenHeight * 0.055),
            ),
            onPressed: () {},
            child: const Text(
              "PLACE ORDER",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal, double discount, double total) {
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
                      Text("Order Summary ($itemCount item)"),
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
