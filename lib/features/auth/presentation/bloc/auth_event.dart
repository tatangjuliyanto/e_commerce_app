abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent(this.email, this.password);
}

class AuthRegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthRegisterEvent(this.name, this.email, this.password);
}

class AuthLogoutEvent extends AuthEvent {
  AuthLogoutEvent();
}
