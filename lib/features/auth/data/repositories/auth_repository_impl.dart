import 'package:e_commerce_app/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:e_commerce_app/features/auth/domain/entities/user.dart';
import 'package:e_commerce_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<User> register(String name, String email, String password) async {
    return await remoteDataSource.register(name, email, password);
  }
}
