import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  var _navigated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() {
    Timer(const Duration(milliseconds: 1500), _navigateBasedOnAuth);
  }

  void _navigateBasedOnAuth() {
    if (!mounted || _navigated) return;
    final authState = ref.read(authProvider);
    _navigated = true;

    if (authState.isAuthenticated) {
      if (authState.needsPrivacyPolicy) {
        Navigator.pushReplacementNamed(context, '/privacy-policy');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Semantics(
            label: 'Radhika splash screen',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Radhika heart logo',
                  child: Icon(
                    Icons.favorite,
                    size: 96,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Semantics(
                  label: 'Radhika app name',
                  child: Text(
                    'Radhika',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: 'Tagline: Your Health Companion',
                  child: Text(
                    'Your Health Companion',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
