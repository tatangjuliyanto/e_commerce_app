import 'package:e_commerce_app/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_commerce_app/shared/presentation/bloc/onboarding_bloc.dart';
import 'package:e_commerce_app/shared/presentation/bloc/onboarding_event.dart';
import 'package:e_commerce_app/shared/presentation/bloc/onboarding_state.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      isScrollable: false,
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              PageView(
                controller: controller,
                onPageChanged: (value) {
                  context.read<OnboardingBloc>().add(
                    LoadOnboardingPage(pageIndex: value),
                  );
                },
                children: [
                  _page(
                    context: context,
                    pageIndex: 0,
                    imageUrl: 'assets/images/page1.png',
                    title: 'Boost Productivity',
                    desc:
                        'Elevate your productivity to new heights and grow with us',
                  ),
                  _page(
                    context: context,
                    pageIndex: 1,
                    imageUrl: 'assets/images/page2.png',
                    title: 'Work Seamlessly',
                    desc: 'Get your work done seamlessly without interruption',
                  ),
                  _page(
                    context: context,
                    pageIndex: 2,
                    imageUrl: 'assets/images/page3.png',
                    title: 'Achieve Higher Goals',
                    desc:
                        'By boosting your productivity we help you achieve higher goals',
                  ),
                ],
              ),
              // dots (matiin dengan if(false))
            ],
          );
        },
      ),
    );
  }

  Widget _page({
    required int pageIndex,
    required String imageUrl,
    required String title,
    required String desc,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageUrl, height: 300),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment:
                pageIndex == 2
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
            children: [
              if (pageIndex != 2)
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  if (pageIndex == 2) {
                    context.go('/login');
                  } else {
                    controller.animateToPage(
                      pageIndex + 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                    );
                  }
                },
                child: Container(
                  width: pageIndex == 2 ? 150 : 60,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child:
                      pageIndex == 2
                          ? const Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
