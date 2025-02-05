class ProductModel {
  late String name;
  late String description;
  late String price;
  late String priceSign;
  late String image;
  late String productType;
  late int qty;
  late List<ProductColor> productColors;
  late List<String> tagList;
  bool isFavorite;

  double get priceAsDouble => double.tryParse(price) ?? 0.0;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.priceSign,
    required this.image,
    required this.productType,
    required this.productColors,
    required this.tagList,
    this.qty = 1,
    this.isFavorite = false,
  });

  ProductModel.fromJson(Map<String, dynamic> data)
      : name = data['name'] ?? "",
        description = data['description'] ?? "",
        price = data['price'] ?? "0.0",
        priceSign = data['price_sign'] ?? "",
        image = data['api_featured_image'] ?? "",
        productType = data['product_type'] ?? "",
        tagList =
            (data['tag_list'] as List?)?.map((e) => e.toString()).toList() ??
                [],
        productColors = (data['product_colors'] as List?)
                ?.map((e) => ProductColor.fromJson(e))
                .toList() ??
            [],
        isFavorite = data['isFavorite'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'price_sign': priceSign,
      'api_featured_image': image,
      'product_type': productType,
      'tag_list': tagList,
      'product_colors': productColors.map((e) => e.toJson()).toList(),
      'isFavorite': isFavorite,
    };
  }
}

class ProductColor {
  late String hexValue;
  late String colorName;

  ProductColor({
    required this.hexValue,
    required this.colorName,
  });

  ProductColor.fromJson(Map<String, dynamic> data)
      : hexValue = data['hex_value'] ?? "",
        colorName = data['colour_name'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'hex_value': hexValue,
      'colour_name': colorName,
    };
  }
}
