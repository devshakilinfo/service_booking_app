import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/service_model.dart';
import '../../widgets/custom_button.dart';
import '../booking/booking_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image with back and heart chips
                  Stack(
                    children: [
                      Image.network(
                        service.image,
                        height: 290,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 290,
                          width: double.infinity,
                          color: AppColors.primaryUltraLight,
                          child: const Icon(Icons.cleaning_services_rounded,
                              size: 80, color: AppColors.primary),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 12,
                        left: 16,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: AppColors.textPrimary, size: 18),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 12,
                        right: 16,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.favorite_rounded,
                                color: AppColors.statusCancelled, size: 20),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Saved to your favorites!')),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Content Container
                  Container(
                    transform: Matrix4.translationValues(0, -20, 0),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              service.rating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${service.reviewsCount} reviews)',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              '\$${service.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  service.duration,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          service.description,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // 3 Feature Badges from Screen 7
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFeatureBadge(
                              Icons.person_outline_rounded,
                              'Experienced\nStaff',
                            ),
                            _buildFeatureBadge(
                              Icons.eco_outlined,
                              'Eco-Friendly\nProducts',
                            ),
                            _buildFeatureBadge(
                              Icons.verified_outlined,
                              '100%\nSatisfaction',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Action Bar: Book Now (70%) + Share (30%)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(top: BorderSide(color: AppColors.border)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CustomButton(
                        text: 'Book Now',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingScreen(service: service),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        text: 'Share',
                        icon: Icons.share_rounded,
                        isOutlined: true,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Service link copied to clipboard!')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String text) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE9F1E7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
