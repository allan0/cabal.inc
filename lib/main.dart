import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Config & Utils
import 'config.dart';
import 'utils/theme_manager.dart';
import 'utils/app_colors.dart';

// Services
import 'services/supabase_service.dart';
import 'services/ton_service.dart';
import 'audio/audio_controller.dart';
import 'features/wallet/application/wallet_provider.dart';
import 'services/web3_service.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/home_nav_wrapper.dart';
import 'screens/initial_loading_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env only on non-web platforms to prevent 404 build errors
  if (!ThemeData().platform.toString().contains('web')) {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint("Config: .env not found, using system environment.");
    }
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        Provider(create: (_) => SupabaseService()),
        Provider(create: (_) => Web3Service()..initialize()),
        Provider(create: (_) => TonService()..initialize()),
        ChangeNotifierProvider(
          create: (context) => WalletProvider(
            // WalletService is conditionally exported in core/services/wallet_service.dart
            context.read<SupabaseService>().walletService, 
            context.read<Web3Service>(),
          ),
        ),
        Provider(create: (_) => AudioController()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: AppConfig.appName,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: AppColors.background,
              primaryColor: AppColors.gold,
              colorScheme: const ColorScheme.dark(
                primary: AppColors.gold,
                secondary: AppColors.primaryAccent,
                surface: AppColors.surface,
                background: AppColors.background,
                error: AppColors.error,
              ),
              cardTheme: CardThemeData(
                color: AppColors.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
              ),
              textTheme: const TextTheme(
                headlineMedium: TextStyle(
                  color: AppColors.lightText, 
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
                bodyMedium: TextStyle(color: AppColors.lightText, fontSize: 16),
                bodySmall: TextStyle(color: AppColors.greyText, fontSize: 14),
              ),
            ),
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // 1. Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const InitialLoadingScreen();
        }

        final session = snapshot.data?.session;

        // 2. Authenticated State
        if (session != null) {
          return const HomeNavWrapper();
        }

        // 3. Unauthenticated State
        return const LoginScreen();
      },
    );
  }
}
