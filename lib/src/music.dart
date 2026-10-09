import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'progress.dart';
import 'widgets.dart';

abstract interface class MusicOutput {
  Future<void> play(double volume);
  Future<void> pause();
  Future<void> close();
}

class AssetMusicOutput implements MusicOutput {
  AudioPlayer? _player;
  bool _started = false;
  @override
  Future<void> play(double volume) async {
    final player = _player ??= AudioPlayer();
    await player.setVolume(volume);
    if (_started) {
      await player.resume();
    } else {
      await player.setReleaseMode(ReleaseMode.loop);
      await player.play(AssetSource('audio/slow_piano_intermission.mp3'));
      _started = true;
    }
  }

  @override
  Future<void> pause() async => _player?.pause();
  @override
  Future<void> close() async => _player?.dispose();
}

class MusicController extends ChangeNotifier {
  MusicController({required this.output, required this.progress});
  final MusicOutput output;
  final AcademyProgress progress;
  bool foreground = true, _closed = false;
  String? error;
  Future<void> _pending = Future.value();
  bool get enabled => progress.musicEnabled;
  double get volume => progress.musicVolume;

  Future<void> setEnabled(bool value) async {
    await progress.setMusic(enabled: value);
    await synchronize();
  }

  Future<void> setVolume(double value) async {
    await progress.setMusic(volume: value);
    await synchronize();
  }

  Future<void> setForeground(bool value) {
    foreground = value;
    return synchronize();
  }

  Future<void> synchronize() {
    _pending = _pending.then((_) async {
      if (_closed) return;
      try {
        if (enabled && foreground) {
          await output.play(volume);
        } else {
          await output.pause();
        }
        error = null;
      } catch (_) {
        error = 'No se pudo reproducir la música. Puedes apagarla y volver a activarla.';
      }
      if (!_closed) notifyListeners();
    });
    return _pending;
  }

  @override
  void dispose() {
    _closed = true;
    unawaited(_pending.then((_) => output.close()).catchError((Object _) {}));
    super.dispose();
  }
}

class MusicHost extends StatefulWidget {
  const MusicHost({super.key, required this.progress, required this.child});
  final AcademyProgress progress;
  final Widget child;
  @override
  State<MusicHost> createState() => _MusicHostState();
}

class _MusicHostState extends State<MusicHost> with WidgetsBindingObserver {
  late final music = MusicController(
    output: AssetMusicOutput(),
    progress: widget.progress,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    music.foreground =
        lifecycle == null || lifecycle == AppLifecycleState.resumed;
    unawaited(music.synchronize());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    unawaited(music.setForeground(state == AppLifecycleState.resumed));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    music.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      MusicScope(notifier: music, child: widget.child);
}

class MusicScope extends InheritedNotifier<MusicController> {
  const MusicScope({super.key, required super.notifier, required super.child});
  static MusicController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MusicScope>()?.notifier;
}

class MusicButton extends StatelessWidget {
  const MusicButton({super.key});
  @override
  Widget build(BuildContext context) {
    final music = MusicScope.of(context);
    if (music == null) return const SizedBox.shrink();
    return IconButton(
      tooltip: music.enabled ? 'Apagar música' : 'Activar música',
      onPressed: () async {
        await music.setEnabled(!music.enabled);
        if (context.mounted && music.error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(music.error!)));
        }
      },
      icon: Icon(
        music.enabled ? Icons.music_note_rounded : Icons.music_off_rounded,
        color: rose,
      ),
    );
  }
}

class MusicSettings extends StatelessWidget {
  const MusicSettings({super.key});
  @override
  Widget build(BuildContext context) {
    final music = MusicScope.of(context);
    if (music == null) return const SizedBox.shrink();
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Música de estudio'),
            subtitle: const Text('Piano suave · sin conexión'),
            value: music.enabled,
            onChanged: music.setEnabled,
          ),
          Text('Volumen: ${(music.volume * 100).round()} %'),
          Slider(
            value: music.volume,
            min: 0,
            max: 1,
            divisions: 20,
            label: '${(music.volume * 100).round()} %',
            onChanged: music.setVolume,
          ),
          const Text(
            'Slow Piano Intermission\nJulie Damsgaard / Spring Spring · CC0',
            style: TextStyle(color: muted, fontSize: 12),
          ),
          if (music.error != null)
            Text(music.error!, style: const TextStyle(color: ink)),
        ],
      ),
    );
  }
}
