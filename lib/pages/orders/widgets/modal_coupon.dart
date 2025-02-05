// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

class CouponModalDailog {
  CouponModalDailog._();

  static Future show(BuildContext context, String coupon) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CouponOptionModal(
            coupon: coupon,
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class CouponOptionModal extends StatefulWidget {
  String coupon;
  CouponOptionModal({
    super.key,
    required this.coupon,
  });

  @override
  State<CouponOptionModal> createState() => _CouponOptionModalState();
}

class _CouponOptionModalState extends State<CouponOptionModal> {
  var txtCoupon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    txtCoupon.text = widget.coupon;
    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {});
              Navigator.pop(
                context,
                txtCoupon.text,
              );
            },
            child: Container(
              height: 24,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text('Enter coupon code to get Discount'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: TextField(
              autofocus: true,
              controller: txtCoupon,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 50),
              ),
              onPressed: () {
                setState(() {
                  if (txtCoupon.text.trim() == "ANT") {
                    IconSnackBar.show(
                      context,
                      snackBarType: SnackBarType.success,
                      label: "You got Discount 5%",
                      labelTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    );
                  } else if (txtCoupon.text.trim() == "HAPPY NEW YEAR") {
                    IconSnackBar.show(
                      context,
                      snackBarType: SnackBarType.success,
                      label: "You got Discount 10%",
                      labelTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    );
                  } else if (txtCoupon.text.isEmpty) {
                    IconSnackBar.show(
                      context,
                      snackBarType: SnackBarType.alert,
                      label: "Enter coupon code to get Discount",
                      labelTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    IconSnackBar.show(
                      context,
                      snackBarType: SnackBarType.fail,
                      label: "Your Coupon invalid",
                      behavior: SnackBarBehavior.floating,
                      labelTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    );
                  }
                });
                Navigator.pop(
                  context,
                  txtCoupon.text,
                );
              },
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
