import '../repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<void> call(String productId, String userId) async {
    return await repository.removeFromCart(productId as int, userId);
  }
}
