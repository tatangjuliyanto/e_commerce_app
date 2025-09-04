import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent(this.email, this.password);
}

class AuthRegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthRegisterEvent(this.name, this.email, this.password);
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}

class AuthStateReset extends AuthEvent {}

//Logout Event
class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}
