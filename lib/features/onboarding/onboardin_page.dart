import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/assets/app_svgs.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_svg_widget.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';
import 'package:pg1/core/shared/widgets/white_card.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: EdgeInsetsGeometry.all(kBasePaddingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              32.heightGap,
              Hero(
                tag: 'heart_icon',
                child: CircleAvatar(
                  backgroundColor: AppColor.primary,
                  radius: context.screenHeight * 0.05,
                  child: AppSvgWidget(
                    svgString: AppSvgs.heart,
                    color: AppColor.textOnButton,
                    size: Size.fromRadius(context.screenHeight * 0.025),
                  ),
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
              32.heightGap,
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: WhiteCard(title: 'Respond', iconPath: AppSvgs.respond),
                  ),
                  Expanded(
                    child: WhiteCard(title: 'Pattern', iconPath: AppSvgs.pattern),
                  ),
                  Expanded(
                    child: WhiteCard(title: 'Code', iconPath: AppSvgs.code),
                  ),
                ],
              ),
              32.heightGap,
              AppButton(
                width: double.infinity,
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
              const Spacer(),
              DisclosureMessageWidget(),
              8.heightGap,
            ],
          ),
        ),
      ),
    );
  }
}
