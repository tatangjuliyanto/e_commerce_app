import 'package:e_commerce_app/shared/presentation/bloc/onboarding_event.dart';
import 'package:e_commerce_app/shared/presentation/bloc/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingLoading()) {
    on<LoadOnboardingPage>(_onLoadOnboardingPage);
  }

  void _onLoadOnboardingPage(
    LoadOnboardingPage event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingLoaded(pageIndex: event.pageIndex));
  }
}
