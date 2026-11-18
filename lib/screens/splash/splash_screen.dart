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
            // Top-left decorative leaf sprigs
            Positioned(
              top: 8,
              left: 10,
              child: Opacity(
                opacity: 0.7,
                child: Icon(Icons.eco_rounded, size: 44, color: AppColors.accent.withValues(alpha: 0.45)),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Modern ServiceHub Logo
                  const ServiceHubLogo(
                    iconSize: 56,
                    fontSize: 28,
                    showTagline: true,
                  ),
                  const Spacer(flex: 2),
                  // Charming House on Grassy Hill with winding path
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: HouseWithGardenIllustration(height: 160),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your Trusted\nService Booking Partner',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.3,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find & book the best services\nnear you with ease.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Circular loading indicator
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.8,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF86EFAC)),
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
