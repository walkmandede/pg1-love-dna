import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/assets/app_svgs.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_loading_widget.dart';
import 'package:pg1/core/shared/widgets/app_responsive_builder.dart';
import 'package:pg1/core/shared/widgets/app_svg_widget.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';
import 'package:pg1/core/shared/widgets/white_card.dart';
import 'package:pg1/core/states/data/app_data.dart';
import 'package:pg1/features/onboarding/onboarding_page_controller.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final OnboardingPageController _pageController = OnboardingPageController();

  @override
  void initState() {
    super.initState();
    _pageController.initLoad(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: AppResponsiveBuilder(
          verticalBuilder: (isVertical) {
            return ValueListenableBuilder(
              valueListenable: _pageController.isLoaded,
              builder: (context, isLoaded, child) {
                if (!isLoaded) {
                  return AppLoadingWidget();
                }
                return _vLayout(isVertical);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _vLayout(bool isVertical) {
    return Padding(
      padding: EdgeInsetsGeometry.all(kBasePaddingM),
      child: LayoutBuilder(
        builder: (a1, c1) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(),
                          child: Text(
                            AppData.version,
                            style: AppTextStyles.bodyTextSmall.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      (context.screenHeight * 0.125).heightGap,
                      Hero(
                        tag: 'heart_icon',
                        child: AppSvgWidget(
                          svgString: AppSvgs.heart,
                          color: AppColor.textOnButton,
                          size: Size.fromRadius(35),
                          hasBgCircle: true,
                        ),
                      ),
                      16.heightGap,
                      Text(
                        'Find your Love Code\nin 3 minutes.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.cardTitle,
                      ),
                      8.heightGap,
                      Text(
                        'Quick, private, and grounded in emotional\npatterns',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subtitle,
                      ),
                      (context.screenHeight * 0.05).heightGap,
                      Row(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: min(112, context.screenWidth * 0.25),
                            child: WhiteCard(title: 'Respond', iconPath: AppSvgs.respond),
                          ),
                          SizedBox(
                            width: min(112, context.screenWidth * 0.25),
                            child: WhiteCard(title: 'Pattern', iconPath: AppSvgs.pattern),
                          ),
                          SizedBox(
                            width: min(112, context.screenWidth * 0.25),
                            child: WhiteCard(title: 'Code', iconPath: AppSvgs.code),
                          ),
                        ],
                      ),
                      (context.screenHeight * 0.05).heightGap,
                      AppButton(
                        width: min(kStandardMaxWidthForPortraitOrientation, c1.maxWidth * 0.8),
                        onPressed: () {
                          context.pushNamed(AppRoutes.inputs.name);
                        },
                        label: 'Begin',
                      ),
                      16.heightGap,
                      TextButton(
                        onPressed: () {
                          context.pushNamed(AppRoutes.howWork.name);
                        },
                        child: Text(
                          'How TWLVE work',
                          style: AppTextStyles.linkText.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      (context.screenHeight * 0.125).heightGap,
                      DisclosureMessageWidget(),
                      8.heightGap,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
