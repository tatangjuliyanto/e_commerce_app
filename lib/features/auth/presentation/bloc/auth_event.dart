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

// class LoginRequested extends AuthEvent {
//   final String email;
//   final String password;

//   LoginRequested(this.email, this.password);
// }

// class RegisterRequested extends AuthEvent {
//   final String name;
//   final String email;
//   final String password;

//   RegisterRequested(this.name, this.email, this.password);
// }
