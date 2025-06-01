import 'package:e_commerce_app/features/auth/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {
  final User user;

  AuthenticatedState(this.user);
}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState(this.message);
}
