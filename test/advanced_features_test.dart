import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumar_academy/src/app.dart';
import 'package:lumar_academy/src/curriculum.dart';
import 'package:lumar_academy/src/exercise_tutor.dart';
import 'package:lumar_academy/src/pose_catalog.dart';
import 'package:lumar_academy/src/progress.dart';
import 'package:lumar_academy/src/reactions.dart';
import 'package:lumar_academy/src/tutor_farewell.dart';

List<int> numbers(String s) =>
    RegExp(r'-?\d+').allMatches(s).map((m) => int.parse(m[0]!)).toList();
double value(String s) {
  final p = s.split('/');
  return double.parse(p.first) / (p.length == 1 ? 1 : double.parse(p.last));
}

Future<void> tap(WidgetTester tester, String label) async {
  final found = find.text(label).last;
  await tester.ensureVisible(found);
  await tester.pumpAndSettle();
  await tester.tap(found);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('Three new courses have fifty distinct exercises with full worked solutions', () {
    for (final lessons in [
      logarithmsLessons,
      advancedPowersLessons,
      quadraticsLessons,
    ]) {
      final lesson = lessons.single;
      expect(lesson.exercises, hasLength(50));
      expect(lesson.exercises.map((e) => e.question).toSet(), hasLength(50));
      for (final e in lesson.exercises) {
        expect(e.steps.length, greaterThanOrEqualTo(3));
        expect(e.hint, isNotEmpty);
        expect(e.explanation, isNotEmpty);
        expect(e.options.toSet(), hasLength(3));
        expect(e.errors[e.correct], isEmpty);
        for (var i = 0; i < 3; i++) {
          if (i != e.correct) expect(e.errors[i], isNotEmpty);
        }
      }
    }
  });
  test(
    'All log answers follow the definition, laws and strict real domain',
    () {
      for (final e in logarithmsLessons.single.exercises) {
        final n = numbers(e.question);
        final answer = e.options[e.correct];
        if (e.question.startsWith('Calcula') && !e.question.contains('(1/')) {
          final b = n[0], arg = n[1];
          expect(
            math.pow(b, value(answer)),
            closeTo(arg, 1e-8),
            reason: e.question,
          );
        } else if (e.question.startsWith('Resuelve')) {
          expect(value(answer), math.pow(n[0], n[1]), reason: e.question);
        } else if (e.question.contains('log_') && e.question.contains('(AB)')) {
          expect(value(answer), n[1] + n[3], reason: e.question);
        } else if (e.question.contains('(A/B)')) {
          expect(value(answer), n[1] - n[3], reason: e.question);
        } else if (e.question.contains('(A^')) {
          expect(value(answer), n[1] * n.last, reason: e.question);
        } else if (e.question.contains('dominio')) {
          expect(answer, 'x > ${n[1]}', reason: e.question);
        } else {
          expect(value(answer), -1, reason: e.question);
        }
      }
    },
  );
  test(
    'Power calculations and symbolic exponents use their correct operations',
    () {
      for (final e in advancedPowersLessons.single.exercises) {
        final n = numbers(e.question);
        final answer = e.options[e.correct];
        if (e.question.contains('a^')) {
          final expected = e.question.contains('×')
              ? n[0] + n[1]
              : e.question.contains(' / ')
              ? n[0] - n[1]
              : n[0] * n[1];
          expect(answer, 'a^$expected', reason: e.question);
        } else {
          final expected = e.question.contains('raíz real')
              ? math.pow(n[0], n[1] / n[2])
              : math.pow(n[0], n[1]);
          expect(value(answer), closeTo(expected, 1e-7), reason: e.question);
        }
      }
    },
  );
  test('Every quadratic root satisfies its equation, including both signs and physical constraints', () {
    for (final e in quadraticsLessons.single.exercises) {
      final answer = e.options[e.correct];
      if (e.question.startsWith('Un rectángulo')) {
        final n = numbers(e.question);
        final width = double.parse(answer.split(' ').first);
        expect(width, greaterThan(0));
        expect(width * (width + n[0]), n[1]);
        continue;
      }
      if (e.question.startsWith('Resuelve x² =')) {
        final n = numbers(e.question).single;
        final roots = RegExp(r'x = (-?\d+)')
            .allMatches(answer)
            .map((m) => int.parse(m[1]!))
            .toList();
        expect(roots, hasLength(2));
        for (final root in roots) {
          expect(root * root, n);
        }
        continue;
      }
      final aMatch = RegExp(r'(\d*)x²').firstMatch(e.question)!;
      final a = aMatch[1]!.isEmpty ? 1 : int.parse(aMatch[1]!);
      final bMatch = RegExp(r'([+−])\s*(\d*)x(?!²)').firstMatch(e.question);
      final b = bMatch == null
          ? 0
          : (bMatch[1] == '−' ? -1 : 1) *
                (bMatch[2]!.isEmpty ? 1 : int.parse(bMatch[2]!));
      final cMatch = RegExp(r'([+−])\s*(\d+)\s*= 0').firstMatch(e.question);
      final c = cMatch == null
          ? 0
          : (cMatch[1] == '−' ? -1 : 1) * int.parse(cMatch[2]!);
      final delta = b * b - 4 * a * c;
      if (e.question.startsWith('¿Qué tipo')) {
        expect(
          answer,
          delta > 0
              ? 'Dos soluciones reales distintas'
              : delta == 0
              ? 'Una solución real doble'
              : 'Sin soluciones reales',
        );
      } else {
        final roots = RegExp(r'x = (-?\d+)')
            .allMatches(answer)
            .map((m) => int.parse(m[1]!))
            .toSet();
        expect(roots, hasLength(delta > 0 ? 2 : 1));
        for (final root in roots) {
          expect(a * root * root + b * root + c, 0, reason: e.question);
        }
      }
    }
  });
  testWidgets(
    'All organized pose and farewell assets are bundled, including Hahari',
    (tester) async {
      final assets = {
        for (final p in newTutorPoses) p.asset,
        for (final a in farewellAssets.values) ...a,
        hahariWin,
        hahariWrong,
        hahariEleven,
      };
      await tester.runAsync(() async {
        for (final asset in assets) {
          expect(
            (await rootBundle.load(asset)).lengthInBytes,
            greaterThan(0),
            reason: asset,
          );
        }
      });
      for (final pose in newTutorPoses) {
        expect(pose.lines.toSet(), hasLength(2), reason: pose.asset);
      }
    },
  );
  test('Pose rules use semantic conditions and never suffix numbering', () {
    expect(
      choosePose(
        'kurisu',
        ExerciseReaction.observing,
        0,
        exerciseIndex: 17,
        mistakes: 0,
        streak: 0,
      )!.file,
      contains('tarea 10 y 18'),
    );
    expect(
      choosePose(
        'hakari',
        ExerciseReaction.wrong,
        0,
        exerciseIndex: 1,
        mistakes: 3,
        streak: 0,
      )!.minMistakes,
      3,
    );
    expect(
      choosePose(
        'hakari',
        ExerciseReaction.repeatedError,
        0,
        exerciseIndex: 1,
        mistakes: 7,
        streak: 0,
      )!.minMistakes,
      7,
    );
    expect(
      choosePose(
        'hakari',
        ExerciseReaction.streak,
        0,
        exerciseIndex: 1,
        mistakes: 0,
        streak: 20,
      )!.minStreak,
      20,
    );
    expect(
      choosePose(
        'yuno',
        ExerciseReaction.correct,
        0,
        exerciseIndex: 1,
        mistakes: 2,
        streak: 1,
      )!.recovered,
      isTrue,
    );
    expect(hahariAppears(8, false, 10, tutorId: 'hakari'), isFalse);
    expect(hahariAppears(9, false, 0, tutorId: 'hakari'), isTrue);
    expect(hahariImage(9, false, 0), hahariWrong);
    expect(hahariImage(9, true, 10), hahariWin);
    expect(hahariAppears(10, true, 10, tutorId: 'hakari'), isFalse);
    expect(hahariAppears(10, true, 11, tutorId: 'hakari'), isTrue);
    for (final tutor in ['kurisu', 'yuno', 'kotoko', 'karane']) {
      expect(hahariAppears(9, false, 0, tutorId: tutor), isFalse);
      expect(hahariAppears(9, true, 10, tutorId: tutor), isFalse);
      expect(hahariAppears(10, true, 11, tutorId: tutor), isFalse);
    }
  });
  testWidgets(
    'Hahari visits the actual tenth exercise after resume, with hint and error reactions',
    (tester) async {
      final progress = await AcademyProgress.load();
      await progress.setTutor('hakari');
      for (var i = 0; i < 9; i++) {
        await progress.solve(logarithmsLessons.single, i);
      }
      await tester.pumpWidget(LumarApp(progress: progress));
      tester
          .state<NavigatorState>(find.byType(Navigator).first)
          .push(
            MaterialPageRoute<void>(
              builder: (_) => PracticeScreen(
                lesson: logarithmsLessons.single,
                progress: progress,
              ),
            ),
          );
      await tester.pumpAndSettle();
      expect(
        tester.widget<ExerciseTutor>(find.byType(ExerciseTutor)).tutor.id,
        'hahari',
      );
      expect(progress.tutor, 'hakari');
      await tap(tester, 'Necesito una pista');
      expect(
        tester.widget<ExerciseTutor>(find.byType(ExerciseTutor)).reaction,
        ExerciseReaction.hint,
      );
      await tap(tester, 'Ver solución paso a paso');
      expect(
        find.text(logarithmsLessons.single.exercises[9].steps.first),
        findsOneWidget,
      );
      final e = logarithmsLessons.single.exercises[9];
      await tap(tester, e.options[(e.correct + 1) % 3]);
      await tap(tester, 'Comprobar respuesta');
      expect(
        tester.widget<ExerciseTutor>(find.byType(ExerciseTutor)).imageOverride,
        hahariWrong,
      );
      await tap(tester, e.options[e.correct]);
      await tap(tester, 'Comprobar respuesta');
      await tap(tester, 'Siguiente ejercicio');
      expect(
        tester.widget<ExerciseTutor>(find.byType(ExerciseTutor)).tutor.id,
        'hakari',
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets('Other tutors remain visible on the tenth exercise', (
    tester,
  ) async {
    final progress = await AcademyProgress.load();
    for (var i = 0; i < 9; i++) {
      await progress.solve(logarithmsLessons.single, i);
    }
    for (final tutor in ['kurisu', 'yuno', 'kotoko', 'karane']) {
      await progress.setTutor(tutor);
      await tester.pumpWidget(LumarApp(progress: progress));
      tester
          .state<NavigatorState>(find.byType(Navigator).first)
          .push(
            MaterialPageRoute<void>(
              builder: (_) => PracticeScreen(
                lesson: logarithmsLessons.single,
                progress: progress,
              ),
            ),
          );
      await tester.pumpAndSettle();
      expect(
        tester.widget<ExerciseTutor>(find.byType(ExerciseTutor)).tutor.id,
        tutor,
      );
      expect(progress.tutor, tutor);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }
  });
  testWidgets(
    'Completing the last unsolved advanced exercise shows the chosen tutor course farewell',
    (tester) async {
      final progress = await AcademyProgress.load();
      await progress.setTutor('karane');
      for (var i = 0; i < 49; i++) {
        await progress.solve(quadraticsLessons.single, i);
      }
      await tester.pumpWidget(LumarApp(progress: progress));
      tester
          .state<NavigatorState>(find.byType(Navigator).first)
          .push(
            MaterialPageRoute<void>(
              builder: (_) => PracticeScreen(
                lesson: quadraticsLessons.single,
                progress: progress,
              ),
            ),
          );
      await tester.pumpAndSettle();
      final e = quadraticsLessons.single.exercises.last;
      await tap(tester, e.options[e.correct]);
      await tap(tester, 'Comprobar respuesta');
      await tap(tester, 'Terminar práctica');
      expect(find.text('¡Curso completado!'), findsOneWidget);
      final farewell = tester.widget<TutorFarewell>(find.byType(TutorFarewell));
      expect(farewell.courseComplete, isTrue);
      expect(farewell.tutor.id, 'karane');
      expect(
        (await AcademyProgress.load()).mastered(quadraticsLessons.single),
        isTrue,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
