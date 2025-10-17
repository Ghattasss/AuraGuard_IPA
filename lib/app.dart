// استيراد المكتبات المطلوبة
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/splash_view.dart';
import 'views/onboarding_view.dart';
import 'views/ios_privacy_onboarding_view.dart';
import 'views/home_view.dart';
import 'views/video_player_view.dart';

// تطبيق بسيط بدون خدمات - يربط شاشة البداية بشاشة التعريف (MVC: Views فقط الآن)
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A651),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      // Arabic locale + RTL globally
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashView(),
        '/onboarding': (context) => const OnboardingView(),
        '/ios-privacy': (context) => const IosPrivacyOnboardingView(),
        '/home': (context) => const HomeView(),
        '/video-player': (context) => const VideoPlayerView(),
      },
    );
  }
}
