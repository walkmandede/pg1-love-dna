import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pg1/core/shared/theme/app_color.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: AppColor.backgroundSecondary,
        shape: CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoActivityIndicator(
            color: AppColor.primary,
          ),
        ),
      ),
    );
  }
}
