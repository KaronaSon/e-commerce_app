class ProductType {
  late String title;
  late String tag;
  late String image;
  ProductType({
    required this.title,
    required this.tag,
    required this.image,
  });

  ProductType.fromJson(data) {
    title = data['title'] ?? "";
    tag = data['tag'] ?? "";
    image = data['image'] ?? "";
  }
}
