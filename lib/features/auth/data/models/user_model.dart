import 'package:e_commerce_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.password,
  });
}
