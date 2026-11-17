import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/app_illustrations.dart';
import 'ai_assistant_screen.dart';

class AIFeaturesIntroScreen extends StatelessWidget {
  const AIFeaturesIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3828), // Deep Forest Green from Screen 14
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Screen 14 Title
              const Text(
                'Features That Make\nYour Life Easier',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
              const Spacer(flex: 2),
              // Screen 14 Center 3D Robot Illustration with Glow
              const Center(
                child: RobotAssistantIllustration(size: 160),
              ),
              const Spacer(flex: 2),
              // 3 Feature Checkmark items
              _buildFeatureCheckItem('Get service recommendations'),
              const SizedBox(height: 14),
              _buildFeatureCheckItem('Ask about services'),
              const SizedBox(height: 14),
              _buildFeatureCheckItem('Find the best option for you'),
              const Spacer(flex: 2),
              // Start Chat Button (Rounded White pill button)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1B3828),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Start Chat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B3828),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCheckItem(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Color(0xFF4ADE80),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, size: 14, color: Color(0xFF1B3828)),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
