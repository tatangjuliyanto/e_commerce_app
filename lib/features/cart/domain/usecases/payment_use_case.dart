import '../repositories/cart_repository.dart';

class PaymentUseCase {
  final CartRepository repository;
  PaymentUseCase(this.repository);

  Future<String> call(String userId, String name, String email) async {
    return await repository.payment(userId, name, email);
  }
}
