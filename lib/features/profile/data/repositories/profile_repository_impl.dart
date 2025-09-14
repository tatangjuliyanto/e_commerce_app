import 'package:e_commerce_app/features/profile/domain/entities/profile_entities.dart';
import 'package:e_commerce_app/features/profile/domain/repositories/profile_repository.dart';

import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  ProfileRepositoryImpl({required this.profileRemoteDataSource});

  @override
  Future<ProfileEntities> getProfile(String id) async {
    return await profileRemoteDataSource.getProfile(id);
  }

  @override
  Future<ProfileEntities> updateProfile(String name, String email) async {
    return await profileRemoteDataSource.updateProfile(name, email);
  }

  @override
  Future<ProfileEntities> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    return await profileRemoteDataSource.changePassword(
      currentPassword,
      newPassword,
    );
  }

  @override
  Future<ProfileEntities> signOut() async {
    return await profileRemoteDataSource.singOut();
  }
}
