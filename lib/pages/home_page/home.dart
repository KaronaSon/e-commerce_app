import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerc_app/data/product_model.dart';
import 'package:ecommerc_app/models/product_model.dart';
import 'package:ecommerc_app/routes/routes.dart';
import 'package:ecommerc_app/widgets/slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/product_type.dart';
import '../../models/product_type.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> selectedProductType = productType[0];
  var scrollController = ScrollController();
  List<Map<String, dynamic>> cart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            forceElevated: true,
            forceMaterialTransparency: true,
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            centerTitle: true,
            flexibleSpace: Container(
              color: Colors.white,
            ),
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
                      arguments: cart,
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
          const SliverToBoxAdapter(
            child: SliderBanner(),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[100],
              height: 18,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
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
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Bounceable(
                                  scaleFactor: 0.5,
                                  onTap: () {
                                    setState(() {
                                      selectedProductType = productType[index];
                                    });
                                    List<Map<String, dynamic>> fitterProduct =
                                        products
                                            .where((product) =>
                                                product["product_type"]
                                                    .toLowerCase() ==
                                                selectedProductType["tag"]
                                                    .replaceFirst(" ", "_")
                                                    .toLowerCase())
                                            .toList();
                                    Navigator.pushNamed(
                                      context,
                                      Routes.category,
                                      arguments: fitterProduct,
                                    );
                                  },
                                  child: SvgPicture.network(
                                    product.image,
                                    fit: BoxFit.cover,
                                    placeholderBuilder: (context) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      );
                                    },
                                    width: 80,
                                    height: 80,
                                    colorFilter: ColorFilter.mode(
                                      Colors.grey.shade900,
                                      BlendMode.srcIn,
                                    ),
                                  ),
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[100],
              height: 18,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              // color: Colors.white,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 30,
                    ),
                    child: Text(
                      "All Product",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var item = products[index];
                  var product = ProductModel.fromJson(item);

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.detailScreen,
                        arguments: product,
                      );
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Hero(
                                  tag: product.image,
                                  child: CachedNetworkImage(
                                    imageUrl: "http:${product.image}",
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  // Image(
                                  //   loadingBuilder: _buildLoadingShimmer,
                                  //   image: NetworkImage(
                                  //     "http:${product.image}",
                                  //   ),
                                  //   fit: BoxFit.contain,
                                  // ),
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
                childCount: products.length,
              ),
            ),
          ),
        ],
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
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
