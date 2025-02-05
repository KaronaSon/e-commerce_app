import 'package:ecommerc_app/models/product_model.dart';
import 'package:ecommerc_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/product_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchController = TextEditingController();
  List<Map<String, dynamic>> filteredItems = [];
  bool isSearching = false;
  bool isLoading = false;

  var data = <int>[];

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    data = await Future.delayed(
      const Duration(seconds: 1),
      () => List.generate(3, (index) => index),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    filteredItems = products.take(10).toList();
    searchController.addListener(filterData);
  }

  void filterData() {
    final query = searchController.text.toLowerCase();

    setState(() {
      isSearching = query.isNotEmpty;
      isLoading = true;

      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          filteredItems = products
              .where((item) => item['name'].toLowerCase().contains(query))
              .toList();
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: (value) {
              filterData();
            },
            autofocus: true,
            controller: searchController,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade200,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  "assets/search.svg",
                  color: Colors.grey.shade700,
                ),
              ),
              suffixIcon: searchController.text.isEmpty
                  ? Icon(
                      Icons.keyboard_voice_rounded,
                      color: Colors.grey.shade600,
                    )
                  : Bounceable(
                      onTap: () {
                        searchController.clear();
                        filterData();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          "assets/circle-xmark.svg",
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
              hintText: "Search product",
              hintStyle: TextStyle(
                fontSize: 17,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      ),
      body: isLoading && searchController.text.isNotEmpty
          ? SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'searching ',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        Text(
                          '"${searchController.text}"',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 30);
                      },
                      itemCount: data.length,
                    ),
                  ),
                ],
              ),
            )
          : isSearching
              ? (filteredItems.isNotEmpty
                  ? ListView.separated(
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 10,
                          color: Colors.grey.shade200,
                        );
                      },
                      padding: const EdgeInsets.symmetric(
                        // horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        var item = filteredItems[index];
                        var productFiltered = ProductModel.fromJson(item);
                        return Bounceable(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.detailScreen,
                              arguments: productFiltered,
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Hero(
                                    tag: productFiltered.image,
                                    child: Image.network(
                                      loadingBuilder: _buildLoadingShimmer,
                                      "http:${productFiltered.image}",
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productFiltered.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          productFiltered.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "${productFiltered.priceSign}${productFiltered.price}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'searching ',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                Text(
                                  '"${searchController.text}"',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            "assets/profile/Match-not-found.png",
                            width: 200,
                          ),
                        ],
                      ),
                    ))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        "assets/icons/search.jpg",
                        height: 300,
                        width: 300,
                      ),
                    ],
                  ),
                ),
    );
  }
}

Widget _buildLoadingShimmer(
    BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  if (loadingProgress == null) return child;
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
