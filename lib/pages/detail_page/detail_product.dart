import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:ecommerc_app/helpers/cart_helper.dart';
import 'package:ecommerc_app/helpers/favorite_helper.dart';
import 'package:ecommerc_app/models/product_model.dart';
import 'package:ecommerc_app/routes/routes.dart';
import 'package:ecommerc_app/widgets/space_height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  late double screenWidth;
  late double screenHeight;
  String colornameProduct = "";
  int itemCount = 0;
  var isClick = false;
  List<Map<String, dynamic>> cart = [];
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  final GlobalKey imageGlobalKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var productDS = ModalRoute.of(context)?.settings.arguments as ProductModel;
    setState(
      () {
        colornameProduct = productDS.productColors.isNotEmpty
            ? productDS.productColors[0].colorName
            : "No Color ";
      },
    );
  }

  Future<int> getCartItemCount() async {
    final cartService = CartService();
    List<Map<String, dynamic>> cart = await cartService.getCart();
    return cart.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));
  }

  void addToCartWithAnimation(
      GlobalKey imageKey, ProductModel product, String colornameProduct) async {
    await runAddToCartAnimation(imageKey);

    final cartService = CartService();
    bool isProductInCart = false;

    List<Map<String, dynamic>> cart = await cartService.getCart();

    for (var cartItem in cart) {
      var existingProduct = ProductModel.fromJson(cartItem['product']);
      var existingColor = cartItem['color'];

      if (existingProduct.name == product.name &&
          existingProduct.price == product.price &&
          existingProduct.image == product.image &&
          existingColor == colornameProduct) {
        setState(() {
          cartItem['quantity']++;
        });
        isProductInCart = true;
        break;
      }
    }

    if (!isProductInCart) {
      setState(() {
        cart.add({
          'product': product.toJson(),
          'quantity': 1,
          'color': colornameProduct,
        });
      });
    }

    await cartService.saveCart(cart);

    setState(() {
      itemCount = cart.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    var productDS = ModalRoute.of(context)?.settings.arguments as ProductModel;

    return AddToCartAnimation(
      cartKey: cartKey,
      height: 30,
      width: 30,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(rotation: true),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (addToCartAnimation) {
        runAddToCartAnimation = addToCartAnimation;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          title: const Text("Detail Product"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: AddToCartIcon(
                key: cartKey,
                badgeOptions: const BadgeOptions(
                  foregroundColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                ),
                icon: Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.cart,
                          arguments: cart,
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        size: 30,
                      ),
                    ),
                    FutureBuilder<int>(
                      future: getCartItemCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        } else if (snapshot.hasData && snapshot.data! > 0) {
                          return Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.cart,
                                  arguments: cart,
                                );
                              },
                              child: Bounceable(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.cart,
                                    arguments: cart,
                                  );
                                },
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      snapshot.data.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      key: imageGlobalKey,
                      color: Colors.white,
                      height: screenHeight * 0.35,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      child: Hero(
                        tag: productDS.image,
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Image.network(
                            loadingBuilder: _buildLoadingShimmer,
                            "http:${productDS.image}",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SpaceHeight(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productDS.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Price: ${productDS.priceSign}${productDS.price}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Bounceable(
                            onTap: () {
                              final favoritesManager =
                                  Provider.of<FavoritesManager>(context,
                                      listen: false);

                              favoritesManager.toggleFavorite(
                                  productDS, context);
                            },
                            child: Consumer<FavoritesManager>(
                              builder: (context, favoritesManager, child) {
                                bool isFavorite = favoritesManager.favorites
                                    .any((item) =>
                                        item.image == productDS.image);
                                return SvgPicture.asset(
                                  isFavorite
                                      ? "assets/love_solid.svg"
                                      : "assets/love.svg",
                                  height: 25,
                                  width: 25,
                                  color: isFavorite ? Colors.red : Colors.black,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceHeight(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Color: $colornameProduct',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          productDS.productColors.isNotEmpty
                              ? SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productDS.productColors.length,
                                    itemBuilder: (context, index) {
                                      var colorData =
                                          productDS.productColors[index];
                                      var isSelected = colornameProduct ==
                                          colorData.colorName;

                                      return Bounceable(
                                        onTap: () {
                                          setState(() {
                                            colornameProduct =
                                                colorData.colorName;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(colorData
                                                .hexValue
                                                .replaceFirst('#', '0xFF'))),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.blue
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    "No Color Available",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SpaceHeight(),
                    _buildTagsSection(productDS),
                    const SpaceHeight(),
                    _buildDescriptionSection(productDS),
                    const SpaceHeight(),
                  ],
                ),
              ),
            ),
            _buildFooter(productDS),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection(ProductModel productDS) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tags",
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          productDS.tagList.isEmpty
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    foregroundColor: Colors.grey[700],
                    backgroundColor: Colors.grey[400],
                    minimumSize: Size(screenWidth, 40),
                  ),
                  onPressed: () {},
                  child: const Text("There's no tag"),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: productDS.tagList
                      .map(
                        (tag) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            foregroundColor: Colors.grey[200],
                            backgroundColor: Colors.grey[700],
                            minimumSize: const Size(80, 40),
                          ),
                          onPressed: () {},
                          child: Text(tag),
                        ),
                      )
                      .toList(),
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
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(ProductModel productDS) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(productDS.description),
        ],
      ),
    );
  }

  Widget _buildFooter(ProductModel productDS) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
      child: Row(
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              foregroundColor: Colors.black,
              side: const BorderSide(width: 1.5),
              minimumSize: Size(screenWidth * 0.55, 40),
            ),
            onPressed: () {
              // addToCart(productDS, colornameProduct);
              // setState(() {
              //   itemCount++;
              // });
              addToCartWithAnimation(
                  imageGlobalKey, productDS, colornameProduct);
            },
            child: const Text("Add to Cart"),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              minimumSize: Size(screenWidth * 0.2, 40),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.orders,
                arguments: {
                  'product': productDS,
                  'color': colornameProduct,
                },
              );
            },
            child: const Text("Buy Now"),
          ),
        ],
      ),
    );
  }
}
