//Copyright Victor Delamonica 2024
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class Logger {
  static Future<void> logInFirebase(String event, Map<String, Object?>? params) async {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.logEvent(name: event, parameters: params ?? {});
  }

  static void logInConsoleError(String message) {
    debugPrint('ERROR: $message');
  }

  static void logInConsoleWarning(String message) {
    debugPrint('WARNING: $message');
  }

  static void logInConsoleInfo(String message) {
    debugPrint('INFO: $message');
  }

  static void logInConsoleDebug(String message) {
    debugPrint('DEBUG: $message');
  }
}