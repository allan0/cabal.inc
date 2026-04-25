// lib/config.dart

// This is a conditional export.
// It tells Dart to use the mobile version by default, but switch to the web
// version if the app is compiled for the web (where 'dart.library.html' exists).
export 'config_mobile.dart' if (dart.library.html) 'config_web.dart';
