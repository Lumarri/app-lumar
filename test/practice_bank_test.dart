import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumar_academy/src/curriculum.dart';
import 'package:lumar_academy/src/practice_bank.dart';
import 'package:lumar_academy/src/progress.dart';

// Independent numerical checks derive results from the visible question,
// rather than trusting the correct index or the author's explanation.
double numeric(String value) {
  var s = value.split(' ').first.replaceAll('°', '').replaceAll(',', '.');
  final parts = s.split('/');
  double atom(String part) {
    if (part.contains('√')) {
      final pair = part.split('√');
      return (pair.first.isEmpty ? 1 : double.parse(pair.first)) *
          math.sqrt(double.parse(pair.last));
    }
    if (part.contains('π')) {
      final factor = part.replaceAll('π', '');
      return (factor.isEmpty ? 1 : double.parse(factor)) * math.pi;
    }
    return double.parse(part.replaceAll('−', '-'));
  }

  return atom(parts.first) / (parts.length == 1 ? 1 : atom(parts.last));
}

List<int> numbers(String question) =>
    RegExp(r'\d+').allMatches(question).map((m) => int.parse(m[0]!)).toList();

void check(Exercise exercise, num expected) {
  final matches = exercise.options
      .where((option) => (numeric(option) - expected).abs() < 1e-8)
      .toList();
  expect(matches, hasLength(1), reason: exercise.question);
  expect(
    numeric(exercise.options[exercise.correct]),
    closeTo(expected, 1e-8),
    reason: exercise.question,
  );
}

void main() {
  test('New operations, substitutions, equations and powers have correct arithmetic', () {
    for (final e in extraOperations) {
      final n = numbers(e.question);
      final result = e.question.startsWith('−')
          ? -n[0] + n[1]
          : e.question.startsWith('(')
          ? (n[0] + n[1]) * n[2]
          : n[0] + n[1] * n[2];
      check(e, result);
    }
    for (final e in extraVariables) {
      final n = numbers(e.question);
      if (e.question.contains('coeficiente')) {
        // The other choices include a variable, so compare the correct numeric choice only.
        expect(e.options[e.correct], '${n.first}');
      } else {
        check(e, e.question.contains('−') ? n[1] - n[0] : n[0] * n[1] + n[2]);
      }
    }
    for (final e in extraEquations) {
      final n = numbers(e.question);
      if (e.question.startsWith('Resuelve x')) {
        check(e, n[1] - n[0]);
      } else {
        check(e, n.length == 3 ? (n[2] - n[1]) / n[0] : n[1] / n[0]);
      }
    }
    for (final e in extraPowers) {
      if (e.question.startsWith('Calcula')) {
        check(e, math.pow(numbers(e.question).first, 2));
      } else {
        final n = numbers(e.question);
        final power = e.question.contains('×') ? n[0] + n[1] : n[0] * n[1];
        expect(e.options[e.correct], 'x^$power', reason: e.question);
      }
    }
  });

  test('New geometry angle, circle, Pythagoras and volume answers match their data', () {
    for (final e in extraGeoAngles) {
      final angle = numbers(e.question).first;
      check(
        e,
        e.question.contains('suplemento')
            ? 180 - angle
            : e.question.contains('complemento')
            ? 90 - angle
            : angle,
      );
    }
    for (final e in extraGeoTriangles) {
      final n = numbers(e.question);
      check(
        e,
        e.question.contains('isósceles')
            ? 180 - 2 * n.first
            : 180 - n[0] - n[1],
      );
    }
    for (final e in extraGeoCircle) {
      final n = numbers(e.question).first;
      check(
        e,
        e.question.contains('área')
            ? math.pi * n * n
            : e.question.contains('circunferencia')
            ? math.pi * n
            : 2 * n,
      );
    }
    for (final e in extraGeoPythagoras) {
      final n = numbers(e.question);
      check(
        e,
        e.question.startsWith('Los catetos')
            ? math.sqrt(n[0] * n[0] + n[1] * n[1])
            : math.sqrt(n[0] * n[0] - n[1] * n[1]),
      );
    }
    for (final e in extraGeoSolids) {
      final n = numbers(e.question);
      check(
        e,
        e.question.contains('cubo')
            ? math.pow(n[0], 3)
            : e.question.contains('cilindro')
            ? math.pi * n[0] * n[0] * n[1]
            : n[0] * n[1] * n[2],
      );
    }
  });

  test('New trigonometric ratios, conversions and special angles are numerically correct', () {
    for (final e in extraTrigRatios) {
      final n = numbers(e.question);
      check(
        e,
        e.question.contains('sen θ')
            ? n[0] / n[2]
            : e.question.contains('cos θ')
            ? n[1] / n[2]
            : n[0] / n[1],
      );
    }
    for (final e in extraTrigRadians) {
      final given = e.question.substring('Convierte '.length).split(' ').first;
      check(
        e,
        e.question.contains('a radianes')
            ? numeric(given) * math.pi / 180
            : numeric(given) * 180 / math.pi,
      );
    }
    for (final e in extraTrigSpecial) {
      final n = numbers(e.question);
      if (e.question.startsWith('Un triángulo')) {
        check(e, n[0] * math.sin(n[1] * math.pi / 180));
      } else {
        final angle = n.first * math.pi / 180;
        check(
          e,
          e.question.contains('sen')
              ? math.sin(angle)
              : e.question.contains('cos')
              ? math.cos(angle)
              : math.tan(angle),
        );
      }
    }
  });

  test('Areas, unit-circle identities and real-world heights use the correct measurements', () {
    for (final e in extraGeoPerimeter) {
      final n = numbers(e.question);
      check(
        e,
        e.question.contains('perímetro')
            ? 2 * (n[0] + n[1])
            : e.question.contains('triángulo')
            ? n[0] * n[1] / 2
            : n[0] * n[1],
      );
    }
    for (final e in extraTrigCircle.where(
      (e) => e.question.startsWith('θ es agudo'),
    )) {
      final n = numbers(e.question);
      check(e, math.sqrt(1 - math.pow(n[0] / n[1], 2)));
    }
    for (final e in extraTrigApplications) {
      if (e.question.startsWith('Tus ojos')) {
        final distance = int.parse(
          RegExp(r'A (\d+) m horizontales').firstMatch(e.question)![1]!,
        );
        check(e, distance + 1.5);
      } else {
        final n = numbers(e.question);
        check(
          e,
          e.question.contains('escalera')
              ? n[0] * math.sin(n[1] * math.pi / 180)
              : n[0] * math.tan(n[1] * math.pi / 180),
        );
      }
    }
  });

  test(
    'Exercise 20 in every stage survives reload with old exercise IDs intact',
    () async {
      SharedPreferences.setMockInitialValues({
        'lumar.progress.v1': '{"solved":["operations:0","geo_angles:2","trig_ratios:1"],"tutor":"kurisu"}',
      });
      final progress = await AcademyProgress.load();
      for (final lesson in allLessons) {
        await progress.solve(lesson, 19);
      }
      final restored = await AcademyProgress.load();
      expect(restored.solved, progress.solved);
      expect(restored.solved, hasLength(22));
      expect(
        restored.solved,
        containsAll(['operations:0', 'geo_angles:2', 'trig_ratios:1']),
      );
      expect(restored.total, 380);
      expect(restored.mastered(algebraLessons.first), isFalse);
    },
  );
}
