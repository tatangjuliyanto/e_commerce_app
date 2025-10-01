import 'package:e_commerce_app/features/cart/domain/repositories/cart_repository.dart';

class UpdateItemQuantityUseCase {
  final CartRepository repository;

  UpdateItemQuantityUseCase(this.repository);

  Future<void> call(String userId, int productId, int newQty) async {
    return await repository.updateItemQuantity(userId, productId, newQty);
  }
}
