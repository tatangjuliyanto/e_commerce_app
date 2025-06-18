// Abstract event class
abstract class OnboardingEvent {}

// Event to load a specific onboarding page
class LoadOnboardingPage extends OnboardingEvent {
  final int pageIndex;

  LoadOnboardingPage({required this.pageIndex});
}
