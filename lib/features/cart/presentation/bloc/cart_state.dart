import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_entity.dart';

abstract class CartState {
  const CartState();

  List<Object> get props => [];
}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  CartLoading();

  @override
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  final CartEntity cartEntity;
  CartLoaded({required this.cartEntity});

  @override
  List<Object> get props => [cartEntity];
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
