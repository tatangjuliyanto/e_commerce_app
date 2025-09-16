import 'package:e_commerce_app/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String id);
  Future<ProfileModel> updateProfile(String name, String email);
  Future<ProfileModel> changePassword(
    String currentPassword,
    String newPassword,
  );
  Future<ProfileModel> singOut();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabase;

  ProfileRemoteDataSourceImpl(this.supabase);

  @override
  Future<ProfileModel> getProfile(String id) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return ProfileModel(
      id: user.id,
      name: user.userMetadata?['name'] ?? '',
      email: user.email ?? '',
    );
  }

  @override
  Future<ProfileModel> updateProfile(String name, String email) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<ProfileModel> changePassword(
    String currentPassword,
    String newPassword,
  ) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<ProfileModel> singOut() {
    // TODO: implement singOut
    throw UnimplementedError();
  }
}
