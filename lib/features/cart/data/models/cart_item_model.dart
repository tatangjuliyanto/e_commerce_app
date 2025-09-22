import 'package:e_commerce_app/features/cart/domain/entities/cart_entity.dart';

import '../../../products/domain/entities/product.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({required super.product, required super.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['products'] ?? {};
    return CartItemModel(
      product: Product(
        id: productJson['id'],
        title: productJson['title'],
        description: productJson['description'],
        thumbnail: productJson['thumbnail'],
        category: productJson['category'],
        rating: (productJson['rating'] as num).toDouble(),
        price: (productJson['price'] as num).toDouble(),
        stock: (productJson['stock'] as num).toDouble(),
      ),
      quantity: json['quantity'] as int,
    );
  }
}
