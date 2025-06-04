import 'package:e_commerce_app/features/product/domain/entities/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded({required this.products});
}

class ProductId extends ProductState {
  final Product products;
  ProductId({required this.products});
}

class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});
}
