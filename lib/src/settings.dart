import 'package:flutter/material.dart';

import 'music.dart';
import 'progress.dart';
import 'tutors.dart';
import 'widgets.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.progress});
  final AcademyProgress progress;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Ajustes',
    icon: const Icon(Icons.settings_rounded, color: violet),
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SettingsScreen(progress: progress),
      ),
    ),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.progress});
  final AcademyProgress progress;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: progress,
    builder: (context, _) => Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: SafeArea(
        child: PageBody(
          children: [
            const Tag('TU ACADEMIA, A TU RITMO'),
            const SectionTitle('Sonido'),
            const MusicSettings(),
            const SectionTitle('Tutora y presentación'),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: progress.tutor,
                    decoration: const InputDecoration(labelText: 'Tu tutora'),
                    items: [
                      for (final tutor in tutors)
                        DropdownMenuItem(
                          value: tutor.id,
                          child: Text(tutor.name),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) progress.setTutor(value);
                    },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Reducir animación de tutoras'),
                    subtitle: const Text(
                      'Las poses aparecen sin movimiento de entrada.',
                    ),
                    value: progress.reduceTutorMotion,
                    onChanged: (value) =>
                        progress.setTutorSettings(reduceMotion: value),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Reacciones durante la espera'),
                    subtitle: const Text(
                      'La tutora comenta si pasan 45 segundos sin interacción.',
                    ),
                    value: progress.idleReactions,
                    onChanged: (value) =>
                        progress.setTutorSettings(idle: value),
                  ),
                ],
              ),
            ),
            const SectionTitle('En este dispositivo'),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    progress.storageError ??
                        (progress.saving
                            ? 'Guardando ajustes…'
                            : 'Ajustes guardados en este dispositivo.'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cambiar estos ajustes conserva tus ejercicios y tu progreso.',
                    style: TextStyle(color: muted),
                  ),
                  if (progress.storageError != null)
                    TextButton(
                      onPressed: progress.save,
                      child: const Text('Reintentar guardado'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Lumar Academy · Álgebra, geometría y trigonometría\nMatemáticas, curiosidad y un poco de magia.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted),
            ),
          ],
        ),
      ),
    ),
  );
}
