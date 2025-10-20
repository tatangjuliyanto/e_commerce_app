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

class UpdateItemQuantity extends CartEvent {
  final String userId;
  final int productId;
  final int newQty;

  UpdateItemQuantity(this.userId, this.productId, this.newQty);
}

class RemoveItemFromCart extends CartEvent {
  final String userId;
  final int productId;
  RemoveItemFromCart(this.userId, this.productId);
}

class PaymentEvent extends CartEvent {
  final String userId;
  final String name;
  final String email;
  PaymentEvent({required this.userId, required this.name, required this.email});

  @override
  List<Object?> get props => [userId, name, email];
}
