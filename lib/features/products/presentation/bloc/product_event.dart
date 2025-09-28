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
