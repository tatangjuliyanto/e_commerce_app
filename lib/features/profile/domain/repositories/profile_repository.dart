import 'package:e_commerce_app/features/profile/domain/entities/profile_entities.dart';

abstract class ProfileRepository {
  Future<ProfileEntities> getProfile(String id);
  Future<ProfileEntities> updateProfile(String name, String email);
  Future<ProfileEntities> changePassword(
    String currentPassword,
    String newPassword,
  );
  Future<ProfileEntities> signOut();
}
