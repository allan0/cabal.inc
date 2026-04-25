// lib/core/services/wallet_service.dart

// This is a conditional import.
// It imports the mobile implementation by default.
// If the compilation target is web (where 'dart.library.html' exists),
// it will import the stub implementation instead.
export 'wallet_service_mobile.dart' if (dart.library.html) 'wallet_service_stub.dart';
