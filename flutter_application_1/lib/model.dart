class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;
  bool isLiked;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isLiked = false,
  });
}
