// Abstract state class
abstract class OnboardingState {}

// Initial loading state
class OnboardingLoading extends OnboardingState {}

// Loaded state with page index
class OnboardingLoaded extends OnboardingState {
  final int pageIndex;

  OnboardingLoaded({required this.pageIndex});
}
