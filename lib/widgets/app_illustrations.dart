import 'package:flutter/material.dart';
import '../core/constants.dart';

class ServiceHubLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final bool showTagline;
  final bool isHorizontal;
  final Color? color;

  const ServiceHubLogo({
    super.key,
    this.iconSize = 44,
    this.fontSize = 22,
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
        painter: _HouseCradleLeafPainter(color: logoColor),
      ),
    );

    final textWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isHorizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Service',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: logoColor,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              'Hub',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF65A30D), 
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 3),
          const Text(
            'Book • Manage • Live Better',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(width: 8),
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

class _HouseCradleLeafPainter extends CustomPainter {
  final Color color;

  _HouseCradleLeafPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFF65A30D)
      ..style = PaintingStyle.fill;

    final roof = Path();
    roof.moveTo(w * 0.15, h * 0.45);
    roof.lineTo(w * 0.50, h * 0.18);
    roof.lineTo(w * 0.85, h * 0.45);
    canvas.drawPath(roof, strokePaint);

    final walls = Path();
    walls.moveTo(w * 0.25, h * 0.45);
    walls.lineTo(w * 0.25, h * 0.70);
    walls.lineTo(w * 0.75, h * 0.70);
    walls.lineTo(w * 0.75, h * 0.45);
    canvas.drawPath(walls, strokePaint);

    final winRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.52), width: w * 0.22, height: h * 0.22);
    canvas.drawRRect(RRect.fromRectAndRadius(winRect, const Radius.circular(2)), strokePaint);

    final leaf = Path();
    leaf.moveTo(w * 0.15, h * 0.74);
    leaf.quadraticBezierTo(w * 0.5, h * 0.95, w * 0.95, h * 0.55);
    leaf.quadraticBezierTo(w * 0.70, h * 0.88, w * 0.15, h * 0.74);
    leaf.close();
    canvas.drawPath(leaf, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HouseWithGardenIllustration extends StatelessWidget {
  final double height;
  final double width;

  const HouseWithGardenIllustration({
    super.key,
    this.height = 160,
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

    final pathPaint = Paint()
      ..color = const Color(0xFFF3ECE0)
      ..style = PaintingStyle.fill;
    final pathway = Path();
    pathway.moveTo(w * 0.48, h * 0.75);
    pathway.quadraticBezierTo(w * 0.52, h * 0.88, w * 0.40, h);
    pathway.lineTo(w * 0.60, h);
    pathway.quadraticBezierTo(w * 0.58, h * 0.88, w * 0.52, h * 0.75);
    pathway.close();
    canvas.drawPath(pathway, pathPaint);

    _drawTree(canvas, Offset(w * 0.18, h * 0.55), 26, const Color(0xFF5A8E62));
    _drawTree(canvas, Offset(w * 0.10, h * 0.64), 18, const Color(0xFF436E49));
    _drawTree(canvas, Offset(w * 0.80, h * 0.58), 26, const Color(0xFF5A8E62));
    _drawTree(canvas, Offset(w * 0.90, h * 0.66), 20, const Color(0xFF385A3D));

    final houseCenter = Offset(w * 0.5, h * 0.60);
    const houseW = 76.0;
    const houseH = 50.0;

    final wallPaint = Paint()..color = const Color(0xFFFFFDF8);
    final wallRect = Rect.fromCenter(
      center: Offset(houseCenter.dx, houseCenter.dy + 8),
      width: houseW,
      height: houseH,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(wallRect, const Radius.circular(4)), wallPaint);

    final roofPaint = Paint()..color = const Color(0xFF547A57);
    final roof = Path();
    roof.moveTo(houseCenter.dx - houseW * 0.62, houseCenter.dy - 14);
    roof.lineTo(houseCenter.dx, houseCenter.dy - 36);
    roof.lineTo(houseCenter.dx + houseW * 0.62, houseCenter.dy - 14);
    roof.close();
    canvas.drawPath(roof, roofPaint);

    final chimneyPaint = Paint()..color = const Color(0xFF4C6A50);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(houseCenter.dx + 18, houseCenter.dy - 38, 9, 18),
        const Radius.circular(2),
      ),
      chimneyPaint,
    );

    final doorPaint = Paint()..color = const Color(0xFF88634B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(houseCenter.dx - 7, houseCenter.dy + 12, 14, 22),
        const Radius.circular(3),
      ),
      doorPaint,
    );

    final winPaint = Paint()..color = const Color(0xFF89BFDE);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(houseCenter.dx - 26, houseCenter.dy + 8, 12, 12),
        const Radius.circular(2),
      ),
      winPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(houseCenter.dx + 14, houseCenter.dy + 8, 12, 12),
        const Radius.circular(2),
      ),
      winPaint,
    );
  }

  void _drawTree(Canvas canvas, Offset pos, double radius, Color color) {
    final trunk = Paint()
      ..color = const Color(0xFF75513B)
      ..strokeWidth = radius * 0.25
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(pos, Offset(pos.dx, pos.dy + radius * 1.1), trunk);

    final foliage = Paint()..color = color;
    canvas.drawCircle(pos, radius, foliage);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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

    final haloPaint = Paint()
      ..color = const Color(0x334ADE80)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, r * 1.15, haloPaint);

    final earPaint = Paint()..color = const Color(0xFF2E6342);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx - r * 1.05, center.dy), width: r * 0.35, height: r * 0.75),
        const Radius.circular(8),
      ),
      earPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx + r * 1.05, center.dy), width: r * 0.35, height: r * 0.75),
        const Radius.circular(8),
      ),
      earPaint,
    );

    final headBandPaint = Paint()
      ..color = const Color(0xFF2E6342)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.2
      ..strokeCap = StrokeCap.round;
    final bandPath = Path();
    bandPath.moveTo(center.dx - r * 0.95, center.dy - r * 0.1);
    bandPath.quadraticBezierTo(center.dx, center.dy - r * 1.25, center.dx + r * 0.95, center.dy - r * 0.1);
    canvas.drawPath(bandPath, headBandPaint);

    final headPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: r * 1.85, height: r * 1.5),
        Radius.circular(r * 0.6),
      ),
      headPaint,
    );

    final visorPaint = Paint()..color = const Color(0xFF13221A);
    final visorRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 4), width: r * 1.45, height: r * 0.95),
      Radius.circular(r * 0.4),
    );
    canvas.drawRRect(visorRect, visorPaint);

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

class AdminWeeklyBarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final values = [0.35, 0.55, 0.50, 0.70, 0.65, 0.95, 0.60];
    final barW = (w / values.length) * 0.55;
    final gap = w / values.length;

    for (int i = 0; i < values.length; i++) {
      final barH = h * values[i];
      final x = (i * gap) + (gap - barW) / 2;
      final y = h - barH;

      final isPeak = i == 5; 
      final barPaint = Paint()
        ..color = isPeak ? const Color(0xFF2D4F38) : const Color(0xFF86EFAC)
        ..style = PaintingStyle.fill;

      final barRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barW, barH),
        const Radius.circular(6),
      );
      canvas.drawRRect(barRRect, barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AdminMonthlyLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final points = [
      Offset(0, h * 0.75),
      Offset(w * 0.25, h * 0.62),
      Offset(w * 0.50, h * 0.68),
      Offset(w * 0.75, h * 0.45),
      Offset(w, h * 0.25),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cp1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final cp2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x334ADE80), Color(0x004ADE80)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF2D4F38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = const Color(0xFF2D4F38);
    final dotInner = Paint()..color = const Color(0xFF4ADE80);

    for (final p in points) {
      canvas.drawCircle(p, 5.0, dotPaint);
      canvas.drawCircle(p, 3.0, dotInner);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
