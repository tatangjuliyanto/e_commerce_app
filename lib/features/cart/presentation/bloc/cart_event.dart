import 'package:equatable/equatable.dart';

import '../../../products/domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  final String userId;
  LoadCart(this.userId);
}

class AddItemToCartEvent extends CartEvent {
  final String userId;
  final Product product;
  final int quantity;
  AddItemToCartEvent(this.userId, this.product, this.quantity);
}

class RemoveItemFromCart extends CartEvent {
  final String userId;
  final int productId;
  RemoveItemFromCart(this.userId, this.productId);
}
