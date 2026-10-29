import 'package:flutter/material.dart';

/// Gelombang hijau di bagian bawah layar (Splash & Login)
class WaveBackground extends StatelessWidget {
  final double height;
  const WaveBackground({super.key, this.height = 260});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(painter: _WavePainter()),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    Path wave(double top, double amp, double phase) {
      final p = Path()..moveTo(0, s.height);
      p.lineTo(0, top);
      p.cubicTo(s.width * .25, top - amp + phase, s.width * .45, top + amp,
          s.width * .65, top - amp * .2 + phase);
      p.cubicTo(s.width * .82, top - amp * 1.1, s.width * .92, top - amp * .6,
          s.width, top - amp * .4);
      p.lineTo(s.width, s.height);
      p.close();
      return p;
    }

    canvas.drawPath(
        wave(s.height * .30, 40, 6), Paint()..color = const Color(0xFFE6E6D3));
    canvas.drawPath(
        wave(s.height * .50, 46, 0), Paint()..color = const Color(0xFFC3C9AD));
    canvas.drawPath(
        wave(s.height * .72, 38, 8), Paint()..color = const Color(0xFFE8E6D8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
