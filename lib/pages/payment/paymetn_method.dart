import 'package:flutter/material.dart';

class PaymetnMethod extends StatefulWidget {
  const PaymetnMethod({super.key});

  @override
  State<PaymetnMethod> createState() => _PaymetnMethodState();
}

class _PaymetnMethodState extends State<PaymetnMethod> {
  late double screenWidth;
  late double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Payment Method"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 20,
                  ),
                  child: Image.asset(
                    "assets/cash 1@3x.png",
                    width: screenWidth * 0.15,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cash on Delivery",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Cash on Delivery",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 20,
                  ),
                  child: Image.asset(
                    "assets/debit/cash 1@3x.png",
                    width: screenWidth * 0.15,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Credit/Debit Card",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Visa, Mastercard, UnionPay",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
