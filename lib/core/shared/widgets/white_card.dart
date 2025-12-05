import 'package:flutter/material.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_svg_widget.dart';

class WhiteCard extends StatelessWidget {
  final String title;
  final String iconPath;
  const WhiteCard({super.key, required this.title, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColor.backgroundSecondary,
      margin: EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 4 / 4.5,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsetsGeometry.all(constraints.maxWidth * 0),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: AppColor.primary,
                        child: Padding(
                          padding: EdgeInsets.all(constraints.maxHeight * 0.075),
                          child: AppSvgWidget(
                            svgString: iconPath,
                            size: Size(constraints.maxHeight * 0.25, constraints.maxHeight * 0.25),
                            color: AppColor.textOnButton,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(top: constraints.maxHeight * 0.05),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          title,
                          style: AppTextStyles.tagLabel.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
