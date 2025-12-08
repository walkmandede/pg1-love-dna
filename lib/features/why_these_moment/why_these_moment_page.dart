import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/routes/app_routes.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_responsive_builder.dart';
import 'package:pg1/core/shared/widgets/disclosure_message_widget.dart';

class WhyTheseMomentPage extends StatefulWidget {
  const WhyTheseMomentPage({super.key});

  @override
  State<WhyTheseMomentPage> createState() => _WhyTheseMomentPageState();
}

class _WhyTheseMomentPageState extends State<WhyTheseMomentPage> {
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
                      _whyTheseMomentCard(),
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

  Widget _whyTheseMomentCard() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColor.backgroundSecondary,
      child: Padding(
        padding: EdgeInsetsGeometry.all(kBasePaddingL),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                'Why these moments?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              24.heightGap,
              Text(
                'You\'ll respond to 12 everyday\nscenarios.\nThey reveal your emotional patterns\n—\nhow you respond and how you\ninterpret meaning.\nIt\'s quick, lightweight, and completely private.',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),

              24.heightGap,
              AppButton(
                onPressed: () {
                  context.pushNamed(AppRoutes.loveLibrary.name);
                },
                width: double.infinity,
                label: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
