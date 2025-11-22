import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final Color bgColor;
  final Size size;
  const AppButton({super.key, required this.onPressed, required this.label, required this.bgColor, this.size = const Size(200, 50)});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(backgroundColor: bgColor),
        child: Text(label),
      ),
    );
  }
}
