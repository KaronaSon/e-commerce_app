import 'package:ecommerc_app/models/product_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../data/product_type.dart';

class ListProduct extends StatelessWidget {
  const ListProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              "Product Type",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: productType.length,
              itemBuilder: (context, index) {
                var item = productType[index];
                var product = ProductType.fromJson(item);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.network(
                        product.image,
                        width: 80,
                        height: 80,
                      ),
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
