import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String id;
  final String name;
  final String email;

  const ProfileLoaded({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object> get props => [id, name, email];
}

//TODO: implement ProfileError & another states NOT USED YET
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {}

class ProfileUpdateError extends ProfileState {
  final String message;
  const ProfileUpdateError(this.message);
  @override
  List<Object> get props => [message];
}
