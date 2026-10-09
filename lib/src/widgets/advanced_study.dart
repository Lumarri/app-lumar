import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../course_models.dart';
import '../widgets.dart';

const difficultyNames = [
  'Guiado',
  'Aplicación',
  'Conexión',
  'Razonamiento',
  'Desafío',
];

class ExerciseLevelBar extends StatelessWidget {
  const ExerciseLevelBar({
    super.key,
    required this.exercise,
    required this.index,
  });
  final Exercise exercise;
  final int index;
  @override
  Widget build(BuildContext context) => Panel(
    padding: const EdgeInsets.all(14),
    color: lavender,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reto ${index + 1} · Nivel ${exercise.difficulty}/5 · ${difficultyNames[exercise.difficulty - 1]}',
          style: const TextStyle(color: violet, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: exercise.difficulty / 5,
          color: rose,
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: 8),
        Text(exercise.skill),
      ],
    ),
  );
}

class StudyGuidePanel extends StatelessWidget {
  const StudyGuidePanel({super.key, required this.lesson});
  final Lesson lesson;
  @override
  Widget build(BuildContext context) {
    final guide = lesson.guide!;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tu kit de estudio ♡',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('${lesson.exercises.length} retos · 5 niveles de dificultad'),
          const SizedBox(height: 12),
          for (final objective in guide.objectives)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 16, color: rose),
                  const SizedBox(width: 8),
                  Expanded(child: Text(objective)),
                ],
              ),
            ),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text('Antes de empezar'),
            children: [
              for (final item in guide.prerequisites)
                ListTile(title: Text(item)),
            ],
          ),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text('Fórmulas y condiciones'),
            children: [
              for (final formula in guide.formulas)
                ListTile(title: SelectableText(formula)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Error frecuente: ${guide.pitfall}',
            style: const TextStyle(color: muted),
          ),
        ],
      ),
    );
  }
}

class FormulaReminder extends StatelessWidget {
  const FormulaReminder({super.key, required this.guide, this.onOpen});
  final StudyGuide guide;
  final VoidCallback? onOpen;
  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: const Text('Consultar fórmulas'),
    leading: const Icon(Icons.menu_book_rounded, color: violet),
    onExpansionChanged: (open) {
      if (open) onOpen?.call();
    },
    children: [
      for (final formula in guide.formulas)
        ListTile(title: SelectableText(formula)),
      ListTile(
        title: Text(guide.pitfall, style: const TextStyle(color: muted)),
      ),
    ],
  );
}

class StudyVisualView extends StatefulWidget {
  const StudyVisualView({super.key, required this.visual, this.onExplore});
  final StudyVisual visual;
  final VoidCallback? onExplore;
  @override
  State<StudyVisualView> createState() => _StudyVisualViewState();
}

class _StudyVisualViewState extends State<StudyVisualView> {
  bool table = false;
  int? point;
  @override
  void didUpdateWidget(StudyVisualView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visual != widget.visual) {
      table = false;
      point = null;
    }
  }

  String n(double x) =>
      x == x.roundToDouble() ? x.toInt().toString() : x.toStringAsFixed(2);
  @override
  Widget build(BuildContext context) {
    final visual = widget.visual;
    final isMatrix = visual.kind == 'matrix';
    final isGraph = visual.kind == 'function';
    final samples = isGraph ? visual.series.first : const <List<double>>[];
    return Panel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isMatrix
                ? 'Matriz del problema'
                : isGraph
                ? 'Explorador de la función'
                : 'Vectores del problema',
            style: const TextStyle(fontWeight: FontWeight.w800, color: violet),
          ),
          const SizedBox(height: 8),
          Text(
            visual.caption,
            style: const TextStyle(fontSize: 13, color: muted),
          ),
          const SizedBox(height: 10),
          if (isMatrix)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Semantics(
                label:
                    'Matriz: ${visual.values.map((r) => r.map(n).join(', ')).join('; ')}',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: violet, width: 2),
                      right: BorderSide(color: violet, width: 2),
                    ),
                  ),
                  child: Table(
                    defaultColumnWidth: const FixedColumnWidth(60),
                    children: [
                      for (final row in visual.values)
                        TableRow(
                          children: [
                            for (final x in row)
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(n(x), textAlign: TextAlign.center),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          if (!isMatrix) ...[
            Semantics(
              label: isGraph
                  ? 'Gráfica con eje x horizontal y eje y vertical; la tabla permite leer valores exactos del muestreo.'
                  : 'Vectores: ${visual.values.map((r) => r.map(n).join(', ')).join('; ')}',
              child: SizedBox(
                height: 190,
                child: CustomPaint(painter: _StudyPainter(visual, point)),
              ),
            ),
            if (!isGraph)
              for (var i = 0; i < visual.values.length; i++)
                Text(
                  'v${i + 1} = (${visual.values[i].map(n).join(', ')})',
                  style: const TextStyle(color: muted),
                ),
          ],
          if (isGraph) ...[
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Gráfica'),
                  selected: !table,
                  onSelected: (_) => setState(() => table = false),
                ),
                ChoiceChip(
                  label: const Text('Tabla'),
                  selected: table,
                  onSelected: (_) {
                    widget.onExplore?.call();
                    setState(() => table = true);
                  },
                ),
              ],
            ),
            if (table)
              Table(
                children: [
                  const TableRow(
                    children: [
                      Text('x', textAlign: TextAlign.center),
                      Text('f(x)', textAlign: TextAlign.center),
                    ],
                  ),
                  for (final p in samples.where(
                    (p) => p[0] == p[0].roundToDouble(),
                  ))
                    TableRow(
                      children: [
                        Text(n(p[0]), textAlign: TextAlign.center),
                        Text(n(p[1]), textAlign: TextAlign.center),
                      ],
                    ),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              point == null
                  ? 'Mueve el punto para explorar valores.'
                  : 'x = ${n(samples[point!][0])} · f(x) = ${n(samples[point!][1])}',
              textAlign: TextAlign.center,
            ),
            Slider(
              value: (point ?? samples.length ~/ 2).toDouble(),
              min: 0,
              max: (samples.length - 1).toDouble(),
              divisions: samples.length - 1,
              semanticFormatterCallback: (value) =>
                  'x ${n(samples[value.round()][0])}, f(x) ${n(samples[value.round()][1])}',
              onChanged: (value) {
                widget.onExplore?.call();
                setState(() => point = value.round());
              },
            ),
            const Text(
              'Los segmentos unen muestras; no sustituyen una demostración.',
              style: TextStyle(fontSize: 11, color: muted),
            ),
          ],
        ],
      ),
    );
  }
}

class _StudyPainter extends CustomPainter {
  _StudyPainter(this.visual, this.point);
  final StudyVisual visual;
  final int? point;
  @override
  void paint(Canvas canvas, Size size) {
    final graph = visual.kind == 'function';
    final points = graph
        ? visual.series.expand((s) => s).toList()
        : [
            [0.0, 0.0],
            ...visual.values,
          ];
    var xmin = math.min(-1.0, points.map((p) => p[0]).reduce(math.min));
    var xmax = math.max(1.0, points.map((p) => p[0]).reduce(math.max));
    var ymin = math.min(-1.0, points.map((p) => p[1]).reduce(math.min));
    var ymax = math.max(1.0, points.map((p) => p[1]).reduce(math.max));
    final box = Rect.fromLTRB(28, 14, size.width - 18, size.height - 24);
    if (!graph) {
      // Equal scale on both axes preserves vector angles and perpendicularity.
      final unit =
          math.max((xmax - xmin) / box.width, (ymax - ymin) / box.height) * 1.1;
      final cx = (xmin + xmax) / 2, cy = (ymin + ymax) / 2;
      xmin = cx - unit * box.width / 2;
      xmax = cx + unit * box.width / 2;
      ymin = cy - unit * box.height / 2;
      ymax = cy + unit * box.height / 2;
    }
    Offset pos(List<double> p) => Offset(
      box.left + (p[0] - xmin) / (xmax - xmin) * box.width,
      box.bottom - (p[1] - ymin) / (ymax - ymin) * box.height,
    );
    final paint = Paint()
      ..color = lavender
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final x = box.left + box.width * i / 4;
      final y = box.top + box.height * i / 4;
      canvas.drawLine(Offset(x, box.top), Offset(x, box.bottom), paint);
      canvas.drawLine(Offset(box.left, y), Offset(box.right, y), paint);
    }
    paint
      ..color = muted
      ..strokeWidth = 1.5;
    final origin = pos([0, 0]);
    canvas.drawLine(
      Offset(box.left, origin.dy),
      Offset(box.right, origin.dy),
      paint,
    );
    canvas.drawLine(
      Offset(origin.dx, box.top),
      Offset(origin.dx, box.bottom),
      paint,
    );
    void label(String text, Offset at) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 11,
            color: muted,
            fontFamily: 'Nunito',
            fontFamilyFallback: ['NotoSansMath'],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, at);
    }

    label('x', Offset(box.right, origin.dy + 3));
    label('y', Offset(origin.dx + 4, 0));
    label(
      xmin.toStringAsFixed(graph ? 0 : 1),
      Offset(box.left, box.bottom + 4),
    );
    label(
      xmax.toStringAsFixed(graph ? 0 : 1),
      Offset(box.right - 16, box.bottom + 4),
    );
    label(ymax.toStringAsFixed(graph ? 0 : 1), Offset(0, box.top));
    label(ymin.toStringAsFixed(graph ? 0 : 1), Offset(0, box.bottom - 10));
    paint
      ..color = violet
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    if (graph) {
      for (final series in visual.series) {
        final path = Path();
        for (var i = 0; i < series.length; i++) {
          final p = pos(series[i]);
          if (i == 0) {
            path.moveTo(p.dx, p.dy);
          } else {
            path.lineTo(p.dx, p.dy);
          }
        }
        canvas.drawPath(path, paint);
      }
      if (point != null) {
        canvas.drawCircle(
          pos(visual.series.first[point!]),
          5,
          Paint()..color = rose,
        );
      }
    } else {
      for (var i = 0; i < visual.values.length; i++) {
        paint.color = i.isEven ? violet : rose;
        final end = pos(visual.values[i]);
        canvas.drawLine(origin, end, paint);
        final angle = math.atan2(end.dy - origin.dy, end.dx - origin.dx);
        for (final shift in [-.45, .45]) {
          canvas.drawLine(
            end,
            end -
                Offset(
                  9 * math.cos(angle + shift),
                  9 * math.sin(angle + shift),
                ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_StudyPainter old) =>
      old.visual != visual || old.point != point;
}
