import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel> forgotpassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email!,
      password: password,
    );
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await user.updateProfile(displayName: name);
    return UserModel(
      uid: user.uid,
      name: name,
      email: user.email!,
      password: password,
    );
  }

  @override
  Future<UserModel> forgotpassword(String email) async {
    final signInMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);
    if (signInMethods.isEmpty) {
      throw Exception(
        'No account found with this email address. Please check your email or sign up first.',
      );
    }
    if (signInMethods.isNotEmpty) {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return UserModel(uid: '', name: '', email: email, password: '');
    }
    throw Exception('Failed to send password reset email. Please try again.');
  }
}
