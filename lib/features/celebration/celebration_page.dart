import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';
import 'package:pg1/core/shared/extensions/build_context_extension.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';
import 'package:pg1/core/shared/widgets/app_button.dart';
import 'package:pg1/core/shared/widgets/app_responsive_builder.dart';
import 'package:pg1/core/shared/theme/app_color.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';

class CelebrationPage extends StatefulWidget {
  const CelebrationPage({
    super.key,
  });

  @override
  State<CelebrationPage> createState() => _CelebrationPageState();
}

class _CelebrationPageState extends State<CelebrationPage> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 5000),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _scaleAnim = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _confettiController.play();
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundBase,
      body: AppResponsiveBuilder(
        verticalBuilder: (isVertical) {
          return Center(
            child: SizedBox(
              width: min(context.screenWidth, kStandardMaxWidthForPortraitOrientation * 0.9),
              height: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kBasePaddingM,
                  vertical: kBasePaddingL,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// Confetti
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        maxBlastForce: 12,
                        minBlastForce: 4,
                        emissionFrequency: 0.05,
                        numberOfParticles: 40,
                        gravity: 0.05,
                        colors: const [
                          AppColor.primary,
                          AppColor.textBase,
                          AppColor.white,
                        ],
                      ),
                    ),

                    /// Celebration content
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          24.heightGap,
                          ScaleTransition(
                            scale: _scaleAnim,
                            child: Column(
                              children: [
                                Text(
                                  "You've completed your",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.textBase,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                8.heightGap,
                                Text(
                                  "TWLVE Pattern Library!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.textBase,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    height: 1.2,
                                  ),
                                ),
                                12.heightGap,
                                Text(
                                  "Your Love Code is ready.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          48.heightGap,

                          /// CTA button using your AppButton
                          AppButton(
                            width: double.infinity,
                            height: kBaseButtonHeight,
                            label: "See Your Love Code",
                            onPressed: () {},
                          ),
                          12.heightGap,
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(
                              'Back to Love Library',
                              style: AppTextStyles.linkText.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          24.heightGap,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
