import 'dart:developer';

import 'package:flutter/foundation.dart';

void appPrintGreen(dynamic data, {String? title}) {
  if (kDebugMode) {
    if (title != null) print('$title\n');

    print('\x1B[32m$data\x1B[0m');
    print('-----');
  }
}

void appPrintCyan(dynamic data, {String? title}) {
  if (kDebugMode) {
    if (title != null) print('$title\n');

    print('\x1B[36m$data\x1B[0m');
    print('-----');
  }
}

void appPrintRed(dynamic data, {String? title}) {
  if (kDebugMode) {
    if (title != null) print('$title\n');

    print('\x1B[31m$data\x1B[0m');
    print('-----');
  }
}
