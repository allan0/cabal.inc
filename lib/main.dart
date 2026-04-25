// lib/main.dart
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb, debugPrint;
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

// Import your new config helper
import 'config.dart';

// Core App Services & Features
import 'features/wallet/application/wallet_provider.dart';
import 'core/services/wallet_service.dart';
import 'core/services/coingecko_service.dart';
import 'data/repositories/coin_repository.dart';
import 'features/onboarding/application/onboarding_provider.dart';
import 'services/supabase_service.dart';
import 'services/news_service.dart';
import 'services/web3_service.dart';
import 'audio/audio_controller.dart';
import 'firebase_options.dart';

// UI & Theming
import 'screens/initial_loading_screen.dart';
import 'utils/app_colors.dart';
import 'utils/theme_manager.dart';

// --- Global Service Instances ---
final ThemeManager themeManager = ThemeManager();
final WalletService walletService = WalletService();
final Web3Service web3Service = Web3Service();
final CoinRepository coinRepository = CoinRepository(CoinGeckoService());
final NewsService newsService = NewsService();
final AudioController audioController = AudioController();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  Object? initializationError;

  // 1. Setup Logging
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });

  // 2. Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // --- THIS IS THE CORRECTED SECTION ---
    // Load .env file ONLY for mobile/desktop builds
    if (!kIsWeb) {
      await dotenv.dotenv.load(fileName: ".env");
    }

    // Use the AppConfig helper to get platform-specific variables
    final supabaseUrl = AppConfig.supabaseUrl;
    final supabaseAnonKey = AppConfig.supabaseAnonKey;

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
        'FATAL: Missing Supabase environment variables.'
      );
    }
    // --- END OF CORRECTION ---
    
    // 4. Initialize services that DON'T depend on a BuildContext
    await Future.wait([
      audioController.initialize(),
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey, debug: kDebugMode),
      // walletService.initialize() is REMOVED and called later from InitialLoadingScreen
      web3Service.initialize(),
    ]);
    
    debugPrint("Main: Core services (Firebase, Supabase, Web3, Audio) initialized.");

  } catch (e, s) {
    debugPrint("FATAL: One or more critical services failed to initialize: $e\n$s");
    initializationError = e;
  }

  // 5. Run the App with Providers
  runApp(
    MultiProvider(
      providers: [
        // --- Infrastructure & Services ---
        Provider.value(value: coinRepository),
        Provider.value(value: audioController),
        Provider.value(value: web3Service),
        
        // --- State Management Providers ---
        ChangeNotifierProvider(create: (_) => WalletProvider(walletService, web3Service)),
        ChangeNotifierProvider(create: (_) => OnboardingProvider(coinRepository, SupabaseService())),
      ],
      child: CabalApp(initializationError: initializationError),
    ),
  );
}

class CabalApp extends StatefulWidget {
  final Object? initializationError;
  const CabalApp({Key? key, this.initializationError}) : super(key: key);
  @override
  State<CabalApp> createState() => _CabalAppState();
}

class _CabalAppState extends State<CabalApp> {
  @override
  void initState() {
    super.initState();
    themeManager.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    themeManager.removeListener(_onThemeChanged);
    audioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Cabal',
      themeMode: themeManager.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primaryAccent,
          surface: AppColors.cardBackground,
          background: AppColors.background,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: AppColors.lightText,
          onSurface: AppColors.textPrimary,
          onBackground: AppColors.textPrimary,
          onError: Colors.white,
          primaryContainer: AppColors.primary.withOpacity(0.1),
          secondaryContainer: AppColors.primaryAccent.withOpacity(0.1),
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
          displayMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
          displaySmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary),
          headlineMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 16),
          bodyMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary, fontSize: 14),
          labelLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.primary, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary, fontSize: 12),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 1,
          iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
          titleTextStyle: TextStyle(color: AppColors.darkTextPrimary, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.primaryAccent.withOpacity(0.15),
          selectedColor: AppColors.primaryAccent,
          labelStyle: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
          secondaryLabelStyle: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Poppins'),
          checkmarkColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAccent,
            foregroundColor: AppColors.lightText,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.disabled.withOpacity(0.4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Poppins'),
          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.6), fontFamily: 'Poppins'),
          prefixIconColor: AppColors.primary.withOpacity(0.7),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.cardBackground,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary.withOpacity(0.7),
          elevation: 4,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
        ),
        navigationRailTheme: NavigationRailThemeData(
            backgroundColor: AppColors.background,
            selectedIconTheme: const IconThemeData(color: AppColors.primary),
            unselectedIconTheme: IconThemeData(color: AppColors.textSecondary.withOpacity(0.7)),
            selectedLabelTextStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            unselectedLabelTextStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7), fontFamily: 'Poppins'),
            indicatorColor: AppColors.primary.withOpacity(0.1),
        ),
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.darkPrimary,
        colorScheme: ColorScheme.dark(
          primary: AppColors.darkPrimary,
          secondary: AppColors.primaryAccent,
          surface: AppColors.darkCardBackground,
          background: AppColors.darkBackground,
          error: AppColors.error,
          onPrimary: AppColors.darkTextPrimary,
          onSecondary: AppColors.lightText,
          onSurface: AppColors.darkTextPrimary,
          onBackground: AppColors.darkTextPrimary,
          onError: Colors.white,
          primaryContainer: AppColors.darkPrimary.withOpacity(0.1),
          secondaryContainer: AppColors.primaryAccent.withOpacity(0.1),
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
          displayMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
          displaySmall: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary),
          headlineMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextPrimary, fontSize: 16),
          bodyMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextSecondary, fontSize: 14),
          labelLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.primaryAccent, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(fontFamily: 'Poppins', color: AppColors.darkTextSecondary, fontSize: 12),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 1,
          iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
          titleTextStyle: TextStyle(color: AppColors.darkTextPrimary, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        cardTheme: CardThemeData(
          color: AppColors.darkCardBackground,
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.primaryAccent.withOpacity(0.15),
          selectedColor: AppColors.primaryAccent,
          labelStyle: const TextStyle(color: AppColors.darkTextPrimary, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
          secondaryLabelStyle: const TextStyle(color: AppColors.darkTextPrimary, fontFamily: 'Poppins'),
          checkmarkColor: AppColors.darkTextPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAccent,
            foregroundColor: AppColors.lightText,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryAccent,
             textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.darkTextSecondary.withOpacity(0.4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.darkTextSecondary.withOpacity(0.6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.darkTextSecondary, fontFamily: 'Poppins'),
          hintStyle: TextStyle(color: AppColors.darkTextSecondary.withOpacity(0.6), fontFamily: 'Poppins'),
          prefixIconColor: AppColors.primaryAccent.withOpacity(0.7),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkCardBackground,
          selectedItemColor: AppColors.primaryAccent,
          unselectedItemColor: AppColors.darkTextSecondary.withOpacity(0.7),
          elevation: 4,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
        ),
        navigationRailTheme: NavigationRailThemeData(
            backgroundColor: AppColors.darkBackground,
            selectedIconTheme: const IconThemeData(color: AppColors.primaryAccent),
            unselectedIconTheme: IconThemeData(color: AppColors.darkTextSecondary.withOpacity(0.7)),
            selectedLabelTextStyle: const TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            unselectedLabelTextStyle: TextStyle(color: AppColors.darkTextSecondary.withOpacity(0.7), fontFamily: 'Poppins'),
            indicatorColor: AppColors.primaryAccent.withOpacity(0.1),
        ),
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: InitialLoadingScreen(initializationError: widget.initializationError),
    );
  }
}
