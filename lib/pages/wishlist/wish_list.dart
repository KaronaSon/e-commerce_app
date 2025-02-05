import 'package:ecommerc_app/helpers/favorite_helper.dart';
import 'package:ecommerc_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: Center(
            child: Bounceable(
              scaleFactor: 0.5,
              onTap: () {},
              child: const Text(
                "L Y",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Billa",
                ),
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 1,
              height: 30,
              color: Colors.grey,
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.search,
                    );
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search anything you like",
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Bounceable(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.cart,
                );
              },
              child: SvgPicture.asset(
                "assets/cart 02.svg",
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<FavoritesManager>(
        builder: (context, favoritesManager, child) {
          var favoriteProducts = favoritesManager.favorites;

          if (favoriteProducts.isEmpty) {
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/favorite.jpg",
                    height: 200,
                    width: 200,
                    colorBlendMode: BlendMode.color,
                  ),
                  const Center(
                    child: Text(
                      "No favorite items yet!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.68,
            ),
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              var product = favoriteProducts[index];
              return Bounceable(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.detailScreen,
                    arguments: product,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 10,
                      right: 16,
                      bottom: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.network(
                              loadingBuilder: _buildLoadingShimmer,
                              "http:${product.image}",
                              width: 180,
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Price: ${product.priceSign}${product.price}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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

