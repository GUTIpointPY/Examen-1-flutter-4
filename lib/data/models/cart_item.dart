class CartItem {
  final String id;
  final String name;
  final String variant;
  final double price;
  int quantity;
  final String imagePath;

  CartItem({
    required this.id,
    required this.name,
    required this.variant,
    required this.price,
    this.quantity = 1,
    required this.imagePath,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? variant,
    double? price,
    int? quantity,
    String? imagePath,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      variant: variant ?? this.variant,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
