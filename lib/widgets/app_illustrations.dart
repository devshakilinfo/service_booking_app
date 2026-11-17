import 'package:flutter/material.dart';
import '../core/constants.dart';

/// ServiceHub Brand Logo (House with roof leaf + text)
class ServiceHubLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final bool showTagline;
  final bool isHorizontal;
  final Color? color;

  const ServiceHubLogo({
    super.key,
    this.iconSize = 44,
    this.fontSize = 24,
    this.showTagline = false,
    this.isHorizontal = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppColors.primary;

    final iconWidget = SizedBox(
      width: iconSize,
      height: iconSize,
      child: CustomPaint(
        painter: _HouseLeafPainter(color: logoColor),
      ),
    );

    final textWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isHorizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          'ServiceHub',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: logoColor,
            letterSpacing: -0.3,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 3),
          const Text(
            'Book • Manage • Live Better',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ],
    );

    if (isHorizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: 10),
          textWidget,
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget,
        const SizedBox(height: 8),
        textWidget,
      ],
    );
  }
}

class _HouseLeafPainter extends CustomPainter {
  final Color color;

  _HouseLeafPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw Roof
    final roof = Path();
    roof.moveTo(size.width * 0.15, size.height * 0.50);
    roof.lineTo(size.width * 0.50, size.height * 0.20);
    roof.lineTo(size.width * 0.85, size.height * 0.50);
    canvas.drawPath(roof, strokePaint);

    // Draw House Walls
    final walls = Path();
    walls.moveTo(size.width * 0.25, size.height * 0.50);
    walls.lineTo(size.width * 0.25, size.height * 0.82);
    walls.lineTo(size.width * 0.75, size.height * 0.82);
    walls.lineTo(size.width * 0.75, size.height * 0.50);
    canvas.drawPath(walls, strokePaint);

    // Draw Window / Door in center
    final windowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.65),
        width: size.width * 0.22,
        height: size.height * 0.22,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(windowRect, strokePaint);

    // Draw Sprouting Leaf on Right Roof
    final leaf = Path();
    leaf.moveTo(size.width * 0.70, size.height * 0.32);
    leaf.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.15,
      size.width * 0.92,
      size.height * 0.40,
    );
    leaf.quadraticBezierTo(
      size.width * 0.78,
      size.height * 0.45,
      size.width * 0.70,
      size.height * 0.32,
    );
    canvas.drawPath(leaf, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Charming House with Trees and Grassy Hill Illustration
class HouseWithGardenIllustration extends StatelessWidget {
  final double height;
  final double width;

  const HouseWithGardenIllustration({
    super.key,
    this.height = 140,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width == double.infinity ? null : width,
      child: CustomPaint(
        painter: _HouseGardenPainter(),
      ),
    );
  }
}

class _HouseGardenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Soft Green Hill Background
    final hillPaint = Paint()
      ..color = const Color(0xFFD6E8D2)
      ..style = PaintingStyle.fill;

    final hill = Path();
    hill.moveTo(0, h * 0.85);
    hill.quadraticBezierTo(w * 0.25, h * 0.60, w * 0.5, h * 0.68);
    hill.quadraticBezierTo(w * 0.75, h * 0.76, w, h * 0.65);
    hill.lineTo(w, h);
    hill.lineTo(0, h);
    hill.close();
    canvas.drawPath(hill, hillPaint);

    // Foreground Darker Hill
    final fgHillPaint = Paint()
      ..color = const Color(0xFFBEDABE)
      ..style = PaintingStyle.fill;

    final fgHill = Path();
    fgHill.moveTo(0, h * 0.80);
    fgHill.quadraticBezierTo(w * 0.4, h * 0.72, w * 0.7, h * 0.88);
    fgHill.quadraticBezierTo(w * 0.85, h * 0.95, w, h * 0.82);
    fgHill.lineTo(w, h);
    fgHill.lineTo(0, h);
    fgHill.close();
    canvas.drawPath(fgHill, fgHillPaint);

    // Trees on sides
    _drawTree(canvas, Offset(w * 0.22, h * 0.58), 24, const Color(0xFF5A8E62));
    _drawTree(canvas, Offset(w * 0.14, h * 0.66), 18, const Color(0xFF436E49));
    _drawTree(canvas, Offset(w * 0.78, h * 0.60), 26, const Color(0xFF5A8E62));
    _drawTree(canvas, Offset(w * 0.87, h * 0.68), 20, const Color(0xFF385A3D));

    // House in Center
    final houseCenter = Offset(w * 0.5, h * 0.62);
    final houseW = 68.0;
    final houseH = 46.0;

    // House Walls
    final wallPaint = Paint()..color = const Color(0xFFFFFDF8);
    final wallRect = Rect.fromCenter(
      center: Offset(houseCenter.dx, houseCenter.dy + 8),
      width: houseW,
      height: houseH,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(wallRect, const Radius.circular(4)), wallPaint);

    // Roof
    final roofPaint = Paint()..color = const Color(0xFF6B8A6E);
    final roof = Path();
    roof.moveTo(houseCenter.dx - houseW * 0.62, houseCenter.dy - 12);
    roof.lineTo(houseCenter.dx, houseCenter.dy - 32);
    roof.lineTo(houseCenter.dx + houseW * 0.62, houseCenter.dy - 12);
    roof.close();
    canvas.drawPath(roof, roofPaint);

    // Chimney
    final chimneyPaint = Paint()..color = const Color(0xFF4C6A50);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(houseCenter.dx + 16, houseCenter.dy - 34, 8, 16),
        const Radius.circular(2),
      ),
      chimneyPaint,
    );

    // Door
    final doorPaint = Paint()..color = const Color(0xFF88634B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(houseCenter.dx - 6, houseCenter.dy + 12, 12, 20),
        const Radius.circular(2),
      ),
      doorPaint,
    );

    // Windows
    final winPaint = Paint()..color = const Color(0xFF89BFDE);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(houseCenter.dx - 24, houseCenter.dy + 6, 11, 11),
        const Radius.circular(2),
      ),
      winPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(houseCenter.dx + 13, houseCenter.dy + 6, 11, 11),
        const Radius.circular(2),
      ),
      winPaint,
    );
  }

  void _drawTree(Canvas canvas, Offset pos, double radius, Color color) {
    // Trunk
    final trunk = Paint()
      ..color = const Color(0xFF75513B)
      ..strokeWidth = radius * 0.25
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(pos, Offset(pos.dx, pos.dy + radius * 1.1), trunk);

    // Foliage
    final foliage = Paint()..color = color;
    canvas.drawCircle(pos, radius, foliage);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D Styled Cute Robot Assistant Illustration
class RobotAssistantIllustration extends StatelessWidget {
  final double size;

  const RobotAssistantIllustration({super.key, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RobotPainter(),
      ),
    );
  }
}

class _RobotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.52);
    final r = size.width * 0.38;

    // Glowing circle halo background
    final haloPaint = Paint()
      ..color = const Color(0x334ADE80)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, r * 1.15, haloPaint);

    // Outer Headphones / Ears
    final earPaint = Paint()..color = const Color(0xFF2E6342);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx - r * 1.05, center.dy),
          width: r * 0.35,
          height: r * 0.75,
        ),
        const Radius.circular(8),
      ),
      earPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + r * 1.05, center.dy),
          width: r * 0.35,
          height: r * 0.75,
        ),
        const Radius.circular(8),
      ),
      earPaint,
    );

    // Headband
    final headBandPaint = Paint()
      ..color = const Color(0xFF2E6342)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.2
      ..strokeCap = StrokeCap.round;
    final bandPath = Path();
    bandPath.moveTo(center.dx - r * 0.95, center.dy - r * 0.1);
    bandPath.quadraticBezierTo(center.dx, center.dy - r * 1.25, center.dx + r * 0.95, center.dy - r * 0.1);
    canvas.drawPath(bandPath, headBandPaint);

    // Robot Head (White glossy oval)
    final headPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: r * 1.85, height: r * 1.5),
        Radius.circular(r * 0.6),
      ),
      headPaint,
    );

    // Dark Visor Face Screen
    final visorPaint = Paint()..color = const Color(0xFF13221A);
    final visorRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 4), width: r * 1.45, height: r * 0.95),
      Radius.circular(r * 0.4),
    );
    canvas.drawRRect(visorRect, visorPaint);

    // Glowing Eyes
    final eyePaint = Paint()..color = const Color(0xFF4ADE80);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx - r * 0.38, center.dy + 4), width: r * 0.35, height: r * 0.4),
        const Radius.circular(6),
      ),
      eyePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx + r * 0.38, center.dy + 4), width: r * 0.35, height: r * 0.4),
        const Radius.circular(6),
      ),
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
