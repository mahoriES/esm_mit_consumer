import 'package:eSamudaay/modules/onBoardingScreens/widgets/first_page.dart';
import 'package:eSamudaay/modules/onBoardingScreens/widgets/fourth_page.dart';
import 'package:eSamudaay/modules/onBoardingScreens/widgets/second_page.dart';
import 'package:eSamudaay/modules/onBoardingScreens/widgets/third_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingWidget extends StatefulWidget {
  @override
  _OnboardingWidgetState createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  PageController pageController = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 20),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  children: [
                    FirstPageWidget(),
                    SecondPageWidget(),
                    ThirdPageWidget(),
                    FourthPageWidget()
                  ],
                  controller: pageController,
                ),
              ),
              SmoothPageIndicator(
                  controller: pageController, // PageController
                  count: 4,
                  effect: WormEffect(
                      activeDotColor: Color(0xff5f3a9f),
                      dotHeight: 11,
                      dotWidth: 11), // your preferred effect
                  onDotClicked: (index) {})
            ],
          ),
        ),
      ),
    );
  }
}
