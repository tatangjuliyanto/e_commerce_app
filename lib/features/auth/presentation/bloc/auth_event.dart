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

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent(this.email);
  @override
  String toString() => 'ForgotPasswordEvent: $email';
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgotPasswordEvent && other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}
