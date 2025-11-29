/// Modèle CartItem pour ECONOMAX
class CartItem {
  const CartItem({
    required this.productId,
    required this.quantity,
    this.selected = true,
  });

  final String productId;
  final int quantity;
  final bool selected;

  CartItem copyWith({
    String? productId,
    int? quantity,
    bool? selected,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      selected: selected ?? this.selected,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      selected: json['selected'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'selected': selected,
    };
  }
}

