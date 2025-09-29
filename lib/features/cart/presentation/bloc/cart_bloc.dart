import 'package:e_commerce_app/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:e_commerce_app/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:e_commerce_app/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:e_commerce_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:e_commerce_app/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCart;
  final AddToCartUseCase addToCart;
  final RemoveFromCartUseCase removeFromCart;

  CartBloc({
    required this.getCart,
    required this.addToCart,
    required this.removeFromCart,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCartEvent>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
  }
  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await getCart(event.userId);
      emit(CartLoaded(cartEntity: cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddItemToCart(
    AddItemToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await addToCart(event.product, event.userId, event.quantity);
      add(LoadCart(event.userId));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await removeFromCart(event.productId, event.userId);
      add(LoadCart(event.userId));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
