import 'package:e_commerce_app/features/profile/domain/entities/profile_entities.dart';
import 'package:e_commerce_app/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUser {
  final ProfileRepository profileRepository;

  GetProfileUser(this.profileRepository);

  Future<ProfileEntities> call(String id) async {
    return await profileRepository.getProfile(id);
  }
}
