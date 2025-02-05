import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/product_model.dart';
import '../../routes/routes.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    var filteredProducts = ModalRoute.of(context)?.settings.arguments
        as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: const Text("Product Category"),
      ),
      body: filteredProducts.isEmpty
          ? const Center(
              child: Text(
                "Product Unavialable",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                var product = ProductModel.fromJson(filteredProducts[index]);

                return Bounceable(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.detailScreen,
                      arguments: product,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Hero(
                              tag: product.image,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image(
                                  loadingBuilder: _buildLoadingShimmer,
                                  image: NetworkImage("http:${product.image}"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            product.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            "Price: ${product.priceSign}${product.price}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildLoadingShimmer(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
