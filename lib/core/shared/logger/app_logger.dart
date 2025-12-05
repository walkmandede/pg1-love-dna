import 'package:flutter/foundation.dart';

void appPrintGreen(dynamic data, {String? title}) {
  if (kDebugMode) {
    print('\x1B[32m$data\x1B[0m');
  }
}

void appPrintCyan(dynamic data, {String? title}) {
  if (kDebugMode) {
    print('\x1B[36m$data\x1B[0m');
  }
}

void appPrintRed(dynamic data, {String? title}) {
  if (kDebugMode) {
    print('\x1B[31m$data\x1B[0m');
  }
}
