import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_commerce_app/shared/presentation/bloc/onboarding_bloc.dart';
import 'package:e_commerce_app/shared/presentation/bloc/onboarding_event.dart';
import 'package:e_commerce_app/shared/presentation/bloc/onboarding_state.dart';

class OnboardingPage extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

  OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(39, 39, 39, 3),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade600,
              Colors.purple.shade600,
              Colors.pink.shade400,
            ],
          ),
        ),
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            // Default to pageIndex 0 if state is not OnboardingLoaded
            int currentPageIndex =
                state is OnboardingLoaded ? state.pageIndex : 0;

            return Stack(
              alignment: Alignment.center,
              children: [
                PageView(
                  controller: controller,
                  onPageChanged: (value) {
                    // Dispatch event with the new page index
                    BlocProvider.of<OnboardingBloc>(
                      context,
                    ).add(LoadOnboardingPage(pageIndex: value));
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
                      desc:
                          'Get your work done seamlessly without interruption',
                    ),
                    _page(
                      context: context,
                      pageIndex: 2,
                      imageUrl: 'assets/images/page3.png',
                      title: 'Achieve Higher Goals',
                      desc:
                          'By boosting your producivity we help you achieve higher goals',
                    ),
                  ],
                ),
                Positioned(
                  bottom: 150,
                  child: DotsIndicator(
                    dotsCount: 3,
                    position:
                        currentPageIndex
                            .toDouble(), // Fixed ToDouble() to toDouble()
                    decorator: DotsDecorator(
                      color: Colors.white,
                      activeColor: Colors.white,
                      size: const Size.square(9.0),
                      activeSize: const Size(36.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imageUrl),
        const SizedBox(height: 40),
        Text(title, style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 120),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment:
                pageIndex == 2
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: pageIndex != 2, // Don't show on last page
                child: GestureDetector(
                  onTap: () {
                    context.go('/login'); // Navigate to login page
                  },
                  child: Text(
                    'Skip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: GestureDetector(
                  onTap: () {
                    if (pageIndex == 2) {
                      context.go('/login'); // Navigate to login page
                    } else {
                      controller.animateToPage(
                        pageIndex + 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.decelerate,
                      );
                    }
                  },
                  child:
                      pageIndex == 2
                          ? Container(
                            width: 150,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade300,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Text(
                              'Get Started',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                          : Container(
                            width: 60,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade300,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
