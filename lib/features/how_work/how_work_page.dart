import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_responsive_builder.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';

class HowWorkPage extends StatefulWidget {
  const HowWorkPage({super.key});

  @override
  State<HowWorkPage> createState() => _HowWorkPageState();
}

class _HowWorkPageState extends State<HowWorkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: AppResponsiveBuilder(
          verticalBuilder: (isVertical) {
            return Padding(
              padding: EdgeInsetsGeometry.all(kBasePaddingM),
              child: Center(
                child: SizedBox(
                  width: min(context.screenWidth, kStandardMaxWidthForPortraitOrientation * 0.75),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _howWorkCard(),
                      32.heightGap,
                      DisclosureMessageWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _howWorkCard() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColor.backgroundSecondary,
      child: Padding(
        padding: EdgeInsetsGeometry.all(kBasePaddingL),
        child: Column(
          children: [
            Text(
              'How TWLVE works',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            24.heightGap,
            Text(
              'You\'ll respond to 12 everyday\nscenarios.',
              style: AppTextStyles.bodyText,
              textAlign: TextAlign.center,
            ),
            16.heightGap,
            Text(
              'TWLVE identifies the patterns\nbehind how you respond and how\nyou interpret meaning',
              style: AppTextStyles.bodyText,
              textAlign: TextAlign.center,
            ),
            16.heightGap,
            Text(
              'This creates your Love Code.',
              style: AppTextStyles.bodyText,

              textAlign: TextAlign.center,
            ),
            24.heightGap,
            AppButton(
              onPressed: () {
                context.pushReplacementNamed(AppRoutes.onboarding.name);
                context.pushNamed(AppRoutes.inputs.name);
              },
              width: double.infinity,
              label: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
