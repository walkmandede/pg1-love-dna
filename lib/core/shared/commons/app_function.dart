import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void dismissKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void vibrateNow() {
  try {
    unawaited(HapticFeedback.selectionClick());
  } catch (_) {}
}

class AppFunction {}
