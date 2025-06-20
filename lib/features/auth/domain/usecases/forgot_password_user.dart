import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUser {
  final AuthRepository repository;

  ForgotPasswordUser(this.repository);

  Future<User> call(String email) async {
    return await repository.forgotpassword(email);
  }
}
