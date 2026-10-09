import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumar_academy/src/music.dart';
import 'package:lumar_academy/src/progress.dart';

class FakeMusicOutput implements MusicOutput {
  final events = <String>[];
  bool fail = false;
  @override
  Future<void> play(double volume) async {
    if (fail) throw StateError('No audio device');
    events.add('play:$volume');
  }

  @override
  Future<void> pause() async => events.add('pause');
  @override
  Future<void> close() async => events.add('close');
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('Music preference, foreground pause, volume and release', () async {
    final progress = await AcademyProgress.load();
    final output = FakeMusicOutput();
    final music = MusicController(output: output, progress: progress);
    await music.synchronize();
    expect(output.events, ['pause']);
    await music.setEnabled(true);
    expect(output.events.last, 'play:0.25');
    await music.setForeground(false);
    expect(output.events.last, 'pause');
    await music.setVolume(.4);
    expect(output.events.last, 'pause');
    await music.setForeground(true);
    expect(output.events.last, 'play:0.4');
    await music.setEnabled(false);
    expect(output.events.last, 'pause');
    final restored = await AcademyProgress.load();
    expect(restored.musicEnabled, isFalse);
    expect(restored.musicVolume, .4);
    music.dispose();
    await Future<void>.delayed(Duration.zero);
    expect(output.events.last, 'close');
  });
  test('Playback errors are recoverable and do not stop practice', () async {
    final progress = await AcademyProgress.load();
    final output = FakeMusicOutput()..fail = true;
    final music = MusicController(output: output, progress: progress);
    await music.setEnabled(true);
    expect(music.error, isNotNull);
    output.fail = false;
    await music.synchronize();
    expect(music.error, isNull);
    expect(output.events.last, 'play:0.25');
    music.dispose();
  });
}
