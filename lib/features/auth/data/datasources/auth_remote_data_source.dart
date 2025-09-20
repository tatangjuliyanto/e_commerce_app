import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel> forgotpassword(String email);
  Future<void> logout();
}

// Supabase Implementation
class AuthRemoteDataSupabaseSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseAuth;

  AuthRemoteDataSupabaseSourceImpl({required this.supabaseAuth});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await supabaseAuth.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user!;
    return UserModel(
      uid: user.id,
      name: user.userMetadata?['name'] ?? '',
      email: user.email!,
      password: password,
    );
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final response = await supabaseAuth.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    final user = response.user!;
    return UserModel(
      uid: user.id,
      name: user.userMetadata?['name'] ?? name,
      email: user.email!,
      password: password,
    );
  }

  @override
  Future<UserModel> forgotpassword(String email) async {
    try {
      await supabaseAuth.auth.resetPasswordForEmail(email);
      return UserModel(uid: '', name: '', email: email, password: '');
    } catch (e) {
      throw Exception(
        'An error occurred while sending password reset email, plese try again later.',
      );
    }
  }

  @override
  Future<void> logout() async {
    await supabaseAuth.auth.signOut();
  }
}
