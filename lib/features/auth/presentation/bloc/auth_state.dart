import 'package:e_commerce_app/features/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {
  final User user;

  const AuthenticatedState(this.user);
}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordFailure extends AuthState {
  final String error;

  const ForgotPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}

//State error
class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordSuccessState extends AuthState {
  final String message;

  const ForgotPasswordSuccessState(this.message);

  @override
  List<Object> get props => [message];
}
