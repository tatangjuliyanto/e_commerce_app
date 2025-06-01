import 'package:e_commerce_app/features/auth/domain/usecases/login_user.dart';
import 'package:e_commerce_app/features/auth/domain/usecases/register_user.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;

  AuthBloc({required this.loginUser, required this.registerUser})
    : super(AuthInitialState()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await loginUser(event.email, event.password);
        print('User logged in: ${user.name}'); // Debugging line
        emit(AuthenticatedState(user));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<AuthRegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await registerUser(
          event.name,
          event.email,
          event.password,
        );
        emit(AuthenticatedState(user));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });
  }
}
