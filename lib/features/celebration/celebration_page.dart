import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _CelebrationPageState extends State<CelebrationPage> with TickerProviderStateMixin {
  late AnimationController _pulse1Controller;
  late AnimationController _pulse2Controller;
  late AnimationController _textController;
  late AnimationController _cardController;

  late Animation<double> _pulse1Scale;
  late Animation<double> _pulse1Opacity;
  late Animation<double> _pulse2Scale;
  late Animation<double> _pulse2Opacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textOffset;
  late Animation<double> _cardOpacity;
  late Animation<double> _cardScale;

  @override
  void initState() {
    super.initState();

    // Pulse 1: 0-450ms
    _pulse1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _pulse1Scale = Tween<double>(begin: 1.0, end: 1.85).animate(
      CurvedAnimation(parent: _pulse1Controller, curve: Curves.easeOut),
    );
    _pulse1Opacity = Tween<double>(begin: 0.3, end: 0.0).animate(
      CurvedAnimation(parent: _pulse1Controller, curve: Curves.easeOut),
    );

    // Pulse 2: 250-850ms (starts 250ms after pulse 1)
    _pulse2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulse2Scale = Tween<double>(begin: 1.0, end: 1.65).animate(
      CurvedAnimation(parent: _pulse2Controller, curve: Curves.easeOut),
    );
    _pulse2Opacity = Tween<double>(begin: 0.2, end: 0.0).animate(
      CurvedAnimation(parent: _pulse2Controller, curve: Curves.easeOut),
    );

    // Text: starts 150ms, 450ms duration
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textOffset = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // Card: starts 500ms, 350ms duration
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );
    _cardScale = Tween<double>(begin: 0.985, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );

    // Trigger animations with delays
    Future.delayed(Duration.zero, () {
      _pulse1Controller.forward();
      HapticFeedback.lightImpact(); // Optional haptic on first pulse
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      _textController.forward();
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      _pulse2Controller.forward();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _cardController.forward();
    });
  }

  @override
  void dispose() {
    _pulse1Controller.dispose();
    _pulse2Controller.dispose();
    _textController.dispose();
    _cardController.dispose();
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    24.heightGap,

                    // Heart icon with pulsing halos
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulse 1 halo
                          AnimatedBuilder(
                            animation: _pulse1Controller,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulse1Scale.value,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.primary.withOpacity(_pulse1Opacity.value),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Pulse 2 halo
                          AnimatedBuilder(
                            animation: _pulse2Controller,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulse2Scale.value,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.primary.withOpacity(_pulse2Opacity.value),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Heart icon
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),

                    24.heightGap,

                    // Animated text
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: Transform.translate(
                            offset: Offset(0, _textOffset.value),
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
                        );
                      },
                    ),

                    48.heightGap,

                    // Animated card/button
                    AnimatedBuilder(
                      animation: _cardController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _cardOpacity.value,
                          child: Transform.scale(
                            scale: _cardScale.value,
                            child: Column(
                              children: [
                                AppButton(
                                  width: double.infinity,
                                  height: kBaseButtonHeight,
                                  label: "See Your Love Code",
                                  onPressed: () {
                                    // Navigate to results
                                  },
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    24.heightGap,
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
