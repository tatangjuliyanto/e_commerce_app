import 'package:e_commerce_app/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:e_commerce_app/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:e_commerce_app/features/cart/domain/usecases/payment_use_case.dart';
import 'package:e_commerce_app/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:e_commerce_app/features/cart/domain/usecases/update_item_quantity_use_case.dart';
import 'package:e_commerce_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:e_commerce_app/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCart;
  final AddToCartUseCase addToCart;
  final UpdateItemQuantityUseCase updateItemQuantity;
  final RemoveFromCartUseCase removeFromCart;
  final PaymentUseCase paymentUseCase;

  CartBloc({
    required this.getCart,
    required this.addToCart,
    required this.updateItemQuantity,
    required this.removeFromCart,
    required this.paymentUseCase,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCartEvent>(_onAddItemToCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<PaymentEvent>(_onPayment);
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

  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      updateItemQuantity(event.userId, event.productId, event.newQty);
      final updatedCart = await getCart(event.userId);
      emit(CartLoaded(cartEntity: updatedCart));
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
      final updatedCart = await getCart(event.userId);
      emit(CartLoaded(cartEntity: updatedCart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onPayment(PaymentEvent event, Emitter<CartState> emit) async {
    try {
      // Remove this line: await paymentUseCase(event.userId, event.name, event.email);
      final getSnapToken = await paymentUseCase(
        event.userId,
        event.name,
        event.email,
      );
      emit(PaymentSuccessState(snapToken: getSnapToken));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
