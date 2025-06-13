import 'package:e_commerce_app/features/product/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadProductDetail extends ProductEvent {
  final String productId;

  LoadProductDetail(this.productId);

  @override
  List<Object> get props => [productId];
}

class AddToCartEvent extends ProductEvent {
  final Product product;

  AddToCartEvent(this.product);

  @override
  List<Object> get props => [product];
}
