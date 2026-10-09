import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'curriculum.dart';
import 'tutors.dart';

class AcademyProgress extends ChangeNotifier {
  AcademyProgress(this._preferences) {
    _restore();
  }
  SharedPreferences? _preferences;
  final Set<String> solved = {};
  int selectedSeason = 1;
  String tutor = 'kurisu';
  String name = 'Estudiante';
  int streak = 0, bestStreak = 0;
  bool musicEnabled = false;
  double musicVolume = .25;
  bool reduceTutorMotion = false, idleReactions = true;
  bool saving = false;
  String? storageError;
  Future<void> _pending = Future.value();
  int _writes = 0;

  static Future<AcademyProgress> load() async {
    try {
      return AcademyProgress(await SharedPreferences.getInstance());
    } catch (_) {
      return AcademyProgress(null)
        ..storageError =
            'No se pudo abrir el almacenamiento local. Puedes aprender y reintentar el guardado.';
    }
  }

  void _restore() {
    try {
      final raw = _preferences?.getString('lumar.progress.v1');
      if (raw == null) return;
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final valid = {
        for (final lesson in allLessons)
          for (var i = 0; i < lesson.exercises.length; i++) '${lesson.id}:$i',
      };
      solved.addAll(
        (data['solved'] as List).whereType<String>().where(valid.contains),
      );
      tutor = migrateTutor(
        data['tutor'] is String ? data['tutor'] as String : null,
      );
      final storedName = data['name'];
      final storedStreak = data['streak'];
      final storedBest = data['bestStreak'];
      streak = storedStreak is int && storedStreak >= 0 ? storedStreak : 0;
      bestStreak = storedBest is int && storedBest >= streak
          ? storedBest
          : streak;
      final storedSeason = data['selectedSeason'];
      if (storedSeason is int &&
          seasons.any((s) => s.available && s.number == storedSeason)) {
        selectedSeason = storedSeason;
      }
      musicEnabled = data['musicEnabled'] == true;
      reduceTutorMotion = data['reduceTutorMotion'] == true;
      idleReactions = data['idleReactions'] != false;
      final volume = data['musicVolume'];
      if (volume is num && volume.isFinite) {
        musicVolume = volume.toDouble().clamp(0, 1);
      }
      if (storedName is String && storedName.trim().isNotEmpty) {
        name = storedName;
      }
    } catch (_) {
      storageError =
          'No pudimos leer el progreso anterior. Puedes volver a practicar.';
    }
  }

  int completed(Lesson lesson) => List.generate(
    lesson.exercises.length,
    (i) => '${lesson.id}:$i',
  ).where(solved.contains).length;
  bool mastered(Lesson lesson) => completed(lesson) == lesson.exercises.length;
  int get total =>
      allLessons.fold(0, (sum, lesson) => sum + lesson.exercises.length);
  double get fraction => solved.length / total;
  Lesson get nextLesson => activeSeason.lessons.firstWhere(
    (l) => !mastered(l),
    orElse: () => activeSeason.lessons.first,
  );
  Season get activeSeason =>
      seasons.firstWhere((s) => s.number == selectedSeason);
  int seasonTotal(Season season) =>
      season.lessons.fold(0, (sum, l) => sum + l.exercises.length);
  int seasonCompleted(Season season) =>
      season.lessons.fold(0, (sum, l) => sum + completed(l));
  double seasonFraction(Season season) =>
      season.available ? seasonCompleted(season) / seasonTotal(season) : 0;
  Future<void> setSeason(int number) {
    if (!seasons.any((s) => s.number == number && s.available)) {
      return Future.value();
    }
    selectedSeason = number;
    return save();
  }

  Future<void> solve(Lesson lesson, int index) {
    solved.add('${lesson.id}:$index');
    return save();
  }

  Future<void> setTutor(String value) {
    tutor = migrateTutor(value);
    return save();
  }

  Future<void> setName(String value) {
    name = value.trim().isEmpty ? 'Estudiante' : value.trim();
    return save();
  }

  Future<void> reset() {
    solved.clear();
    streak = 0;
    bestStreak = 0;
    return save();
  }

  Future<void> recordPracticeAnswer(bool correct) {
    streak = correct ? streak + 1 : 0;
    if (streak > bestStreak) bestStreak = streak;
    return save();
  }

  Future<void> setMusic({bool? enabled, double? volume}) {
    musicEnabled = enabled ?? musicEnabled;
    if (volume != null && volume.isFinite) musicVolume = volume.clamp(0, 1);
    return save();
  }

  Future<void> setTutorSettings({bool? reduceMotion, bool? idle}) {
    reduceTutorMotion = reduceMotion ?? reduceTutorMotion;
    idleReactions = idle ?? idleReactions;
    return save();
  }

  Future<void> save() {
    final snapshot = jsonEncode({
      'selectedSeason': selectedSeason,
      'solved': solved.toList(),
      'tutor': tutor,
      'name': name,
      'streak': streak,
      'bestStreak': bestStreak,
      'musicEnabled': musicEnabled,
      'musicVolume': musicVolume,
      'reduceTutorMotion': reduceTutorMotion,
      'idleReactions': idleReactions,
    });
    _writes++;
    saving = true;
    notifyListeners();
    _pending = _pending.then((_) async {
      try {
        _preferences ??= await SharedPreferences.getInstance();
        final written = await _preferences!.setString(
          'lumar.progress.v1',
          snapshot,
        );
        if (!written) throw StateError('Storage rejected write');
        storageError = null;
      } catch (_) {
        storageError = 'No se pudo guardar en este dispositivo. Reintenta desde tu perfil.';
      }
    });
    return _pending.whenComplete(() {
      _writes--;
      saving = _writes > 0;
      notifyListeners();
    });
  }
}
