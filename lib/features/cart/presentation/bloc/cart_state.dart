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

//payment states
class PaymentSuccessState extends CartState {
  final String snapToken;

  PaymentSuccessState({required this.snapToken});

  @override
  List<Object> get props => [snapToken];
}

class PaymentFailure extends CartState {
  final String error;

  PaymentFailure(this.error);

  @override
  List<Object> get props => [error];
}

class TransactionSuccess extends CartState {
  final String message;
  TransactionSuccess(this.message);
}

class TransactionFailure extends CartState {
  final String error;
  TransactionFailure(this.error);
}
