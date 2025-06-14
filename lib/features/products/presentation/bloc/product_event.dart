import 'package:e_commerce_app/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

//--------------------------------------
// Abstract Class for Product Events
//--------------------------------------
abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//------------------------------------
// Product Events
//------------------------------------
class LoadProducts extends ProductEvent {}

class LoadProductDetail extends ProductEvent {
  final String productId;

  LoadProductDetail(this.productId);

  @override
  List<Object> get props => [productId];
}

//------------------------------------
// Cart Events
//------------------------------------
class AddToCartEvent extends ProductEvent {
  final Product product;

  AddToCartEvent(this.product);

  @override
  List<Object> get props => [product];
}
