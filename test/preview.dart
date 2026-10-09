import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumar_academy/src/app.dart';
import 'package:lumar_academy/src/progress.dart';
import 'package:lumar_academy/src/curriculum.dart';
import 'package:lumar_academy/src/tutors.dart';
import 'package:lumar_academy/src/widgets/math_diagram.dart';

Future<void> capture(WidgetTester tester, GlobalKey key, String name) async {
  final images = tester
      .widgetList<Image>(find.byType(Image))
      .map((widget) => widget.image)
      .toSet();
  await tester.runAsync(() async {
    for (final provider in images) {
      await precacheImage(provider, key.currentContext!);
    }
  });
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final directory = await Directory('build/previews').create(recursive: true);
    await File('${directory.path}/$name.png')
        .writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

Future<void> tap(WidgetTester tester, String text) async {
  final target = find.text(text).last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

// Run explicitly with: flutter test test/preview.dart
// These are screenshots of the Flutter UI, not generated character artwork.
void main() {
  testWidgets('Export mobile screen previews', (tester) async {
    await tester.runAsync(() async {
      final font = FontLoader('Nunito')
        ..addFont(rootBundle.load('assets/fonts/Nunito.ttf'));
      await font.load();
      final mathFont = FontLoader('NotoSansMath')
        ..addFont(rootBundle.load('assets/fonts/NotoSansMath.ttf'));
      await mathFont.load();
      final icons = FontLoader('MaterialIcons')
        ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
      await icons.load();
    });
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    final progress = await AcademyProgress.load();
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: LumarApp(progress: progress),
      ),
    );
    await tester.pumpAndSettle();
    for (final entry in {
      'home': 'Inicio',
      'lessons': 'Lecciones',
      'practice': 'Práctica',
      'profile': 'Perfil',
    }.entries) {
      await tester.tap(find.text(entry.value).last);
      await tester.pumpAndSettle();
      await capture(tester, key, entry.key);
    }
    await tester.tap(find.byTooltip('Ajustes'));
    await tester.pumpAndSettle();
    await capture(tester, key, 'settings');
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await tester.pumpAndSettle();
    final stageNavigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    stageNavigator.push(
      MaterialPageRoute<void>(
        builder: (_) =>
            LessonScreen(lesson: algebraLessons.first, progress: progress),
      ),
    );
    await tester.pumpAndSettle();
    await capture(tester, key, 'stage_introduction');
    stageNavigator.pop();
    await tester.pumpAndSettle();
    for (final tutor in tutors) {
      await progress.reset();
      await progress.setTutor(tutor.id);
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) =>
              PracticeScreen(lesson: algebraLessons.first, progress: progress),
        ),
      );
      await tester.pumpAndSettle();
      await capture(tester, key, 'exercise_${tutor.id}');
      if (tutor.id == 'kurisu') {
        await tester.pump(const Duration(seconds: 46));
        await capture(tester, key, 'exercise_idle');
        await tap(tester, 'Necesito una pista');
        await capture(tester, key, 'exercise_hint');
        await tap(tester, '40');
        await tap(tester, 'Comprobar respuesta');
        await capture(tester, key, 'exercise_wrong');
        for (var i = 0; i < 4; i++) {
          await progress.recordPracticeAnswer(true);
        }
        await tap(tester, '16');
        await tap(tester, 'Comprobar respuesta');
        await capture(tester, key, 'exercise_streak');
      }
      navigator.pop();
      await tester.pumpAndSettle();
    }
    for (final entry in {
      'geometry': geometryLessons[2],
      'trigonometry': trigonometryLessons[1],
    }.entries) {
      final lesson = entry.value;
      await progress.setSeason(seasonForLesson(lesson).number);
      await tester.tap(find.text('Lecciones').last);
      await tester.pumpAndSettle();
      await capture(tester, key, '${entry.key}_journey');
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => LessonScreen(lesson: lesson, progress: progress),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(MathDiagram));
      await capture(tester, key, '${entry.key}_example');
      navigator.pop();
      await tester.pumpAndSettle();
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => PracticeScreen(lesson: lesson, progress: progress),
        ),
      );
      await tester.pumpAndSettle();
      await capture(tester, key, '${entry.key}_exercise');
      navigator.pop();
      await tester.pumpAndSettle();
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
