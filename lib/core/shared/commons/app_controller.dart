import 'package:flutter/material.dart';

abstract class AppPageController {
  Future<void> initLoad(BuildContext context);
  Future<void> dispose();
}
