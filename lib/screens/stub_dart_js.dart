
// lib/screens/stub_dart_js.dart
// This is a stub file for non-web platforms.
import 'package:flutter/foundation.dart' show kIsWeb;

dynamic get context {
  if (kIsWeb) {
    throw UnimplementedError('dart:js context called on non-web, but kIsWeb is true. This is odd.');
  }
  throw UnimplementedError('dart:js context is not available on this platform.');
}

class JsObject {
  static dynamic jsify(Map<dynamic, dynamic> data) {
    if (kIsWeb) {
      throw UnimplementedError('JsObject.jsify stub called. This should be the real dart:js version on web.');
    }
    throw UnimplementedError('JsObject.jsify is not available on this platform.');
  }
}
