import 'package:e_commerce_app/features/auth/domain/usecases/login_user.dart';
import 'package:e_commerce_app/features/auth/domain/usecases/register_user.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  // final ForgotPasswordUser forgotPasswordUser;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    // required this.forgotPasswordUser,
  }) : super(AuthInitialState()) {
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<AuthRegisterEvent>(_onAuthRegisterEvent);
    on<ForgotPasswordEvent>(_onForgotPasswordEvent);
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

  //TODO : Implement forgot password functionality
  Future<void> _onForgotPasswordEvent(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      emit(ForgotPasswordState(event.email));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
