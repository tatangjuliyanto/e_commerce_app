import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class GetprofileEvent extends ProfileEvent {
  final String id;

  const GetprofileEvent(this.id);

  @override
  List<Object> get props => [id];
}

// TODO: implement updateProfile & another events
class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String email;
  const UpdateProfileEvent(this.name, this.email);
  @override
  List<Object> get props => [name, email];
}
