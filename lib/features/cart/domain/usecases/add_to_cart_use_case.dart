import 'package:e_commerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:e_commerce_app/features/products/domain/entities/product.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> call(Product product, String userId, int quantity) async {
    return await repository.addToCart(product, userId, quantity);
  }
}
