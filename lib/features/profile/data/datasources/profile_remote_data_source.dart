import 'package:e_commerce_app/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String id);
  Future<ProfileModel> updateProfile(String name, String email);
  Future<ProfileModel> changePassword(
    String currentPassword,
    String newPassword,
  );
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
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return supabase.auth
        .updateUser(UserAttributes(email: email, data: {'name': name}))
        .then((response) {
          final updatedUser = response.user;
          if (updatedUser == null) {
            throw Exception('Failed to update user');
          }
          return ProfileModel(
            id: updatedUser.id,
            name: updatedUser.userMetadata?['name'] ?? '',
            email: updatedUser.email ?? '',
          );
        });
  }

  @override
  Future<ProfileModel> changePassword(
    String currentPassword,
    String newPassword,
  ) {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return supabase.auth.updateUser(UserAttributes(password: newPassword)).then(
      (response) {
        final updateUser = response.user;
        if (updateUser == null) {
          throw Exception('Failed to update password');
        }
        return ProfileModel(
          id: updateUser.id,
          email: updateUser.email ?? '',
          name: updateUser.userMetadata?['name'] ?? '',
        );
      },
    );
  }
}
