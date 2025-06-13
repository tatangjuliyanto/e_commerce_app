import 'package:e_commerce_app/features/product/domain/entities/product.dart';

abstract class ProductState {
  //TODO The code dont fixit
  final List<Product> cart;
  ProductState({this.cart = const []});
  List<Object> get props => [cart];
}

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

class CartUpdated extends ProductState {
  CartUpdated({super.cart});

  @override
  List<Object> get props => [cart];
}

class ProductCartSuccess extends ProductState {
  final String message;
  ProductCartSuccess({required this.message});
}
