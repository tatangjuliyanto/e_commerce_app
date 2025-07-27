import '../../../products/domain/entities/product.dart';

abstract class CartState {
  final List<Product> cart;
  CartState({this.cart = const []});

  List<Object> get props => [cart];
}

class CartLoading extends CartState {
  CartLoading({super.cart});

  @override
  List<Object> get props => [cart];
}

class AddCart extends CartState {
  final Product product;
  AddCart({required this.product, super.cart});

  @override
  List<Object> get props => [product, cart];
}

class CartUpdated extends CartState {
  CartUpdated({super.cart});

  @override
  List<Object> get props => [cart];
}

class ProductCartSuccess extends CartState {
  final String message;
  ProductCartSuccess({required this.message});
}
