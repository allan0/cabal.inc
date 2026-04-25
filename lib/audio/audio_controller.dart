// lib/audio/audio_controller.dart

// This is a conditional export. It tells Dart:
// - By default, export the code from 'audio_controller_mobile.dart'.
// - BUT, if the app is being compiled for web (where 'dart.library.html' exists),
//   export the code from 'audio_controller_stub.dart' instead.
export 'audio_controller_mobile.dart' if (dart.library.html) 'audio_controller_stub.dart';
