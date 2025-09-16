import 'package:e_commerce_app/features/profile/domain/usecases/get_profile_user.dart';
import 'package:e_commerce_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUser getProfileUser;

  ProfileBloc({required this.getProfileUser}) : super(ProfileInitial()) {
    // on<GetProfileEvent>(_onGetProfileEvent);
    on<LoadProfileEvent>(_onLoadProfileEvent);
  }

  Future<void> _onLoadProfileEvent(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(ProfileError("User not authenticated"));
        return;
      }

      final profile = await getProfileUser(user.id);
      emit(
        ProfileLoaded(id: profile.id, name: profile.name, email: profile.email),
      );
    } catch (e) {
      emit(ProfileError('Failed to load profile'));
    }
  }
}
