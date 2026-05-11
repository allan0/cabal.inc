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

// Screens
import 'screens/auth/login_screen.dart';
import 'home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/initial_loading_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Main: .env file not found.");
  }

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
        Provider(create: (_) => TonService()..initialize()), // Initialize here
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
                surface: AppColors.darkGrey,
              ),
              // FIXED: CardTheme to CardThemeData
              cardTheme: CardThemeData(
                color: AppColors.darkGrey,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              textTheme: const TextTheme(
                headlineMedium: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.bold),
                bodyMedium: TextStyle(color: AppColors.lightText),
                bodySmall: TextStyle(color: AppColors.greyText),
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
              '/profile': (context) => const ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _handleRouting();
  }

  Future<void> _handleRouting() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return;

    if (session != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const InitialLoadingScreen(initializationError: null);
  }
}
