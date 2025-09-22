import 'package:e_commerce_app/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final Product product;
  final int quantity;

  const CartItemEntity({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}

class CartEntity extends Equatable {
  final List<CartItemEntity> items;

  const CartEntity({this.items = const []});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => items.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  @override
  List<Object> get props => [items];
}
