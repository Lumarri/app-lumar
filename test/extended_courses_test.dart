import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumar_academy/src/app.dart';
import 'package:lumar_academy/src/curriculum.dart';
import 'package:lumar_academy/src/advanced_dialogues.dart';
import 'package:lumar_academy/src/reactions.dart';
import 'package:lumar_academy/src/tutors.dart';
import 'package:lumar_academy/src/progress.dart';
import 'package:lumar_academy/src/exercise_tutor.dart';
import 'package:lumar_academy/src/widgets/advanced_study.dart';

double numValue(dynamic s) {
  final p = s.toString().split('/');
  return double.parse(p[0]) / (p.length == 1 ? 1 : double.parse(p[1]));
}

List<double> vector(String s) => s
    .substring(1, s.length - 1)
    .split(',')
    .map((x) => numValue(x.trim()))
    .toList();
List<List<double>> rows(dynamic data) =>
    (data as List).map((r) => (r as List).map(numValue).toList()).toList();
List<List<double>> product(List<List<double>> a, List<List<double>> b) => [
  for (var i = 0; i < a.length; i++)
    [
      for (var j = 0; j < b[0].length; j++)
        [for (var k = 0; k < b.length; k++) a[i][k] * b[k][j]]
            .fold<double>(0, (x, y) => x + y),
    ],
];
double det(List<List<double>> a) {
  if (a.length == 1) return a[0][0];
  var sum = 0.0;
  for (var j = 0; j < a.length; j++) {
    final minor = [
      for (var i = 1; i < a.length; i++)
        [
          for (var k = 0; k < a.length; k++)
            if (k != j) a[i][k],
        ],
    ];
    sum += (j.isEven ? 1 : -1) * a[0][j] * det(minor);
  }
  return sum;
}

int rank(List<List<double>> a) {
  a = [
    for (final row in a) [...row],
  ];
  var pivots = 0;
  for (var col = 0; col < a[0].length && pivots < a.length; col++) {
    var found = -1;
    for (var i = pivots; i < a.length; i++) {
      if (a[i][col].abs() > 1e-9) {
        found = i;
        break;
      }
    }
    if (found < 0) continue;
    final row = a[pivots];
    a[pivots] = a[found];
    a[found] = row;
    for (var i = pivots + 1; i < a.length; i++) {
      final scale = a[i][col] / a[pivots][col];
      for (var j = col; j < a[0].length; j++) {
        a[i][j] -= scale * a[pivots][j];
      }
    }
    pivots++;
  }
  return pivots;
}

void same(List<double> a, List<double> b) {
  expect(a.length, b.length);
  for (var i = 0; i < a.length; i++) {
    expect(a[i], closeTo(b[i], 1e-9));
  }
}

Future<void> tap(WidgetTester t, String text) async {
  final f = find.text(text).last;
  await t.ensureVisible(f);
  await t.pumpAndSettle();
  await t.tap(f);
  await t.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('Complete courses have 30 stages, 600 original tasks and monotone difficulty', () {
    expect(precalculusLessons.length, 16);
    expect(linearAlgebraLessons.length, 14);
    for (final l in [...precalculusLessons, ...linearAlgebraLessons]) {
      expect(l.exercises.length, 20);
      expect(l.guide, isNotNull);
      expect(l.guide!.formulas, isNotEmpty);
      expect(l.guide!.objectives.length, 3);
      expect(l.exercises.map((e) => e.skill).toSet().length, 5);
      for (var i = 0; i < 20; i++) {
        final e = l.exercises[i];
        expect(e.difficulty, i ~/ 4 + 1);
        expect(e.steps.length, greaterThanOrEqualTo(3));
        expect(e.hint, isNotEmpty);
        expect(e.explanation, isNotEmpty);
        expect(e.options.toSet().length, 3);
        expect(e.errors[e.correct], isEmpty);
        for (var j = 0; j < 3; j++) {
          if (j != e.correct) expect(e.errors[j], isNotEmpty);
        }
      }
    }
  });
  test('Independent witnesses verify 120 polynomial, vector, matrix and system answers', () {
    final checks = jsonDecode(
      File('tool/extended_course_audit.json').readAsStringSync(),
    ) as List;
    expect(checks.length, 120);
    for (final d in checks) {
      final l = allLessons.firstWhere((l) => l.id == d['lesson']);
      final e = l.exercises[d['index'] as int];
      final answer = e.options[e.correct];
      switch (d['kind']) {
        case 'poly':
          final coeff = (d['coeff'] as List).map(numValue).toList();
          var y = 0.0;
          for (final c in coeff.reversed) {
            y = y * numValue(d['x']) + c;
          }
          expect(numValue(answer), closeTo(y, 1e-9));
        case 'roots':
          final c = (d['coeff'] as List).map(numValue).toList();
          for (final r in d['roots'] as List) {
            var y = 0.0;
            for (final a in c.reversed) {
              y = y * numValue(r) + a;
            }
            expect(y, closeTo(0, 1e-9));
          }
          expect(
            (d['roots'] as List).map(numValue),
            contains(numValue(answer)),
          );
        case 'dot':
          final u = d['u'] as List;
          final v = d['v'] as List;
          expect(
            numValue(answer),
            [for (var i = 0; i < u.length; i++) numValue(u[i]) * numValue(v[i])]
                .fold<double>(0, (a, b) => a + b),
          );
        case 'vsum':
          final u = d['u'] as List;
          final v = d['v'] as List;
          same(vector(answer), [
            for (var i = 0; i < u.length; i++) numValue(u[i]) + numValue(v[i]),
          ]);
        case 'orthogonal':
          final v = vector(answer);
          final u = d['u'] as List;
          expect(
            [for (var i = 0; i < v.length; i++) v[i] * numValue(u[i])]
                .fold<double>(0, (a, b) => a + b),
            0,
          );
        case 'cross':
          final u = (d['u'] as List).map(numValue).toList();
          final v = (d['v'] as List).map(numValue).toList();
          same(vector(answer), [
            u[1] * v[2] - u[2] * v[1],
            u[2] * v[0] - u[0] * v[2],
            u[0] * v[1] - u[1] * v[0],
          ]);
        case 'matentry':
          final ab = product(rows(d['a']), rows(d['b']));
          expect(numValue(answer), ab[d['row']][d['col']]);
        case 'matdiff':
          final a = rows(d['a']), b = rows(d['b']);
          final ab = product(a, b), ba = product(b, a);
          expect(
            numValue(answer),
            ab[d['row']][d['col']] - ba[d['row']][d['col']],
          );
        case 'system':
          final v = vector(answer), a = rows(d['a']);
          same(
            product(a, [
              for (final x in v) [x],
            ]).map((r) => r[0]).toList(),
            (d['b'] as List).map(numValue).toList(),
          );
        case 'det':
          expect(numValue(answer), det(rows(d['a'])));
        case 'inverse':
          final b = answer
              .substring(1, answer.length - 1)
              .split(';')
              .map((r) => r.split(',').map((x) => numValue(x.trim())).toList())
              .toList();
          final p = product(rows(d['a']), b);
          for (var i = 0; i < p.length; i++) {
            for (var j = 0; j < p.length; j++) {
              expect(p[i][j], i == j ? 1 : 0);
            }
          }
        case 'rank':
          expect(numValue(answer), rank(rows(d['a'])));
        case 'nullity':
          final a = rows(d['a']);
          expect(numValue(answer), a[0].length - rank(a));
        case 'leastsquares':
          final a = rows(d['a']);
          final x = answer.startsWith('(')
              ? vector(answer)
              : [numValue(answer)];
          final predicted = product(a, [
            for (final n in x) [n],
          ]);
          final residual = [
            for (var i = 0; i < a.length; i++)
              numValue(d['b'][i]) - predicted[i][0],
          ];
          for (var j = 0; j < a[0].length; j++) {
            expect(
              [for (var i = 0; i < a.length; i++) a[i][j] * residual[i]]
                  .fold<double>(0, (a, b) => a + b),
              closeTo(0, 1e-9),
            );
          }
        case 'eigen':
          final v = answer.startsWith('(')
              ? vector(answer)
              : (d['v'] as List).map(numValue).toList();
          final lambda = answer.startsWith('(')
              ? numValue(d['value'])
              : numValue(answer);
          same(
            product(rows(d['a']), [
              for (final x in v) [x],
            ]).map((r) => r[0]).toList(),
            v.map((x) => x * lambda).toList(),
          );
        case 'matpower':
          final a = rows(d['a']);
          var p = a;
          for (var i = 1; i < (d['power'] as int); i++) {
            p = product(p, a);
          }
          expect(numValue(answer), p[d['row']][d['col']]);
        default:
          fail('Unverified witness ${d["kind"]}');
      }
    }
  });
  test(
    'Every advanced stage has contextual dialogue for all tutors and actions',
    () {
      for (final l in [...precalculusLessons, ...linearAlgebraLessons]) {
        for (final t in tutors) {
          expect(
            advancedStageGreeting(t, l),
            contains(l.guide!.objectives.first.toLowerCase()),
          );
          for (final r in ExerciseReaction.values) {
            final lines = {
              for (var i = 0; i < 2; i++)
                advancedCourseDialogue(t, l, l.exercises.first, r, i),
            };
            expect(lines.length, 2);
            expect(
              lines.every((s) => s.contains('[') && !s.contains('{')),
              isTrue,
            );
          }
        }
      }
    },
  );
  test(
    'New season choices and their final challenges persist alongside old saves',
    () async {
      final p = await AcademyProgress.load();
      await p.solve(algebraLessons.first, 0);
      await p.solve(precalculusLessons.last, 19);
      await p.solve(linearAlgebraLessons.last, 19);
      await p.setSeason(8);
      final r = await AcademyProgress.load();
      expect(r.total, 1130);
      expect(r.selectedSeason, 8);
      expect(
        r.solved,
        containsAll([
          'operations:0',
          'pre_modeling:19',
          'lin_diagonalization:19',
        ]),
      );
      await r.setSeason(3);
      expect((await AcademyProgress.load()).selectedSeason, 3);
    },
  );
  testWidgets(
    'Advanced graph, table, formulas and tutors fit a 320px enlarged screen',
    (t) async {
      t.view.physicalSize = const Size(320, 740);
      t.view.devicePixelRatio = 1;
      t.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
      final p = await AcademyProgress.load();
      await t.pumpWidget(
        MaterialApp(
          home: PracticeScreen(lesson: precalculusLessons.first, progress: p),
        ),
      );
      await t.pumpAndSettle();
      expect(find.byType(ExerciseLevelBar), findsOneWidget);
      await tap(t, 'Tabla');
      expect(find.text('f(x)'), findsOneWidget);
      await tap(t, 'Consultar fórmulas');
      await tap(t, 'Necesito una pista');
      expect(
        t.widget<ExerciseTutor>(find.byType(ExerciseTutor)).message,
        contains('Sustituye'),
      );
      await tap(t, 'Ver solución paso a paso');
      expect(t.takeException(), isNull);
      expect(p.solved, isEmpty);
      await t.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets(
    'Matrix challenges preserve the current tutor, expose steps and save the answer',
    (t) async {
      final p = await AcademyProgress.load();
      await p.setTutor('karane');
      final l = linearAlgebraLessons.firstWhere((l) => l.id == 'lin_matrices');
      for (var i = 0; i < 12; i++) {
        await p.solve(l, i);
      }
      await t.pumpWidget(
        MaterialApp(
          home: PracticeScreen(lesson: l, progress: p),
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Matriz del problema'), findsOneWidget);
      expect(
        t.widget<ExerciseTutor>(find.byType(ExerciseTutor)).tutor.id,
        'karane',
      );
      final e = l.exercises[12];
      await tap(t, e.options[e.correct]);
      await tap(t, 'Comprobar respuesta');
      expect(p.solved, contains('lin_matrices:12'));
      expect(t.takeException(), isNull);
      await t.pumpWidget(const SizedBox.shrink());
    },
  );
}
