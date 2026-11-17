import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_illustrations.dart';
import '../auth/login_screen.dart';
import '../main_navigation_screen.dart';
import '../onboarding/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAppEntry();
  }

  Future<void> _checkAppEntry() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAuthenticated = await authProvider.tryAutoLogin();

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding =
        prefs.getBool(AppConstants.onboardingSeenKey) ?? false;

    if (!mounted) return;

    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else if (!hasSeenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative subtle leaves in corner
            Positioned(
              top: 10,
              left: 10,
              child: Opacity(
                opacity: 0.6,
                child: Icon(Icons.eco_rounded, size: 40, color: AppColors.accent.withValues(alpha: 0.4)),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Screen 1: ServiceHub House-with-leaf logo + Tagline
                  const ServiceHubLogo(
                    iconSize: 58,
                    fontSize: 28,
                    showTagline: true,
                  ),
                  const Spacer(flex: 2),
                  // Screen 1: Charming House with green hill and trees illustration
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: HouseWithGardenIllustration(height: 150),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your Trusted\nService Booking Partner',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(flex: 1),
                  // Screen 1: Circular loading indicator
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.8,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
