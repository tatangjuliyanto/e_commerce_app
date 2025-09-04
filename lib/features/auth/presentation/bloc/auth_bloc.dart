import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/forgot_password_user.dart';
import '../../domain/usecases/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final ForgotPasswordUser forgotPasswordUser;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.forgotPasswordUser,
  }) : super(AuthInitialState()) {
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<AuthRegisterEvent>(_onAuthRegisterEvent);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthStateReset>(_onAuthStateReset);
  }
  Future<void> _onAuthLoginEvent(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await loginUser(event.email, event.password);
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onAuthRegisterEvent(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await registerUser(event.name, event.email, event.password);
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  // Future<void> _onForgotPasswordRequested(
  //   ForgotPasswordRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoadingState());
  //   try {
  //     final user = await forgotPasswordUser(event.email);
  //     emit(ForgotPasswordSuccess('Password reset link sent to ${user.email}'));
  //   } catch (e) {
  //     emit(AuthErrorState(e.toString()));
  //   }
  // }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      await forgotPasswordUser(event.email);
      emit(
        ForgotPasswordSuccess(
          'Password reset email has been sent to ${event.email}. Please check your inbox.',
        ),
      );
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }

  void _onAuthStateReset(AuthStateReset event, Emitter<AuthState> emit) {
    emit(AuthInitialState());
  }
}
