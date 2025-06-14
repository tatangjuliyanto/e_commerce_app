import 'package:e_commerce_app/features/products/domain/entities/product.dart';

//-------------------------------------
// Abstract Class for Product
//-------------------------------------
abstract class ProductState {
  final List<Product> cart;
  ProductState({this.cart = const []});
  List<Object> get props => [cart];
}

//------------------------------------
// Product States
//------------------------------------
class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded({required this.products});
}

class ProductDetailLoaded extends ProductState {
  final Product product;
  ProductDetailLoaded({required this.product});
}

class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});
}

//------------------------------------
// Cart States
//------------------------------------

class CartLoading extends ProductState {
  CartLoading({super.cart});

  @override
  List<Object> get props => [cart];
}

class AddCart extends ProductState {
  final Product product;
  AddCart({required this.product, super.cart});

  @override
  List<Object> get props => [product, cart];
}

class CartUpdated extends ProductState {
  CartUpdated({super.cart});

  @override
  List<Object> get props => [cart];
}

class ProductCartSuccess extends ProductState {
  final String message;
  ProductCartSuccess({required this.message});
}
