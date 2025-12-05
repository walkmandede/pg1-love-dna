import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
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
        child: Padding(
          padding: EdgeInsetsGeometry.all(kBasePaddingM),
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
  }

  Widget _howWorkCard() {
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
                'How TWLVE works',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              24.heightGap,
              Text(
                'You\'ll respond to 12 everyday\nscenarios.',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              16.heightGap,
              Text(
                'TWLVE identifies the patterns\nbehind how you respond and how\nyou interpret meaning',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              16.heightGap,
              Text(
                'This creates your Love Code.',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              24.heightGap,
              AppButton(
                onPressed: () {
                  context.pop();
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
