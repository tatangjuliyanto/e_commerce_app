import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel> forgotpassword(String email);
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
}

// Firebase implementation
// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final firebase_auth.FirebaseAuth firebaseAuth;

//   AuthRemoteDataSourceImpl({required this.firebaseAuth});

//   @override
//   Future<UserModel> login(String email, String password) async {
//     final credential = await firebaseAuth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     final user = credential.user!;
//     return UserModel(
//       uid: user.uid,
//       name: user.displayName ?? '',
//       email: user.email!,
//       password: password,
//     );
//   }

//   @override
//   Future<UserModel> register(String name, String email, String password) async {
//     final credential = await firebaseAuth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     final user = credential.user!;
//     await user.updateProfile(displayName: name);
//     return UserModel(
//       uid: user.uid,
//       name: name,
//       email: user.email!,
//       password: password,
//     );
//   }

//   @override
//   Future<UserModel> forgotpassword(String email) async {
//     try {
//       await firebaseAuth.sendPasswordResetEmail(email: email);
//       return UserModel(uid: '', name: '', email: email, password: '');
//     } catch (e) {
//       throw Exception('An error occurred while sending password reset email.');
//     }
//   }
// }
