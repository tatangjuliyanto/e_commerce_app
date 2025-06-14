import 'package:e_commerce_app/features/products/domain/usecases/get_product_detail.dart';
import 'package:e_commerce_app/features/products/domain/usecases/get_products.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_event.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetProductDetail getProductDetail;

  ProductBloc({required this.getProducts, required this.getProductDetail})
    : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductDetail>(_onLoadProductDetail);
    on<AddToCartEvent>(_onAddToCart);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await getProductDetail(event.productId);
      emit(ProductDetailLoaded(product: product));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      // TODO: Implement proper add to cart logic
      if (state is ProductDetailLoaded) {
        emit(state);
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
