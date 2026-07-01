import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../services/language_service.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    FlutterNativeSplash.remove();

    // Oculta barras del sistema para splash full-screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 1.05, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2800), _navigate);
  }

  void _navigate() {
    if (!mounted) return;

    // Restaura barras del sistema al entrar a la app
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    final langService = Provider.of<LanguageService>(context, listen: false);
    final next = langService.hasSeenOnboarding
        ? const MainShell()
        : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, a, b) => next,
        transitionsBuilder: (context, anim, b, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF01286A),
      body: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: SizedBox.expand(
            child: Image.asset(
              'img/splash_screen.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }
}
