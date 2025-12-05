import 'package:flutter/material.dart';
import 'package:pg1/core/shared/assets/app_svgs.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/extensions/int_extension.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/widgets/app_svg_widget.dart';
import 'package:pg1/features/splash/splash_page_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashPageController _controller = SplashPageController();

  @override
  void initState() {
    super.initState();
    _controller.initLoad(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(kBasePaddingM),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'heart_icon',
                  child: CircleAvatar(
                    radius: context.screenWidth * 0.125,
                    backgroundColor: AppColor.primary,
                    child: Padding(
                      padding: EdgeInsets.all(context.screenWidth * 0.05),
                      child: AppSvgWidget(
                        svgString: AppSvgs.heart,
                        color: AppColor.white,
                        size: Size(context.screenWidth * 0.125, context.screenWidth * 0.125),
                      ),
                    ),
                  ),
                ),
                16.heightGap,
                Text(
                  'Initialising the Love Engine...',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
