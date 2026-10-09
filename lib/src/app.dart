import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'curriculum.dart';
import 'advanced_dialogues.dart';
import 'widgets/advanced_study.dart';
import 'widgets/math_diagram.dart';
import 'exercise_tutor.dart';
import 'pose_catalog.dart';
import 'tutor_farewell.dart';
import 'lesson_introduction.dart';
import 'music.dart';
import 'progress.dart';
import 'reactions.dart';
import 'settings.dart';
import 'tutors.dart';
import 'widgets.dart';

class LumarApp extends StatelessWidget {
  const LumarApp({super.key, required this.progress});
  final AcademyProgress progress;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Lumar Academy',
    debugShowCheckedModeBanner: false,
    builder: (context, child) => MusicHost(
      progress: progress,
      child: ListenableBuilder(
        listenable: progress,
        builder: (context, _) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations:
                progress.reduceTutorMotion ||
                MediaQuery.disableAnimationsOf(context),
          ),
          child: child!,
        ),
      ),
    ),
    locale: const Locale('es'),
    supportedLocales: const [Locale('es')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Nunito',
      fontFamilyFallback: const ['NotoSansMath'],
      colorScheme: ColorScheme.fromSeed(
        seedColor: violet,
        secondary: rose,
        surface: const Color(0xFFFFF5FB),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF5FB),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: ink,
          letterSpacing: -.8,
        ),
        headlineMedium: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w800,
          color: ink,
          letterSpacing: -.7,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: ink, height: 1.5),
        bodyLarge: TextStyle(fontSize: 16, color: ink, height: 1.6),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFF5FB),
        foregroundColor: ink,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: violet,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: violet.withValues(alpha: .35),
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 50),
          side: const BorderSide(color: Color(0xFFDABFE8), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    home: AcademyShell(progress: progress),
  );
}

class AcademyShell extends StatefulWidget {
  const AcademyShell({super.key, required this.progress});
  final AcademyProgress progress;
  @override
  State<AcademyShell> createState() => _AcademyShellState();
}

class _AcademyShellState extends State<AcademyShell> {
  int tab = 0;
  AcademyProgress get progress => widget.progress;
  TutorProfile get tutor => tutorFor(progress.tutor);
  void openLesson(Lesson lesson) => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => LessonScreen(lesson: lesson, progress: progress),
    ),
  );
  void openPractice(Lesson lesson) => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => PracticeScreen(lesson: lesson, progress: progress),
    ),
  );
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: progress,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_rounded, color: rose, size: 25),
              SizedBox(width: 9),
              Text(
                'lumar',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                  letterSpacing: -1,
                  color: violet,
                ),
              ),
              SizedBox(width: 7),
              Text(
                'ACADEMY',
                style: TextStyle(fontSize: 9, letterSpacing: 1.8, color: muted),
              ),
            ],
          ),
        ),
        actions: [
          const MusicButton(),
          SettingsButton(progress: progress),
          IconButton(
            tooltip: 'Ver mi perfil',
            onPressed: () => setState(() => tab = 3),
            icon: TutorPortrait(name: progress.tutor, size: 34),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (progress.storageError != null)
              MaterialBanner(
                content: Text(progress.storageError!),
                actions: [
                  TextButton(
                    onPressed: progress.save,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: KeyedSubtree(
                  key: ValueKey(tab),
                  child: switch (tab) {
                    0 => home(context),
                    1 => journey(context),
                    2 => practiceHub(context),
                    _ => ProfileScreen(progress: progress),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: KawaiiMenu(
        selected: tab,
        onSelected: (index) => setState(() => tab = index),
      ),
    ),
  );

  Widget seasonSelector() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final season in seasons.where((s) => s.available))
        ChoiceChip(
          showCheckmark: false,
          label: Text(season.title),
          avatar: Icon(switch (season.number) {
            2 => Icons.category_outlined,
            4 => Icons.change_history_rounded,
            _ => Icons.functions_rounded,
          }, size: 18),
          selected: progress.selectedSeason == season.number,
          onSelected: (_) => progress.setSeason(season.number),
        ),
    ],
  );

  Widget home(BuildContext context) => PageBody(
    children: [
      const Tag('TU PEQUEÑA AVENTURA DE HOY'),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: Text(
              'Hola, ${progress.name}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const Icon(Icons.auto_awesome_rounded, color: rose, size: 23),
        ],
      ),
      const SizedBox(height: 5),
      const Text(
        'Aprende, intenta… ¡y deja que tus ideas brillen!',
        style: TextStyle(color: muted),
      ),
      const SizedBox(height: 23),
      seasonSelector(),
      const SizedBox(height: 16),
      TutorHero(
        tutor: tutor,
        seasonLabel:
            'TEMPORADA ${progress.selectedSeason} · ${progress.activeSeason.title.toUpperCase()}',
        action: progress.solved.isEmpty
            ? 'Comenzar mi aventura'
            : progress.seasonFraction(progress.activeSeason) == 1
            ? 'Repasar ${progress.activeSeason.title.toLowerCase()}'
            : 'Continuar aprendiendo',
        onContinue: () => openLesson(progress.nextLesson),
        onChoose: () => setState(() => tab = 3),
      ),
      const SizedBox(height: 23),
      Row(
        children: [
          Expanded(
            child: Stat(
              '${progress.solved.length}',
              'Ejercicios resueltos',
              Icons.favorite_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stat(
              '${allLessons.where(progress.mastered).length} / ${allLessons.length}',
              'Unidades completas',
              Icons.workspace_premium_rounded,
            ),
          ),
        ],
      ),
      SectionTitle(
        'Tu siguiente paso',
        action: TextButton(
          onPressed: () => setState(() => tab = 1),
          child: const Text('Ver ruta'),
        ),
      ),
      lessonTile(
        context,
        progress.nextLesson,
        progress.activeSeason.lessons.indexOf(progress.nextLesson),
      ),
      SectionTitle(
        'El club de tutoras',
        caption: 'Cinco personalidades para acompañarte.',
        action: IconButton(
          tooltip: 'Elegir tutora',
          onPressed: () => setState(() => tab = 3),
          icon: const Icon(Icons.chevron_right_rounded, color: violet),
        ),
      ),
      SizedBox(
        height: 125,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tutors.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (context, i) => SizedBox(
            width: 82,
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => progress.setTutor(tutors[i].id),
                  child: Stack(
                    children: [
                      TutorPortrait(
                        name: tutors[i].id,
                        size: 76,
                        asset: tutors[i].clubPortrait,
                      ),
                      if (tutors[i].id == progress.tutor)
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 11,
                            backgroundColor: violet,
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  tutors[i].name.split(' ').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: violet,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SectionTitle(
        'Un universo por descubrir',
        caption: 'Cada temporada, una nueva aventura.',
      ),
      for (final season in seasons.skip(1))
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: season.available
                ? () {
                    progress.setSeason(season.number);
                    setState(() => tab = 1);
                  }
                : null,
            child: Panel(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    season.available
                        ? Icons.auto_awesome_rounded
                        : Icons.lock_outline_rounded,
                    color: rose,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          season.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Temporada ${season.number} · ${season.available ? '${season.lessons.length} etapas · Entrar' : 'Próximamente'}',
                          style: const TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: violet,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
    ],
  );

  Widget journey(BuildContext context) => PageBody(
    children: [
      seasonSelector(),
      const SizedBox(height: 16),
      Tag('TEMPORADA ${progress.selectedSeason} · TU RUTA'),
      const SizedBox(height: 15),
      Text(
        'El camino de ${progress.activeSeason.title.toLowerCase()}',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 8),
      Text(
        '${progress.activeSeason.lessons.length == 1 ? 'Una nueva aventura' : '${progress.activeSeason.lessons.length} pequeñas aventuras'}. Explora, repasa y avanza a tu ritmo.',
        style: TextStyle(color: muted),
      ),
      const SizedBox(height: 22),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite_rounded, color: rose, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Tu progreso',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  '${(progress.seasonFraction(progress.activeSeason) * 100).round()} %',
                  style: const TextStyle(
                    color: violet,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress.seasonFraction(progress.activeSeason),
                minHeight: 10,
                backgroundColor: lavender,
                color: rose,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${progress.seasonCompleted(progress.activeSeason)} de ${progress.seasonTotal(progress.activeSeason)} ejercicios · ${progress.activeSeason.lessons.length} ${progress.activeSeason.lessons.length == 1 ? 'unidad' : 'unidades'}',
              style: const TextStyle(color: muted, fontSize: 12),
            ),
          ],
        ),
      ),
      const SizedBox(height: 26),
      for (var i = 0; i < progress.activeSeason.lessons.length; i++) ...[
        lessonTile(context, progress.activeSeason.lessons[i], i),
        if (i < progress.activeSeason.lessons.length - 1)
          const Padding(
            padding: EdgeInsets.only(left: 22, top: 7, bottom: 7),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.favorite_rounded,
                size: 16,
                color: Color(0xFFE3BADF),
              ),
            ),
          ),
      ],
      const SizedBox(height: 24),
      TutorMessage(
        tutor: progress.tutor,
        message: tutor.say(TutorMoment.journey),
      ),
    ],
  );

  Widget lessonTile(
    BuildContext context,
    Lesson lesson,
    int index,
  ) => Semantics(
    button: true,
    child: InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: () => openLesson(lesson),
      child: Panel(
        padding: const EdgeInsets.all(16),
        color: index.isEven ? Colors.white : const Color(0xFFFFF3F9),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: progress.mastered(lesson)
                      ? [const Color(0xFFD3EEE2), const Color(0xFFEAF7EF)]
                      : [lavender, const Color(0xFFFFDBEC)],
                ),
                borderRadius: BorderRadius.circular(17),
              ),
              child: progress.mastered(lesson)
                  ? const Icon(Icons.check_rounded, color: Color(0xFF34775D))
                  : Text(
                      lesson.symbol,
                      style: const TextStyle(
                        fontSize: 26,
                        color: violet,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CAPÍTULO ${index + 1}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: rose,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${progress.completed(lesson)}/${lesson.exercises.length} ejercicios · ${lesson.subtitle}',
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: violet),
          ],
        ),
      ),
    ),
  );

  Widget practiceHub(BuildContext context) => PageBody(
    children: [
      seasonSelector(),
      const SizedBox(height: 16),
      const Tag('UN RATITO PARA PRACTICAR'),
      const SizedBox(height: 15),
      Text(
        'Las ideas se entrenan',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 8),
      const Text(
        'Sin cronómetro, sin perder vidas. Los corazones son para darte ánimo.',
        style: TextStyle(color: muted),
      ),
      const SizedBox(height: 23),
      TutorMessage(
        tutor: progress.tutor,
        message: tutor.say(TutorMoment.practice),
        mood: TutorMood.thinking,
      ),
      SectionTitle(
        'Elige tu desafío',
        caption:
            '${progress.activeSeason.lessons.first.exercises.length} ejercicios por unidad · con explicación',
      ),
      for (final lesson in progress.activeSeason.lessons)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: lavender,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        lesson.symbol,
                        style: const TextStyle(fontSize: 22, color: violet),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        lesson.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${progress.completed(lesson)} de 3 resueltos',
                  style: const TextStyle(color: muted),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => openPractice(lesson),
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: Text(
                    progress.mastered(lesson)
                        ? 'Volver a practicar'
                        : 'Practicar',
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.lesson, required this.progress});
  final Lesson lesson;
  final AcademyProgress progress;
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int revealed = 1;
  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu lección'),
        leading: const BackButton(),
        actions: [SettingsButton(progress: widget.progress)],
      ),
      body: SafeArea(
        child: PageBody(
          children: [
            Tag('${seasonForLesson(lesson).title.toUpperCase()} · PASO A PASO'),
            const SizedBox(height: 16),
            Text(
              lesson.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              lesson.subtitle,
              style: const TextStyle(color: muted, fontSize: 16),
            ),
            const SizedBox(height: 23),
            ListenableBuilder(
              listenable: widget.progress,
              builder: (context, _) => LessonIntroduction(
                lesson: lesson,
                tutor: tutorFor(widget.progress.tutor),
              ),
            ),
            const SectionTitle('La idea clave'),
            if (lesson.guide != null) ...[
              StudyGuidePanel(lesson: lesson),
              const SizedBox(height: 16),
            ],
            Panel(
              child: Text(
                lesson.theory,
                style: const TextStyle(fontSize: 16, height: 1.7),
              ),
            ),
            const SectionTitle(
              'Veámoslo en acción',
              caption: 'Un ejemplo resuelto, a tu ritmo.',
            ),
            if (MathDiagram.descriptions.containsKey(lesson.id)) ...[
              MathDiagram(lesson: lesson),
              const SizedBox(height: 16),
            ],
            if (lesson.guide != null &&
                lesson.exercises.first.visual != null) ...[
              StudyVisualView(visual: lesson.exercises.first.visual!),
              const SizedBox(height: 16),
            ],
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [lavender, Color(0xFFFFE6F2)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      lesson.example,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 23,
                        color: violet,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (var i = 0; i < revealed; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: lavender,
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: violet,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              lesson.steps[i],
                              style: const TextStyle(height: 1.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (revealed < lesson.steps.length)
                    OutlinedButton.icon(
                      onPressed: () => setState(() => revealed++),
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: const Text('Mostrar siguiente paso'),
                    )
                  else
                    const Text(
                      '¡Ejemplo completo!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: violet,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) =>
                      PracticeScreen(lesson: lesson, progress: widget.progress),
                ),
              ),
              icon: const Icon(Icons.favorite_rounded),
              label: const Text('Ahora me toca · Practicar'),
            ),
          ],
        ),
      ),
    );
  }
}

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({
    super.key,
    required this.lesson,
    required this.progress,
  });
  final Lesson lesson;
  final AcademyProgress progress;
  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with WidgetsBindingObserver {
  late List<int> queue;
  int position = 0;
  int? selected;
  bool checked = false, hint = false, finished = false;
  bool idle = false;
  int mistakes = 0, hintVisits = 0;
  final _questionClock = Stopwatch();
  bool quickCorrect = false, usedHint = false;
  Timer? _idleTimer;
  final _tutorKey = GlobalKey();
  final _questionKey = GlobalKey();
  bool get correct =>
      checked && selected == widget.lesson.exercises[queue[position]].correct;
  @override
  void initState() {
    super.initState();
    _questionClock.start();
    WidgetsBinding.instance.addObserver(this);
    queue = List.generate(widget.lesson.exercises.length, (i) => i)
        .where(
          (i) => !widget.progress.solved.contains('${widget.lesson.id}:$i'),
        )
        .toList();
    if (queue.isEmpty) {
      queue = List.generate(widget.lesson.exercises.length, (i) => i);
    }
    _armIdle();
  }

  void _armIdle() {
    _idleTimer?.cancel();
    if (!widget.progress.idleReactions ||
        finished ||
        correct ||
        WidgetsBinding.instance.lifecycleState != null &&
            WidgetsBinding.instance.lifecycleState !=
                AppLifecycleState.resumed) {
      return;
    }
    _idleTimer = Timer(const Duration(seconds: 45), () {
      if (mounted && widget.progress.idleReactions && !finished && !correct) {
        setState(() => idle = true);
      }
    });
  }

  void _interact() {
    if (idle) setState(() => idle = false);
    _armIdle();
  }

  void _reveal(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 260),
          alignment: .05,
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!correct && !finished) _questionClock.start();
      _armIdle();
    } else {
      _questionClock.stop();
      _idleTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void check() {
    if (selected == null || checked || finished) return;
    final answerCorrect =
        selected == widget.lesson.exercises[queue[position]].correct;
    setState(() {
      quickCorrect =
          answerCorrect &&
          mistakes == 0 &&
          !usedHint &&
          _questionClock.elapsed < const Duration(seconds: 30);
      checked = true;
      hint = false;
      idle = false;
      if (!answerCorrect) mistakes++;
    });
    widget.progress.recordPracticeAnswer(answerCorrect);
    if (answerCorrect) {
      _questionClock.stop();
      widget.progress.solve(widget.lesson, queue[position]);
    }
    _armIdle();
    _reveal(_tutorKey);
  }

  void advance() {
    setState(() {
      if (position == queue.length - 1) {
        finished = true;
      } else {
        position++;
        selected = null;
        checked = false;
        hint = false;
        idle = false;
        mistakes = 0;
        hintVisits = 0;
        quickCorrect = false;
        usedHint = false;
        _questionClock
          ..reset()
          ..start();
      }
    });
    _armIdle();
    _reveal(_questionKey);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.progress,
    builder: (context, _) {
      final exercise = widget.lesson.exercises[queue[position]];
      final correct = checked && selected == exercise.correct;
      final tutor = tutorFor(widget.progress.tutor);
      final reactions = tutorReactions[tutor.id]!;
      final reaction = correct
          ? widget.progress.streak >= reactions.streakAt
                ? ExerciseReaction.streak
                : ExerciseReaction.correct
          : hint
          ? ExerciseReaction.hint
          : idle && widget.progress.idleReactions
          ? ExerciseReaction.idle
          : checked
          ? mistakes > 3
                ? ExerciseReaction.repeatedError
                : ExerciseReaction.wrong
          : ExerciseReaction.observing;
      final variant =
          allLessons.indexOf(widget.lesson) * 3 +
          queue[position] +
          (reaction == ExerciseReaction.hint ? hintVisits - 1 : mistakes);
      final guest = hahariAppears(
        queue[position],
        correct,
        widget.progress.streak,
        tutorId: tutor.id,
      );
      final pose = guest
          ? null
          : choosePose(
              tutor.id,
              reaction,
              variant,
              exerciseIndex: queue[position],
              mistakes: mistakes,
              streak: widget.progress.streak,
              quick: quickCorrect,
            );
      final dialogue = guest
          ? [
              hahariDialogue(
                reaction,
                variant,
                queue[position],
                widget.progress.streak,
              ),
              advancedGuestDialogue(widget.lesson, exercise, reaction),
            ].join('\n\n')
          : [
              reactionLine(
                tutor,
                reaction,
                streak: widget.progress.streak,
                variant: variant,
              ),
              if (pose != null) pose.lines[variant % pose.lines.length],
              advancedCourseDialogue(
                tutor,
                widget.lesson,
                exercise,
                reaction,
                variant,
              ),
            ].join('\n\n');
      return Scaffold(
        appBar: AppBar(
          title: const Text('Práctica'),
          leading: const BackButton(),
          actions: [
            const MusicButton(),
            SettingsButton(progress: widget.progress),
          ],
        ),
        body: SafeArea(
          child: Listener(
            onPointerDown: (_) => _interact(),
            child: PageBody(
              children: finished
                  ? [
                      const SizedBox(height: 24),
                      TutorFarewell(
                        tutor: tutor,
                        lesson: widget.lesson,
                        courseComplete:
                            widget.progress.seasonFraction(
                              seasonForLesson(widget.lesson),
                            ) ==
                            1,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        '¡Unidad completada!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.lesson.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: muted, fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      TutorMessage(
                        tutor: tutor.id,
                        message: tutor.say(TutorMoment.complete),
                        mood: TutorMood.happy,
                      ),
                      const SizedBox(height: 20),
                      Panel(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.favorite_rounded,
                              color: rose,
                              size: 38,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${queue.length} ${queue.length == 1 ? 'ejercicio practicado' : 'ejercicios practicados'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.progress.storageError ??
                                  (widget.progress.saving
                                      ? 'Guardando progreso…'
                                      : 'Progreso guardado en este dispositivo'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: muted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Volver'),
                      ),
                      if (followingLesson(widget.lesson) != null) ...[
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => LessonScreen(
                                lesson: followingLesson(widget.lesson)!,
                                progress: widget.progress,
                              ),
                            ),
                          ),
                          child: const Text('Explorar la siguiente unidad'),
                        ),
                      ],
                    ]
                  : [
                      const Tag('TU TURNO DE BRILLAR'),
                      const SizedBox(height: 16),
                      Text(
                        widget.lesson.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: const Text('Introducción a esta etapa'),
                        children: [
                          LessonIntroduction(
                            lesson: widget.lesson,
                            tutor: tutor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: position / queue.length,
                                minHeight: 8,
                                backgroundColor: lavender,
                                color: rose,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            '${position + 1} / ${queue.length}',
                            style: const TextStyle(
                              color: muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      if (exercise.difficulty > 0) ...[
                        ExerciseLevelBar(
                          exercise: exercise,
                          index: queue[position],
                        ),
                        const SizedBox(height: 16),
                      ],
                      Panel(
                        key: _questionKey,
                        child: Text(
                          exercise.question,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (exercise.visual != null) ...[
                        StudyVisualView(
                          key: ValueKey('visual:${queue[position]}'),
                          visual: exercise.visual!,
                          onExplore: () => usedHint = true,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (widget.lesson.guide != null)
                        FormulaReminder(
                          guide: widget.lesson.guide!,
                          onOpen: () => usedHint = true,
                        ),
                      ExerciseTutor(
                        key: _tutorKey,
                        tutor: guest ? hahari : tutor,
                        reaction: reaction,
                        variant: variant,
                        imageOverride: guest
                            ? hahariImage(
                                queue[position],
                                correct,
                                widget.progress.streak,
                              )
                            : pose?.asset,
                        expressionOverride: guest
                            ? '[Visita sorpresa] La mamá de Hakari se asoma a la pantalla'
                            : pose?.expression,
                        message: dialogue,
                        explanation: hint
                            ? exercise.hint
                            : checked
                            ? correct
                                  ? exercise.explanation
                                  : exercise.errors[selected!]
                            : null,
                        feedbackTitle: checked && !hint
                            ? correct
                                  ? '¡Exacto!'
                                  : 'Probemos otra vez'
                            : null,
                        streak: widget.progress.streak,
                        showingHint: hint,
                        onHint: correct
                            ? null
                            : () {
                                setState(() {
                                  hint = !hint;
                                  idle = false;
                                  if (hint) {
                                    hintVisits++;
                                    usedHint = true;
                                  }
                                });
                                _armIdle();
                              },
                      ),
                      if (exercise.steps.isNotEmpty)
                        ExpansionTile(
                          key: ValueKey('solution:${queue[position]}'),
                          title: const Text('Ver solución paso a paso'),
                          onExpansionChanged: (expanded) {
                            if (expanded) usedHint = true;
                          },
                          children: [
                            for (var i = 0; i < exercise.steps.length; i++)
                              ListTile(
                                leading: Text('${i + 1}'),
                                title: Text(exercise.steps[i]),
                              ),
                          ],
                        ),
                      const SizedBox(height: 22),
                      for (var i = 0; i < exercise.options.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Semantics(
                            selected: selected == i,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: selected == i
                                    ? lavender
                                    : Colors.white,
                                side: BorderSide(
                                  color: selected == i
                                      ? violet
                                      : const Color(0xFFE2CFEA),
                                  width: selected == i ? 2 : 1.5,
                                ),
                                padding: const EdgeInsets.all(18),
                              ),
                              onPressed: correct
                                  ? null
                                  : () => setState(() {
                                      selected = i;
                                      checked = false;
                                      hint = false;
                                      idle = false;
                                    }),
                              child: Row(
                                children: [
                                  Text(
                                    String.fromCharCode(65 + i),
                                    style: const TextStyle(
                                      color: muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      exercise.options[i],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: ink,
                                      ),
                                    ),
                                  ),
                                  if (selected == i)
                                    Icon(
                                      correct
                                          ? Icons.favorite_rounded
                                          : Icons.radio_button_checked,
                                      color: correct ? rose : violet,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      FilledButton(
                        onPressed: correct
                            ? advance
                            : selected == null
                            ? null
                            : checked
                            ? null
                            : check,
                        child: Text(
                          correct
                              ? position == queue.length - 1
                                    ? 'Terminar práctica'
                                    : 'Siguiente ejercicio'
                              : 'Comprobar respuesta',
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Aprende a tu ritmo. Los errores no quitan progreso.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
            ),
          ),
        ),
      );
    },
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.progress});
  final AcademyProgress progress;
  Future<void> editName(BuildContext context) async {
    final value = await showDialog<String>(
      context: context,
      builder: (_) => _NameDialog(initialName: progress.name),
    );
    if (value != null) await progress.setName(value);
  }

  Future<void> reset(BuildContext context) async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Reiniciar tu progreso?'),
        content: const Text(
          'Se borrarán los ejercicios completados de este dispositivo. Tu nombre y tutora se conservarán.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
    if (accepted == true) await progress.reset();
  }

  @override
  Widget build(BuildContext context) => PageBody(
    children: [
      const Tag('TU RINCÓN EN LA ACADEMIA'),
      const SizedBox(height: 16),
      Text('Mi perfil', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 22),
      Panel(
        child: Row(
          children: [
            const CircleAvatar(
              radius: 27,
              backgroundColor: lavender,
              child: Icon(Icons.favorite_rounded, color: rose),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progress.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text(
                    'Explorador del álgebra',
                    style: TextStyle(color: muted),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Editar nombre',
              onPressed: () => editName(context),
              icon: const Icon(Icons.edit_outlined, color: violet),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: Stat(
              '${(progress.fraction * 100).round()} %',
              'Todas las temporadas',
              Icons.donut_large_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stat(
              '${progress.solved.length * 10}',
              'Puntos de aprendizaje',
              Icons.auto_awesome_rounded,
            ),
          ),
        ],
      ),
      const SectionTitle(
        'Tu compañera de estudio',
        caption: 'Cinco voces distintas. Elige tu favorita.',
      ),
      for (final tutor in tutors)
        Padding(
          padding: const EdgeInsets.only(bottom: 19),
          child: Panel(
            color: progress.tutor == tutor.id
                ? const Color(0xFFF6E9FC)
                : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    TutorPortrait(name: tutor.id, size: 80),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tutor.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tutor.traits,
                            style: const TextStyle(
                              color: violet,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            tutor.origin,
                            style: const TextStyle(color: muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(tutor.introduction, style: const TextStyle(height: 1.6)),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: progress.tutor == tutor.id
                      ? null
                      : () => progress.setTutor(tutor.id),
                  icon: Icon(
                    progress.tutor == tutor.id
                        ? Icons.check_rounded
                        : Icons.favorite_border_rounded,
                  ),
                  label: Text(
                    progress.tutor == tutor.id
                        ? 'Tu tutora actual'
                        : 'Elegir a ${tutor.name}',
                  ),
                ),
                if (tutor.thinkingPortrait != null ||
                    tutor.happyPortrait != null ||
                    tutor.surprisedPortrait != null) ...[
                  const SizedBox(height: 14),
                  const Text(
                    'Sus expresiones',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      for (final mood in TutorMood.values)
                        if (mood == TutorMood.neutral ||
                            mood == TutorMood.thinking &&
                                tutor.thinkingPortrait != null ||
                            mood == TutorMood.happy &&
                                tutor.happyPortrait != null ||
                            mood == TutorMood.surprised &&
                                tutor.surprisedPortrait != null)
                          TutorPortrait(name: tutor.id, size: 44, mood: mood),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      const SectionTitle('Tus logros'),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              progress.solved.isEmpty
                  ? '✧ Primer paso · Resuelve tu primer ejercicio'
                  : '✦ Primer paso · Tu aventura ya comenzó',
            ),
            const SizedBox(height: 12),
            for (final season in seasons.where((s) => s.available))
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  progress.seasonFraction(season) == 1
                      ? '✦ ${season.title} conquistada · Temporada ${season.number} completa'
                      : '✧ ${season.title} · ${progress.seasonCompleted(season)}/${progress.seasonTotal(season)} ejercicios',
                ),
              ),
          ],
        ),
      ),
      const SectionTitle('En este dispositivo'),
      OutlinedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => SettingsScreen(progress: progress),
          ),
        ),
        icon: const Icon(Icons.settings_rounded),
        label: const Text('Abrir ajustes'),
      ),
      const SizedBox(height: 14),
      const MusicSettings(),
      const SizedBox(height: 18),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tu progreso, nombre y tutora se guardan localmente. No necesitas una cuenta. Al desinstalar o borrar los datos de la app, perderás el progreso.',
              style: TextStyle(color: muted, height: 1.6),
            ),
            if (progress.storageError != null) ...[
              const SizedBox(height: 12),
              Text(progress.storageError!),
              TextButton(
                onPressed: progress.save,
                child: const Text('Reintentar guardado'),
              ),
            ],
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => reset(context),
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Reiniciar progreso'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 26),
      const Text(
        'LUMAR ACADEMY\nUn corazón curioso aprende cada día.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: muted,
          letterSpacing: 1,
          fontSize: 11,
          height: 1.8,
        ),
      ),
    ],
  );
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initialName});
  final String initialName;
  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final controller = TextEditingController(text: widget.initialName);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('¿Cómo te llamamos?'),
    content: TextField(
      controller: controller,
      maxLength: 24,
      autofocus: true,
      decoration: const InputDecoration(labelText: 'Tu nombre'),
      textCapitalization: TextCapitalization.words,
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, controller.text),
        child: const Text('Guardar'),
      ),
    ],
  );
}
