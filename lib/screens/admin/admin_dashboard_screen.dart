import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryUltraLight,
              child: const Icon(Icons.person_rounded, size: 22, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen 13: 4 Metric Cards in a 2x2 Grid
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.people_alt_rounded,
                      iconBg: const Color(0xFFE0E7FF),
                      iconColor: const Color(0xFF4F46E5),
                      title: 'Total Users',
                      value: '1,250',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.calendar_today_rounded,
                      iconBg: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFFD97706),
                      title: 'Total Bookings',
                      value: '3,420',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.miscellaneous_services_rounded,
                      iconBg: const Color(0xFFE6F5EC),
                      iconColor: AppColors.statusConfirmed,
                      title: 'Total Services',
                      value: '24',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.attach_money_rounded,
                      iconBg: const Color(0xFFFFFBEB),
                      iconColor: const Color(0xFFB45309),
                      title: 'Revenue',
                      value: '\$12,540',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Screen 13: Bookings Overview Card with Line Chart
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bookings Overview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _AdminChartPainter(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Month labels
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Jan', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Text('Feb', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Text('Mar', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Text('Apr', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Text('May', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
                        Text('Jun', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Screen 13: Recent Bookings Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Bookings',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Showing all recent system bookings')),
                      );
                    },
                    child: const Text(
                      'See All →',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Recent Booking Item
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 48,
                        width: 48,
                        color: AppColors.primaryUltraLight,
                        child: const Icon(Icons.cleaning_services_rounded,
                            color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Home Cleaning',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Today • 10:00 AM',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.statusPendingBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Pending',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.statusPending,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F4EE)
      ..strokeWidth = 1;

    canvas.drawLine(Offset(0, h * 0.25), Offset(w, h * 0.25), gridPaint);
    canvas.drawLine(Offset(0, h * 0.5), Offset(w, h * 0.5), gridPaint);
    canvas.drawLine(Offset(0, h * 0.75), Offset(w, h * 0.75), gridPaint);

    // Data points: Jan, Feb, Mar, Apr, May, Jun
    final points = [
      Offset(0, h * 0.8),
      Offset(w * 0.2, h * 0.65),
      Offset(w * 0.4, h * 0.55),
      Offset(w * 0.6, h * 0.6),
      Offset(w * 0.8, h * 0.25), // Peak in May
      Offset(w, h * 0.4),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p1.dx, p1.dy);
    }

    // Line Paint
    final linePaint = Paint()
      ..color = const Color(0xFF5D916C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Area Gradient under chart
    final fillPath = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x335D916C), Color(0x005D916C)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Draw dots at data points
    final dotPaint = Paint()..color = const Color(0xFF2D4F38);
    final dotInnerPaint = Paint()..color = Colors.white;

    for (final p in points) {
      canvas.drawCircle(p, 4.5, dotPaint);
      canvas.drawCircle(p, 2.5, dotInnerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
