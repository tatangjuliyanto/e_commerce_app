import 'package:e_commerce_app/features/cart/domain/entities/cart_entity.dart';

import '../../../products/domain/entities/product.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({required super.product, required super.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json, productData) {
    return CartItemModel(
      product: Product(
        id: productData['id'] as int,
        title: productData['title'] as String,
        description: productData['description'] as String,
        thumbnail: productData['thumbnail'] as String,
        category: productData['category'] as String,
        rating: (productData['rating'] as num).toDouble(),
        price: (productData['price'] as num).toDouble(),
        stock: (productData['stock'] as num).toInt().toDouble(),
      ),
      quantity: json['quantity'] as int,
    );
  }
}

//TODO : FIX ENtity Model
class CartEntityModel extends CartEntity {}
