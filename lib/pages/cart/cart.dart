import 'package:ecommerc_app/helpers/cart_helper.dart';
import 'package:ecommerc_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../routes/routes.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late double screenWidth;
  late double screenHeight;
  List<Map<String, dynamic>> cart = [];
  Set<int> selectedIndexes = {};
  double total = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCart();
  }

  void _loadCart() async {
    final cartService = CartService();
    final savedCart = await cartService.getCart();

    setState(() {
      cart = _mergeDuplicateProducts(savedCart);
      _updateTotal();
    });
  }

  List<Map<String, dynamic>> _mergeDuplicateProducts(
      List<Map<String, dynamic>> savedCart) {
    List<Map<String, dynamic>> mergedCart = [];
    for (var item in savedCart) {
      var product = ProductModel.fromJson(item['product']);
      bool isExisting = false;

      for (var mergedItem in mergedCart) {
        if (mergedItem['product'] == product) {
          mergedItem['quantity'] += item['quantity'];
          isExisting = true;
          break;
        }
      }

      if (!isExisting) {
        mergedCart.add({
          'product': product,
          'quantity': item['quantity'],
          'color': item['color'],
        });
      }
    }
    return mergedCart;
  }

  void _saveCart() {
    final cartService = CartService();
    final serializedCart = cart.map((item) {
      return {
        'product': (item['product'] as ProductModel).toJson(),
        'quantity': item['quantity'],
        'color': item['color'],
      };
    }).toList();
    cartService.saveCart(serializedCart);
  }

  // void _removeSelectedItems() {
  //   setState(() {
  //     cart = cart
  //         .where((item) => !selectedIndexes.contains(cart.indexOf(item)))
  //         .toList();
  //     selectedIndexes.clear();
  //     _updateTotal();
  //   });
  //   _saveCart();
  //   IconSnackBar.show(
  //     context,
  //     snackBarType: SnackBarType.fail,
  //     label: 'Remove from cart',
  //   );
  // }

  void _removeSelectedItems() {
    setState(() {
      List<int> sortedIndexes = selectedIndexes.toList()..sort((a, b) => b - a);

      for (int index in sortedIndexes) {
        cart.removeAt(index);
      }

      selectedIndexes.clear();
      _updateTotal();
    });

    _saveCart();

    IconSnackBar.show(
      context,
      snackBarType: SnackBarType.fail,
      label: 'Removed from cart',
    );
  }

  void _updateTotal() {
    total = selectedIndexes.fold(0, (sum, index) {
      var cartItem = cart[index];
      var product = cartItem['product'] as ProductModel;
      return sum + (double.parse(product.price) * cartItem['quantity']);
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
      _updateTotal();
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (cart[index]['quantity'] > 1) {
        cart[index]['quantity']--;
      } else {
        cart.removeAt(index);
        selectedIndexes.remove(index);
      }
      _updateTotal();
    });
    _saveCart();
  }

  void _increaseQuantity(int index) {
    setState(() {
      cart[index]['quantity']++;
      _updateTotal();
    });
    _saveCart();
  }

  // void _navigateToOrders() {
  //   List<Map<String, dynamic>> selectedItems = selectedIndexes.map((index) {
  //     var cartItem = cart[index];
  //     return {
  //       'product': cartItem['product'],
  //       'quantity': cartItem['quantity'],
  //       'color': cartItem['color'],
  //     };
  //   }).toList();

  //   Navigator.pushNamed(
  //     context,
  //     Routes.ordercart,
  //     arguments: {
  //       'selectedItems': selectedItems,
  //     },
  //   );
  // }

  void _navigateToOrders() {
    List<Map<String, dynamic>> selectedItems = selectedIndexes.map((index) {
      var cartItem = cart[index];
      return {
        'product': cartItem['product'],
        'quantity': cartItem['quantity'],
        'color': cartItem['color'],
        'index': index,
      };
    }).toList();

    Navigator.pushNamed(
      context,
      Routes.ordercart,
      arguments: {
        'selectedItems': selectedItems,
        'removeOrderedItems': (List<int> orderedIndexes) {
          setState(() {
            cart = cart
                .asMap()
                .entries
                .where((entry) => !orderedIndexes.contains(entry.key))
                .map((entry) => entry.value)
                .toList();
            selectedIndexes.clear();
            _updateTotal();
          });
          _saveCart();
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: const Text("Cart"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Bounceable(
              onTap: selectedIndexes.isNotEmpty ? _removeSelectedItems : null,
              child: SvgPicture.asset(
                "assets/trash.svg",
                width: 26,
                height: 26,
                color: selectedIndexes.isNotEmpty ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: cart.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.length,
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 10,
                        color: Colors.grey.shade200,
                      );
                    },
                    itemBuilder: (context, index) {
                      var cartItem = cart[index];
                      var product = cartItem['product'] as ProductModel;
                      var quantity = cartItem['quantity'];

                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                loadingBuilder: _buildLoadingShimmer,
                                "http:${product.image}",
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.error,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "USD ${product.priceSign} ${product.price}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    "Color: ${cartItem['color']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Bounceable(
                                    scaleFactor: 0.5,
                                    onTap: () {
                                      _toggleSelection(index);
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedIndexes.contains(index)
                                            ? Colors.black
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      child: selectedIndexes.contains(index)
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _increaseQuantity(index);
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
                                      Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(child: Text("$quantity")),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (quantity > 1) {
                                            _decreaseQuantity(index);
                                          }
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
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _buildBottomPlace(total),
              ],
            )
          : SafeArea(
              bottom: true,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/empty_cart.jpg",
                      height: 250,
                      width: 250,
                    ),
                    Text(
                      "Empty Product",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
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
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // Widget _buildBottomPlace(double total) {
  //   return Container(
  //     color: Colors.white,
  //     padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "USD \$${total.toStringAsFixed(2)}",
  //               style:
  //                   const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
  //             ),
  //             Text(
  //               "${selectedIndexes.length} items",
  //               style: const TextStyle(
  //                 fontSize: 15,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const Spacer(),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.black,
  //             foregroundColor: Colors.white,
  //             shape: const RoundedRectangleBorder(),
  //             minimumSize: Size(screenWidth * 0.3, screenHeight * 0.055),
  //           ),
  //           onPressed: selectedIndexes.isNotEmpty ? _navigateToOrders : null,
  //           child: const Text(
  //             "CHECKOUT",
  //             style: TextStyle(fontSize: 16),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomPlace(double total) {
    List<String> selectedImages = selectedIndexes.map((index) {
      return (cart[index]['product'] as ProductModel).image;
    }).toList();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: Column(
        children: [
          if (selectedIndexes.isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: selectedImages.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "http:${selectedImages[index]}",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/placeholder.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "USD \$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "${selectedIndexes.length} items selected",
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(),
                  minimumSize: Size(screenWidth * 0.3, screenHeight * 0.055),
                ),
                onPressed:
                    selectedIndexes.isNotEmpty ? _navigateToOrders : null,
                child: const Text(
                  "CHECKOUT",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
