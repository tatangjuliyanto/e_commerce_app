import 'package:e_commerce_app/features/cart/domain/repositories/cart_repository.dart';

import '../entities/cart_entity.dart';

class GetCartUseCase {
  final CartRepository repository;
  GetCartUseCase(this.repository);

  Future<CartEntity> call(String userId) async {
    return await repository.getCart(userId);
  }
}
