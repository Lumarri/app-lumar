import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumar_academy/src/app.dart';
import 'package:lumar_academy/src/advanced_dialogues.dart';
import 'package:lumar_academy/src/curriculum.dart';
import 'package:lumar_academy/src/exercise_tutor.dart';
import 'package:lumar_academy/src/lesson_introduction.dart';
import 'package:lumar_academy/src/pose_catalog.dart';
import 'package:lumar_academy/src/progress.dart';
import 'package:lumar_academy/src/reactions.dart';
import 'package:lumar_academy/src/stage_dialogues.dart';
import 'package:lumar_academy/src/tutors.dart';

Future<void> tap(WidgetTester tester, String text) async {
  final found = find.text(text).last;
  await tester.ensureVisible(found);
  await tester.pumpAndSettle();
  await tester.tap(found);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
    'All 52 stages and eight courses have authored notes for every tutor',
    () {
      expect(stageScripts.keys.toSet(), allLessons.map((l) => l.id).toSet());
      expect(
        courseSignatures.keys.toSet(),
        seasons.map((s) => s.number).toSet(),
      );
      final notes = <String>{};
      for (final l in allLessons) {
        final script = stageScripts[l.id]!;
        expect(script.pitfall, isNotEmpty);
        expect(script.check, isNotEmpty);
        final stageNotes = {for (final t in tutors) script.forTutor(t.id)};
        expect(stageNotes.length, 5, reason: l.id);
        expect(stageNotes.every((s) => s.length > 60), isTrue);
        notes.addAll(stageNotes);
      }
      expect(notes.length, 260);
      for (final s in seasons) {
        expect(
          courseSignatures[s.number]!.keys.toSet(),
          tutors.map((t) => t.id).toSet(),
        );
        expect(courseSignatures[s.number]!.values.toSet().length, 5);
      }
    },
  );
  test(
    'Every action retains its tutor voice and includes real stage teaching',
    () {
      for (final l in allLessons) {
        final script = stageScripts[l.id]!;
        for (final t in tutors) {
          for (final action in ExerciseReaction.values) {
            final lines = {
              for (var variant = 0; variant < 2; variant++)
                advancedCourseDialogue(
                  t,
                  l,
                  l.exercises.first,
                  action,
                  variant,
                ),
            };
            expect(lines.length, 2);
            for (final line in lines) {
              expect(line, contains(script.forTutor(t.id)));
              expect(line, contains('['));
              expect(line, isNot(contains('{')));
              if (action == ExerciseReaction.hint) {
                expect(line, contains(l.exercises.first.hint));
              }
              if (action == ExerciseReaction.correct ||
                  action == ExerciseReaction.streak) {
                expect(line, contains(script.check));
              }
            }
          }
        }
      }
      final inverse = linearAlgebraLessons.firstWhere(
        (l) => l.id == 'lin_inverse',
      );
      expect(stageScripts[inverse.id]!.kurisu, contains('AA^(-1)=I'));
      expect(stageScripts[inverse.id]!.yuno, contains('B^(-1)A^(-1)'));
      final limits = precalculusLessons.firstWhere((l) => l.id == 'pre_limits');
      expect(stageScripts[limits.id]!.karane, contains('0/0 no es cero'));
    },
  );
  test('Introductions and farewells include the current course and stage personality', () {
    for (final l in allLessons) {
      for (final t in tutors) {
        final greeting = stageTutorGreeting(t, l);
        expect(
          greeting,
          contains(courseSignatures[seasonForLesson(l).number]![t.id]!),
        );
        expect(greeting, contains(stageScripts[l.id]!.forTutor(t.id)));
        final stage = personalizedFarewell(t, l, false);
        expect(stage, contains(l.title.toLowerCase()));
        expect(stage, contains(stageScripts[l.id]!.check));
        expect(stage, contains(stageScripts[l.id]!.forTutor(t.id)));
        final course = personalizedFarewell(t, l, true);
        expect(course, contains(seasonForLesson(l).title.toLowerCase()));
        expect(
          course,
          contains(courseSignatures[seasonForLesson(l).number]![t.id]!),
        );
      }
    }
  });
  testWidgets(
    'Old algebra practice uses the stage voice without changing hints or pose',
    (tester) async {
      final progress = await AcademyProgress.load();
      final tutor = tutorFor('kurisu');
      final lesson = algebraLessons.first;
      await tester.pumpWidget(
        MaterialApp(
          home: PracticeScreen(lesson: lesson, progress: progress),
        ),
      );
      await tester.pumpAndSettle();
      var view = tester.widget<ExerciseTutor>(find.byType(ExerciseTutor));
      expect(view.message, contains(stageScripts['operations']!.kurisu));
      expect(
        view.message,
        contains(
          reactionLine(
            tutor,
            ExerciseReaction.observing,
            streak: 0,
            variant: 0,
          ),
        ),
      );
      final expectedPose = choosePose(
        'kurisu',
        ExerciseReaction.observing,
        0,
        exerciseIndex: 0,
        mistakes: 0,
        streak: 0,
        quick: false,
      );
      expect(view.imageOverride, expectedPose?.asset);
      await tap(tester, 'Necesito una pista');
      view = tester.widget<ExerciseTutor>(find.byType(ExerciseTutor));
      expect(view.reaction, ExerciseReaction.hint);
      expect(view.message, contains(lesson.exercises.first.hint));
      expect(view.message, contains(stageScripts['operations']!.kurisu));
      expect(view.explanation, lesson.exercises.first.hint);
      expect(progress.solved, isEmpty);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets(
    'Advanced error, correction and streak keep Karane and her inverse notes',
    (tester) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final progress = await AcademyProgress.load();
      await progress.setTutor('karane');
      final lesson = linearAlgebraLessons.firstWhere(
        (l) => l.id == 'lin_inverse',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: PracticeScreen(lesson: lesson, progress: progress),
        ),
      );
      await tester.pumpAndSettle();
      final exercise = lesson.exercises.first;
      await tap(tester, exercise.options[(exercise.correct + 1) % 3]);
      await tap(tester, 'Comprobar respuesta');
      var view = tester.widget<ExerciseTutor>(find.byType(ExerciseTutor));
      expect(view.reaction, ExerciseReaction.wrong);
      expect(view.tutor.id, 'karane');
      expect(view.message, contains(stageScripts[lesson.id]!.karane));
      expect(view.message, contains(stageScripts[lesson.id]!.pitfall));
      await tap(tester, exercise.options[exercise.correct]);
      await tap(tester, 'Comprobar respuesta');
      view = tester.widget<ExerciseTutor>(find.byType(ExerciseTutor));
      expect(view.reaction, ExerciseReaction.correct);
      expect(view.message, contains(stageScripts[lesson.id]!.check));
      expect(progress.solved, contains('lin_inverse:0'));
      for (var i = 1; i < 3; i++) {
        await tap(tester, 'Siguiente ejercicio');
        final e = lesson.exercises[i];
        await tap(tester, e.options[e.correct]);
        await tap(tester, 'Comprobar respuesta');
      }
      view = tester.widget<ExerciseTutor>(find.byType(ExerciseTutor));
      expect(view.reaction, ExerciseReaction.streak);
      expect(view.message, contains(stageScripts[lesson.id]!.karane));
      expect(view.tutor.id, 'karane');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
