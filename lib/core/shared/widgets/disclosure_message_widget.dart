import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/strings.dart';
import 'package:pg1/core/shared/theme/app_color.dart';

class DisclosureMessageWidget extends StatelessWidget {
  const DisclosureMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.disclosureMessage,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColor.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
