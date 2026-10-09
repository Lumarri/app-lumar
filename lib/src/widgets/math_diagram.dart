import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../curriculum.dart';
import '../widgets.dart';

/// Code-drawn teaching figures. Labels refer to the solved example, not a quiz.
class MathDiagram extends StatelessWidget {
  const MathDiagram({super.key, required this.lesson});
  final Lesson lesson;
  static const descriptions = {
    'geo_angles': 'Un ángulo recto dividido en 35° y 55°.',
    'geo_triangles': 'Triángulo con ángulos interiores de 50°, 60° y 70°.',
    'geo_perimeter': 'Rectángulo de base 6 cm y altura 4 cm.',
    'geo_circle': 'Círculo con radio de 3 cm desde el centro al borde.',
    'geo_pythagoras':
        'Triángulo rectángulo de catetos 3 y 4 cm, hipotenusa 5 cm.',
    'geo_solids': 'Prisma rectangular de dimensiones 5, 3 y 2 cm.',
    'trig_sides': 'Triángulo ABC, recto en B: AB = 3, BC = 4 y AC = 5.',
    'trig_ratios': 'Desde θ: opuesto 3, adyacente 4 e hipotenusa 5.',
    'trig_radians': 'Un giro de 60° o π/3 radianes desde el eje horizontal.',
    'trig_special': 'Triángulo 30°–60°–90°: lados 1, raíz de 3 y 2.',
    'trig_circle': 'Círculo unitario: punto (cos θ, sen θ), con radio 1.',
    'trig_applications': 'Torre: distancia horizontal 10 m, ángulo de elevación 45° y altura 10 m.',
  };

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: descriptions[lesson.id],
    child: Panel(
      color: const Color(0xFFF8F0FF),
      child: Column(
        children: [
          Text(
            'Dibuja la idea',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(painter: _FigurePainter(lesson.id)),
          ),
          Text(descriptions[lesson.id]!, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          const Text(
            'Esquema del ejemplo; no está a escala.',
            style: TextStyle(color: muted, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}

class _FigurePainter extends CustomPainter {
  _FigurePainter(this.id);
  final String id;

  @override
  void paint(Canvas canvas, Size size) {
    // Fixed coordinates scaled uniformly; labels remain within the canvas.
    final scale = math.min(size.width / 300, size.height / 200);
    canvas.translate(
      (size.width - 300 * scale) / 2,
      (size.height - 200 * scale) / 2,
    );
    canvas.scale(scale);
    final pen = Paint()
      ..color = violet
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final accent = Paint()
      ..color = rose
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    void line(Offset a, Offset b, [bool pink = false]) =>
        canvas.drawLine(a, b, pink ? accent : pen);
    void label(String text, double x, double y) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontFamilyFallback: ['NotoSansMath'],
            color: ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 160);
      painter.paint(canvas, Offset(x, y));
    }

    void triangle() {
      canvas.drawPath(
        Path()
          ..moveTo(55, 160)
          ..lineTo(235, 160)
          ..lineTo(235, 35)
          ..close(),
        pen,
      );
      canvas.drawPath(
        Path()
          ..moveTo(220, 160)
          ..lineTo(220, 145)
          ..lineTo(235, 145),
        accent,
      );
    }

    switch (id) {
      case 'geo_angles':
        line(const Offset(70, 160), const Offset(70, 35));
        line(const Offset(70, 160), const Offset(250, 160));
        line(const Offset(70, 160), const Offset(175, 50), true);
        label('35°', 76, 91);
        label('55°', 115, 132);
      case 'geo_triangles':
        canvas.drawPath(
          Path()
            ..moveTo(40, 160)
            ..lineTo(260, 160)
            ..lineTo(150, 30)
            ..close(),
          pen,
        );
        label('50°', 66, 133);
        label('60°', 212, 133);
        label('70°', 136, 62);
      case 'geo_perimeter':
        canvas.drawRect(const Rect.fromLTWH(55, 45, 180, 115), pen);
        label('6 cm', 127, 165);
        label('4 cm', 241, 88);
      case 'geo_solids':
        canvas.drawRect(const Rect.fromLTWH(50, 80, 165, 80), pen);
        canvas.drawPath(
          Path()
            ..moveTo(50, 80)
            ..lineTo(90, 40)
            ..lineTo(255, 40)
            ..lineTo(255, 120)
            ..lineTo(215, 160)
            ..moveTo(215, 80)
            ..lineTo(255, 40),
          pen,
        );
        label('5 cm', 115, 165);
        label('2 cm', 5, 106);
        label('3 cm', 240, 138);
      case 'geo_circle':
        canvas.drawCircle(const Offset(150, 95), 75, pen);
        line(const Offset(150, 95), const Offset(225, 95), true);
        canvas.drawCircle(const Offset(150, 95), 3, Paint()..color = rose);
        label('r = 3 cm', 150, 102);
      case 'trig_radians':
      case 'trig_circle':
        canvas.drawCircle(const Offset(150, 100), seventy, pen);
        line(const Offset(60, 100), const Offset(245, 100));
        line(const Offset(150, 185), const Offset(150, 15));
        final angle = id == 'trig_radians' ? math.pi / 3 : math.pi / 4;
        final point = Offset(
          150 + seventy * math.cos(angle),
          100 - seventy * math.sin(angle),
        );
        line(const Offset(150, 100), point, true);
        canvas.drawCircle(point, 4, Paint()..color = rose);
        label(id == 'trig_radians' ? '60° = π/3' : '(cos θ, sen θ)', 166, 12);
        label(id == 'trig_circle' ? 'r = 1' : '0°', 175, 107);
      default:
        triangle();
        switch (id) {
          case 'geo_pythagoras':
            label('4 cm', 133, 166);
            label('3 cm', 242, 90);
            label('5 cm', 115, 65);
          case 'trig_sides':
            label('A', 35, 160);
            label('B', 235, 165);
            label('C', 235, 12);
            label('AB = 3', 120, 165);
            label('BC = 4', 240, 90);
            label('AC = 5', 115, 65);
          case 'trig_ratios':
            label('θ', 78, 132);
            label('adyacente = 4', 102, 170);
            label('opuesto = 3', 190, 90);
            label('hipotenusa = 5', 65, 48);
          case 'trig_special':
            label('30°', 78, 130);
            label('√3', 135, 166);
            label('1', 242, 90);
            label('2', 127, 65);
            label('60°', 207, 69);
          case 'trig_applications':
            label('45°', 78, 132);
            label('10 m', 128, 166);
            label('10 m', 242, 90);
        }
    }
  }

  static const seventy = 70.0;
  @override
  bool shouldRepaint(_FigurePainter oldDelegate) => oldDelegate.id != id;
}
