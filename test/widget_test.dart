import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumar_academy/src/app.dart';
import 'package:lumar_academy/src/curriculum.dart';
import 'package:lumar_academy/src/progress.dart';
import 'package:lumar_academy/src/tutors.dart';
import 'package:lumar_academy/src/widgets.dart';
import 'package:lumar_academy/src/reactions.dart';
import 'package:lumar_academy/src/exercise_tutor.dart';
import 'package:lumar_academy/src/lesson_introduction.dart';
import 'package:lumar_academy/src/widgets/tutor_hint_avatar.dart';
import 'package:lumar_academy/src/settings.dart';

Future<void> tapText(WidgetTester tester, String label) async {
  final target = find.text(label).last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('All stages have distinct introductions for each tutor', () {
    expect(
      stageIntroductions.keys.toSet(),
      allLessons.map((lesson) => lesson.id).toSet(),
    );
    expect(
      stageIntroductions.values.map((intro) => intro.goal).toSet(),
      hasLength(19),
    );
    for (final lesson in allLessons) {
      final intro = stageIntroductions[lesson.id]!;
      expect(intro.context, isNotEmpty);
      expect(intro.checkpoint, isNotEmpty);
      final greetings = {
        for (final tutor in tutors) stageTutorGreeting(tutor, lesson),
      };
      expect(greetings, hasLength(5));
      expect(
        greetings.every((line) => line.contains(lesson.title.toLowerCase())),
        isTrue,
      );
    }
  });

  testWidgets(
    'Exclusive circular icons load Karane and Hakari sheets for all reactions',
    (tester) async {
      await tester.runAsync(() async {
        for (final sheet in exclusiveTutorIcons.values) {
          expect((await rootBundle.load(sheet)).lengthInBytes, greaterThan(0));
        }
      });
      for (final id in ['karane', 'hakari']) {
        for (final reaction in ExerciseReaction.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Center(
                child: TutorHintAvatar(tutor: tutorFor(id), reaction: reaction),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final image = tester.widget<Image>(find.byType(Image));
          final provider = image.image is ResizeImage
              ? (image.image as ResizeImage).imageProvider
              : image.image;
          expect((provider as AssetImage).assetName, exclusiveTutorIcons[id]);
          expect(tester.takeException(), isNull);
        }
      }
    },
  );

  testWidgets(
    'Settings persist preferences and tutor while preserving exercise progress',
    (tester) async {
      final progress = await AcademyProgress.load();
      await progress.solve(algebraLessons.first, 0);
      await tester.pumpWidget(LumarApp(progress: progress));
      await tester.tap(find.byTooltip('Ajustes'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('Música de estudio'), findsOneWidget);
      await tapText(tester, 'Reducir animación de tutoras');
      await tapText(tester, 'Reacciones durante la espera');
      expect(progress.reduceTutorMotion, isTrue);
      expect(progress.idleReactions, isFalse);
      await tapText(tester, 'Kurisu Makise');
      await tapText(tester, 'Hakari Hanazono');
      final restored = await AcademyProgress.load();
      expect(restored.tutor, 'hakari');
      expect(restored.reduceTutorMotion, isTrue);
      expect(restored.idleReactions, isFalse);
      expect(restored.solved, {'operations:0'});
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Idle reactions stay off when disabled in settings', (
    tester,
  ) async {
    final progress = await AcademyProgress.load();
    await progress.setTutorSettings(idle: false);
    await tester.pumpWidget(
      MaterialApp(
        home: PracticeScreen(lesson: algebraLessons.first, progress: progress),
      ),
    );
    await tester.pump(const Duration(seconds: 60));
    expect(
      tester.widget<ExerciseTutor>(find.byType(ExerciseTutor)).reaction,
      ExerciseReaction.observing,
    );
    await tapText(tester, 'Necesito una pista');
    expect(
      tester.widget<ExerciseTutor>(find.byType(ExerciseTutor)).reaction,
      ExerciseReaction.hint,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test(
    'Existing tutor names migrate while keeping completed exercises',
    () async {
      SharedPreferences.setMockInitialValues({
        'lumar.progress.v1':
            '{"solved":["operations:0"],"tutor":"Hikari","name":"Luna"}',
      });
      final progress = await AcademyProgress.load();
      expect(progress.tutor, 'yuno');
      expect(progress.solved, {'operations:0'});
      expect(migrateTutor('Rei'), 'kurisu');
      expect(migrateTutor('missing'), 'kurisu');
      for (final tutor in tutors) {
        await progress.setTutor(tutor.id);
        expect((await AcademyProgress.load()).tutor, tutor.id);
        for (final moment in TutorMoment.values) {
          expect(tutor.say(moment), isNotEmpty);
        }
      }
    },
  );

  testWidgets(
    'All catalog portraits and bodies are bundled and portraits render',
    (tester) async {
      final assets = {
        for (final tutor in tutors) ...[
          tutor.portrait,
          ?tutor.body,
          ?tutor.thinkingPortrait,
          ?tutor.happyPortrait,
          ?tutor.surprisedPortrait,
        ],
      };
      await tester.runAsync(() async {
        for (final asset in assets) {
          expect((await rootBundle.load(asset)).lengthInBytes, greaterThan(0));
        }
      });
      for (final tutor in tutors) {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(child: TutorPortrait(name: tutor.id, size: 120)),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: tutor.name);
      }
    },
  );

  test(
    'Progress survives reload, avoids duplicate rewards and resets',
    () async {
      final progress = await AcademyProgress.load();
      await Future.wait([
        progress.solve(algebraLessons.first, 0),
        progress.solve(algebraLessons.first, 0),
        progress.setTutor('karane'),
        progress.setName('Luna'),
      ]);
      final restored = await AcademyProgress.load();
      expect(restored.solved, {'operations:0'});
      expect(restored.tutor, 'karane');
      expect(restored.name, 'Luna');
      expect(restored.fraction, closeTo(1 / 380, .0001));
      expect(restored.seasonFraction(seasons.first), closeTo(1 / 140, .0001));
      await restored.reset();
      final reset = await AcademyProgress.load();
      expect(reset.solved, isEmpty);
      expect(reset.tutor, 'karane');
      expect(reset.name, 'Luna');
    },
  );

  test('Malformed local data does not prevent learning', () async {
    SharedPreferences.setMockInitialValues({'lumar.progress.v1': '{broken'});
    final progress = await AcademyProgress.load();
    expect(progress.solved, isEmpty);
    expect(progress.storageError, isNotNull);
    await progress.solve(algebraLessons.first, 0);
    expect(progress.storageError, isNull);
    expect((await AcademyProgress.load()).solved, {'operations:0'});
  });

  test(
    'Storage can recover after opening without an available backend',
    () async {
      final progress = AcademyProgress(null);
      await progress.solve(algebraLessons.first, 0);
      expect(progress.storageError, isNull);
      expect((await AcademyProgress.load()).solved, {'operations:0'});
    },
  );

  test('All curriculum exercises have feedback for every incorrect option', () {
    expect(algebraLessons, hasLength(7));
    for (final lesson in allLessons) {
      expect(lesson.exercises, hasLength(20), reason: lesson.id);
      expect(
        lesson.exercises.map((e) => e.question).toSet(),
        hasLength(20),
        reason: lesson.id,
      );
      expect(lesson.steps, isNotEmpty);
      for (final exercise in lesson.exercises) {
        expect(
          exercise.correct,
          inInclusiveRange(0, exercise.options.length - 1),
        );
        expect(exercise.errors.length, exercise.options.length);
        expect(
          exercise.options.toSet(),
          hasLength(exercise.options.length),
          reason: exercise.question,
        );
        for (var i = 0; i < exercise.options.length; i++) {
          if (i != exercise.correct) expect(exercise.errors[i], isNotEmpty);
        }
      }
    }
    expect(seasons.where((s) => s.available).map((s) => s.number), [1, 2, 4]);
    expect(allLessons.map((l) => l.id).toSet(), hasLength(19));
    expect(geometryLessons, hasLength(6));
    expect(trigonometryLessons, hasLength(6));
  });

  test('Progress and selected season persist independently; pending seasons are ignored', () async {
    final progress = await AcademyProgress.load();
    await progress.solve(algebraLessons.first, 0);
    await progress.setSeason(2);
    for (var i = 0; i < geometryLessons.first.exercises.length; i++) {
      await progress.solve(geometryLessons.first, i);
    }
    await progress.solve(trigonometryLessons.last, 1);
    await progress.setSeason(3);
    final restored = await AcademyProgress.load();
    expect(restored.selectedSeason, 2);
    expect(restored.nextLesson, geometryLessons[1]);
    expect(
      restored.solved,
      containsAll(['operations:0', 'geo_angles:0', 'trig_applications:1']),
    );
    expect(restored.total, 380);
    expect(restored.seasonCompleted(seasons[0]), 1);
    expect(restored.seasonCompleted(seasons[1]), 20);
    expect(restored.seasonCompleted(seasons[3]), 1);
    await restored.setSeason(4);
    expect(
      (await AcademyProgress.load()).nextLesson,
      trigonometryLessons.first,
    );
    for (final season in seasons.where((s) => s.available)) {
      expect(followingLesson(season.lessons.last), isNull);
      expect(followingLesson(season.lessons.first), season.lessons[1]);
    }
  });

  test(
    'Old algebra saves migrate without losing rewards or unlocking precalculus',
    () async {
      SharedPreferences.setMockInitialValues({
        'lumar.progress.v1': '{"solved":["operations:0","variables:1","unknown:0"],"tutor":"kurisu","name":"Joxri"}',
      });
      final progress = await AcademyProgress.load();
      expect(progress.solved, {'operations:0', 'variables:1'});
      expect(progress.selectedSeason, 1);
      expect(progress.name, 'Joxri');
      await progress.setSeason(4);
      expect((await AcademyProgress.load()).solved, progress.solved);
    },
  );

  testWidgets(
    'Season selection updates home, journey and practice on a narrow screen',
    (tester) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final progress = await AcademyProgress.load();
      await tester.pumpWidget(LumarApp(progress: progress));
      await tapText(tester, 'Geometría');
      expect(progress.selectedSeason, 2);
      await tapText(tester, 'Lecciones');
      expect(find.text('El camino de geometría'), findsOneWidget);
      expect(find.text('Rectas y ángulos'), findsOneWidget);
      await tapText(tester, 'Trigonometría');
      expect(find.text('El camino de trigonometría'), findsOneWidget);
      await tapText(tester, 'Práctica');
      expect(find.text('El triángulo rectángulo'), findsOneWidget);
      expect(find.text('Operaciones básicas'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  for (final season in seasons.where((s) => s.number == 2 || s.number == 4)) {
    testWidgets(
      '${season.title}: feedback, saved answers and last-unit completion',
      (tester) async {
        final progress = await AcademyProgress.load();
        await progress.setSeason(season.number);
        final lesson = season.lessons.last;
        await tester.pumpWidget(LumarApp(progress: progress));
        tester
            .state<NavigatorState>(find.byType(Navigator).first)
            .push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    PracticeScreen(lesson: lesson, progress: progress),
              ),
            );
        await tester.pumpAndSettle();
        await tapText(tester, 'Necesito una pista');
        expect(find.text(lesson.exercises.first.hint), findsOneWidget);
        final wrong = lesson
            .exercises
            .first
            .options[(lesson.exercises.first.correct + 1) % 3];
        await tapText(tester, wrong);
        await tapText(tester, 'Comprobar respuesta');
        expect(progress.solved, isEmpty);
        expect(find.text('Probemos otra vez'), findsOneWidget);
        for (var i = 0; i < lesson.exercises.length; i++) {
          final exercise = lesson.exercises[i];
          await tapText(tester, exercise.options[exercise.correct]);
          await tapText(tester, 'Comprobar respuesta');
          await tapText(
            tester,
            i == lesson.exercises.length - 1
                ? 'Terminar práctica'
                : 'Siguiente ejercicio',
          );
        }
        expect(find.text('¡Unidad completada!'), findsOneWidget);
        expect(find.text('Explorar la siguiente unidad'), findsNothing);
        expect((await AcademyProgress.load()).mastered(lesson), isTrue);
        expect(progress.seasonCompleted(season), 20);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  testWidgets('Lesson, hints, error feedback, completion and resume', (
    tester,
  ) async {
    final progress = await AcademyProgress.load();
    await tester.pumpWidget(LumarApp(progress: progress));
    await tapText(tester, 'Comenzar mi aventura');
    expect(find.text('Operaciones básicas'), findsOneWidget);
    await tapText(tester, 'Mostrar siguiente paso');
    expect(find.text('Multiplicación: 3 × 2 = 6.'), findsOneWidget);
    await tapText(tester, 'Mostrar siguiente paso');
    expect(find.text('Suma: 8 + 6 = 14.'), findsOneWidget);
    await tapText(tester, 'Ahora me toca · Practicar');
    await tapText(tester, 'Necesito una pista');
    expect(
      find.text(algebraLessons.first.exercises.first.hint),
      findsOneWidget,
    );
    await tapText(tester, '40');
    await tapText(tester, 'Comprobar respuesta');
    expect(find.text('Probemos otra vez'), findsOneWidget);
    expect(progress.solved, isEmpty);
    await tapText(tester, '16');
    await tapText(tester, 'Comprobar respuesta');
    expect(find.text('¡Exacto!'), findsOneWidget);
    expect(progress.solved, {'operations:0'});
    await tapText(tester, 'Siguiente ejercicio');
    await tapText(tester, '4');
    await tapText(tester, 'Comprobar respuesta');
    await tapText(tester, 'Siguiente ejercicio');
    await tapText(tester, '4');
    await tapText(tester, 'Comprobar respuesta');
    for (var i = 3; i < algebraLessons.first.exercises.length; i++) {
      await tapText(tester, 'Siguiente ejercicio');
      final exercise = algebraLessons.first.exercises[i];
      await tapText(tester, exercise.options[exercise.correct]);
      await tapText(tester, 'Comprobar respuesta');
    }
    await tapText(tester, 'Terminar práctica');
    expect(find.text('¡Unidad completada!'), findsOneWidget);
    expect(progress.mastered(algebraLessons.first), isTrue);
    expect((await AcademyProgress.load()).nextLesson.id, 'variables');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Hint dialogue changes between exercises without losing the anime references',
    (tester) async {
      final progress = await AcademyProgress.load();
      await tester.pumpWidget(
        MaterialApp(
          home: PracticeScreen(
            lesson: algebraLessons.first,
            progress: progress,
          ),
        ),
      );
      await tapText(tester, 'Necesito una pista');
      final first = tester
          .widget<ExerciseTutor>(find.byType(ExerciseTutor))
          .message;
      expect(first, contains('D-mail'));
      await tapText(tester, '16');
      await tapText(tester, 'Comprobar respuesta');
      await tapText(tester, 'Siguiente ejercicio');
      await tapText(tester, 'Necesito una pista');
      final second = tester
          .widget<ExerciseTutor>(find.byType(ExerciseTutor))
          .message;
      expect(second, isNot(first));
      expect(
        tester.widget<ExerciseTutor>(find.byType(ExerciseTutor)).explanation,
        algebraLessons.first.exercises[1].hint,
      );
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('Incomplete practice resumes at first unsolved exercise', (
    tester,
  ) async {
    final progress = await AcademyProgress.load();
    await progress.solve(algebraLessons.first, 0);
    await tester.pumpWidget(
      MaterialApp(
        home: PracticeScreen(lesson: algebraLessons.first, progress: progress),
      ),
    );
    expect(find.text('(12 − 4) ÷ 2 = ?'), findsOneWidget);
    expect(find.text('1 / 19'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test(
    'Streaks and music settings survive reload without changing rewards',
    () async {
      final progress = await AcademyProgress.load();
      for (var i = 0; i < 5; i++) {
        await progress.recordPracticeAnswer(true);
      }
      await progress.setMusic(enabled: true, volume: .4);
      final restored = await AcademyProgress.load();
      expect(restored.streak, 5);
      expect(restored.bestStreak, 5);
      expect(restored.solved, isEmpty);
      expect(restored.musicEnabled, isTrue);
      expect(restored.musicVolume, .4);
      await restored.recordPracticeAnswer(false);
      expect(restored.streak, 0);
      expect(restored.bestStreak, 5);
      await restored.reset();
      expect(restored.bestStreak, 0);
      expect(restored.musicEnabled, isTrue);
    },
  );

  testWidgets('Each tutor reaction has a bundled image', (tester) async {
    await tester.runAsync(() async {
      for (final tutor in tutors) {
        final reactions = tutorReactions[tutor.id]!;
        for (final reaction in ExerciseReaction.values) {
          expect(reactionLine(tutor, reaction), isNotEmpty);
          for (final asset in reactions.images[reaction]!) {
            expect(
              (await rootBundle.load(asset)).lengthInBytes,
              greaterThan(0),
              reason: asset,
            );
          }
        }
      }
      expect(
        (await rootBundle.load('assets/audio/slow_piano_intermission.mp3'))
            .lengthInBytes,
        greaterThan(0),
      );
    });
  });

  test('Every tutor has eight distinct lines per situation and accurate streak counts', () {
    for (final tutor in tutors) {
      for (final reaction in ExerciseReaction.values) {
        final lines = {
          for (var variant = 0; variant < 8; variant++)
            reactionLine(tutor, reaction, variant: variant, streak: 8),
        };
        expect(lines, hasLength(8), reason: '${tutor.id} $reaction');
        if (reaction == ExerciseReaction.streak) {
          expect(
            lines.every(
              (line) => line.contains('8') && !line.contains('{racha}'),
            ),
            isTrue,
          );
        }
      }
    }
  });

  testWidgets(
    'Tutor reacts to idle, hint, repeated errors and correct streak without duplicate checks',
    (tester) async {
      final progress = await AcademyProgress.load();
      await progress.setTutor('yuno');
      await tester.pumpWidget(
        MaterialApp(
          home: PracticeScreen(
            lesson: algebraLessons.first,
            progress: progress,
          ),
        ),
      );
      ExerciseTutor tutorWidget() =>
          tester.widget<ExerciseTutor>(find.byType(ExerciseTutor));
      expect(tutorWidget().reaction, ExerciseReaction.observing);
      await tester.pump(const Duration(seconds: 46));
      expect(tutorWidget().reaction, ExerciseReaction.idle);
      await tapText(tester, 'Necesito una pista');
      expect(tutorWidget().reaction, ExerciseReaction.hint);
      expect(
        tutorWidget().explanation,
        algebraLessons.first.exercises.first.hint,
      );
      for (var i = 0; i < 4; i++) {
        await tapText(tester, '40');
        await tapText(tester, 'Comprobar respuesta');
        expect(
          tutorWidget().reaction,
          i == 3 ? ExerciseReaction.repeatedError : ExerciseReaction.wrong,
        );
        final check = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Comprobar respuesta'),
        );
        expect(check.onPressed, isNull);
      }
      for (var i = 0; i < 3; i++) {
        await progress.recordPracticeAnswer(true);
      }
      await tapText(tester, '16');
      await tapText(tester, 'Comprobar respuesta');
      expect(progress.streak, 4);
      expect(tutorWidget().reaction, ExerciseReaction.streak);
      await tester.pump(const Duration(seconds: 46));
      expect(tutorWidget().reaction, ExerciseReaction.streak);
      await tapText(tester, 'Siguiente ejercicio');
      expect(progress.streak, 4);
      expect(tutorWidget().reaction, ExerciseReaction.observing);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('Exercise tutors fit small screens with enlarged text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.4;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final progress = await AcademyProgress.load();
    for (final tutor in tutors) {
      await progress.setTutor(tutor.id);
      await tester.pumpWidget(
        MaterialApp(
          home: PracticeScreen(
            key: ValueKey(tutor.id),
            lesson: algebraLessons.first,
            progress: progress,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tapText(tester, 'Necesito una pista');
      expect(tester.takeException(), isNull, reason: tutor.name);
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('All main screens fit a small mobile screen and larger text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final progress = await AcademyProgress.load();
    await tester.pumpWidget(LumarApp(progress: progress));
    expect(tester.takeException(), isNull);
    for (final tab in ['Lecciones', 'Práctica', 'Perfil', 'Inicio']) {
      await tapText(tester, tab);
      expect(tester.takeException(), isNull, reason: tab);
    }
    tester.platformDispatcher.textScaleFactorTestValue = 1.4;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(LumarApp(progress: progress));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    for (final tab in ['Lecciones', 'Práctica', 'Perfil', 'Inicio']) {
      await tapText(tester, tab);
      expect(tester.takeException(), isNull, reason: '$tab with larger text');
    }
  });

  testWidgets('Tutor selection and reset cancellation preserve progress', (
    tester,
  ) async {
    final progress = await AcademyProgress.load();
    await progress.solve(algebraLessons.first, 0);
    await tester.pumpWidget(LumarApp(progress: progress));
    await tapText(tester, 'Perfil');
    await tester.tap(find.byTooltip('Editar nombre'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Luna');
    await tapText(tester, 'Guardar');
    expect(progress.name, 'Luna');
    expect((await AcademyProgress.load()).name, 'Luna');
    await tapText(tester, 'Elegir a Karane Inda');
    expect(progress.tutor, 'karane');
    expect((await AcademyProgress.load()).tutor, 'karane');
    await tapText(tester, 'Reiniciar progreso');
    await tapText(tester, 'Cancelar');
    expect(progress.solved, isNotEmpty);
    await tapText(tester, 'Reiniciar progreso');
    await tapText(tester, 'Reiniciar');
    expect(progress.solved, isEmpty);
  });
}
