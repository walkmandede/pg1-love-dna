import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';

class AppProgressBar extends StatelessWidget {
  final String label;
  final int current;
  final int total;

  const AppProgressBar({
    super.key,
    required this.label,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        Text(
          '$label $current of $total',
          style: AppTextStyles.subtitle,
        ),
        SizedBox(
          width: double.infinity,
          height: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kBasePaddingM),
            child: Stack(
              children: [
                _bar(1, AppColor.backgroundGrey),
                _bar(current / total, AppColor.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bar(double amount, Color color) {
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(1000)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: double.infinity,
                width: constraints.maxWidth * amount,
              ),
            ),
          );
        },
      ),
    );
  }
}
