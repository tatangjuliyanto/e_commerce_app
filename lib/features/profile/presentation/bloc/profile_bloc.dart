import 'package:e_commerce_app/features/profile/domain/usecases/get_profile_user.dart';
import 'package:e_commerce_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUser getProfileUser;

  ProfileBloc({required this.getProfileUser}) : super(ProfileInitial()) {
    on<GetprofileEvent>(_onGetprofileEvent);
  }

  Future<void> _onGetprofileEvent(
    GetprofileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await getProfileUser(event.userId);
      emit(
        ProfileLoaded(id: profile.id, name: profile.name, email: profile.email),
      );
    } catch (e) {
      emit(ProfileError('Failed to load profile'));
    }
  }
}
