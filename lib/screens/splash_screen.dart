import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/wave_background.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..forward();

    _timer = Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFDFCF8), Color(0xFFF5EFE7), Color(0xFFE8E6D8)],
          ),
        ),
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.bottomCenter,
              child: WaveBackground(height: 320),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ===== LOGO dari assets =====
                  FadeTransition(
                    opacity: CurvedAnimation(
                        parent: _ctrl, curve: const Interval(0, .5)),
                    child: ScaleTransition(
                      scale: Tween(begin: .85, end: 1.0).animate(
                          CurvedAnimation(
                              parent: _ctrl,
                              curve: const Interval(0, .6,
                                  curve: Curves.easeOutBack))),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Hiyote', style: AppTheme.serif(size: 42)),
                  const SizedBox(height: 18),
                  const Text(
                    'Ide tertata, momen terjaga.\nSemua cerita dalam satu tempat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, height: 1.6, color: AppColors.muted),
                  ),
                  const SizedBox(height: 28),
                  // progress bar
                  AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) => Container(
                      width: 150,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _ctrl.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              AppColors.sage,
                              AppColors.sageLight,
                            ]),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
