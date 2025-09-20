import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetprofileEvent extends ProfileEvent {
  final String userId;

  const GetprofileEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

// TODO: implement updateProfile & another events
class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String email;
  const UpdateProfileEvent(this.name, this.email);
  @override
  List<Object> get props => [name, email];
}
