import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'tutors.dart';

const violet = Color(0xFF8053CF);
const rose = Color(0xFFD56A9F);
const ink = Color(0xFF3C294F);
const muted = Color(0xFF786A87);
const lavender = Color(0xFFF1E7FC);

// Source dimensions and face crops; display-only framing keeps original files.
const _faceCrops = <String, (Size, Rect)>{
  'assets/tutors/hakari/club_portrait.jpg': (
    Size(447, 447),
    Rect.fromLTWH(75, 20, 280, 280),
  ),
  'assets/tutors/kotoko/club_portrait.jpg': (
    Size(554, 554),
    Rect.fromLTWH(90, 55, 410, 410),
  ),
  'assets/tutors/Gemini_Generated_Image_o69cjso69cjso69c.jpg': (
    Size(1856, 2276),
    Rect.fromLTWH(480, 170, 900, 1050),
  ),
  'assets/tutors/Gemini_Generated_Image_3bicx63bicx63bic.jpg': (
    Size(1792, 2400),
    Rect.fromLTWH(430, 220, 1030, 1200),
  ),
  'assets/tutors/Gemini_Generated_Image_zbr9mvzbr9mvzbr9.jpg': (
    Size(1950, 2208),
    Rect.fromLTWH(400, 470, 1120, 1120),
  ),
  'assets/tutors/Yuno_Gasai.webp': (
    Size(575, 864),
    Rect.fromLTWH(115, 25, 330, 350),
  ),
  'assets/tutors/ddd.jpg': (
    Size(1792, 2400),
    Rect.fromLTWH(350, 420, 1080, 1260),
  ),
  'assets/tutors/Gemini_Generated_Image_lcj8kslcj8kslcj8.jpg': (
    Size(2048, 2048),
    Rect.fromLTWH(400, 420, 1200, 1200),
  ),
  'assets/tutors/Gemini_Generated_Image_ua3i38ua3i38ua3i.jpg': (
    Size(2048, 2048),
    Rect.fromLTWH(470, 400, 1100, 1150),
  ),
  'assets/tutors/Gemini_Generated_Image_ae0u4fae0u4fae0u.jpg': (
    Size(1792, 2390),
    Rect.fromLTWH(440, 590, 1000, 1120),
  ),
};

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(20),
  });
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [color, Color.lerp(color, const Color(0xFFF4E8FA), .28)!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: const Color(0xFFEAD7F3), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: violet.withValues(alpha: .09),
          offset: const Offset(0, 7),
          blurRadius: 18,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(-2, -2),
          blurRadius: 3,
        ),
      ],
    ),
    child: child,
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.caption, this.action});
  final String title;
  final String? caption;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 16),
    child: Row(
      children: [
        const Icon(Icons.favorite_rounded, color: rose, size: 17),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (caption != null) ...[
                const SizedBox(height: 5),
                Text(caption!, style: const TextStyle(color: muted)),
              ],
            ],
          ),
        ),
        ?action,
      ],
    ),
  );
}

class Tag extends StatelessWidget {
  const Tag(this.label, {super.key, this.dark = false});
  final String label;
  final bool dark;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withValues(alpha: .17)
            : const Color(0xFFF3E1F4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: dark
              ? Colors.white.withValues(alpha: .28)
              : const Color(0xFFEBCDE9),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: 12,
            color: dark ? Colors.white : rose,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: dark ? Colors.white : violet,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: .6,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Crops are applied only at display time. All supplied files remain unchanged.
class TutorArtwork extends StatelessWidget {
  const TutorArtwork({
    super.key,
    required this.tutor,
    this.mood = TutorMood.neutral,
    this.full = false,
    this.assetOverride,
  });
  final TutorProfile tutor;
  final TutorMood mood;
  final bool full;
  final String? assetOverride;
  @override
  Widget build(BuildContext context) {
    final asset =
        assetOverride ??
        (full ? tutor.body ?? tutor.portrait : tutor.imageFor(mood));
    if (asset == 'assets/tutors/kurisu/club_portrait.jpg') {
      return _framed(
        asset,
        const Size(447, 447),
        const Rect.fromLTWH(140, 15, 250, 250),
      );
    }
    final faceCrop = _faceCrops[asset];
    if (!full && faceCrop != null) {
      return _framed(asset, faceCrop.$1, faceCrop.$2);
    }
    final sheet =
        asset.endsWith('dfd.jpg') ||
        asset.endsWith('Gemini_Generated_Image_nlf4d8nlf4d8nlf4.jpg') ||
        full && asset.endsWith('Gemini_Generated_Image_ap80xeap80xeap80.jpg');
    if (sheet) {
      // Face panels are part of a larger sheet; isolate one without editing it.
      final isKarane = tutor.id == 'karane';
      final source = isKarane || full
          ? const Size(2752, 1536)
          : const Size(3064, 1376);
      final crop = full
          ? isKarane
                ? const Rect.fromLTWH(1810, 20, 800, 1500)
                : const Rect.fromLTWH(1050, 40, 680, 1480)
          : isKarane
          ? switch (mood) {
              TutorMood.happy => const Rect.fromLTWH(110, 860, 570, 650),
              TutorMood.thinking => const Rect.fromLTWH(1010, 420, 570, 650),
              _ => const Rect.fromLTWH(110, 20, 570, 650),
            }
          : switch (mood) {
              TutorMood.happy => const Rect.fromLTWH(1210, 220, 650, 900),
              TutorMood.thinking => const Rect.fromLTWH(2220, 220, 650, 900),
              _ => const Rect.fromLTWH(170, 220, 650, 900),
            };
      return _framed(asset, source, crop);
    }
    if (full && asset.endsWith('Character_Profile_Kurisu_Makise.png')) {
      return _framed(
        asset,
        const Size(256, 512),
        const Rect.fromLTWH(0, 68, 256, 444),
      );
    }
    return Image.asset(
      asset,
      fit: full ? BoxFit.contain : BoxFit.cover,
      alignment: tutor.face,
      cacheWidth: full ? 1000 : 600,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(Icons.person_outline_rounded, color: violet),
      ),
    );
  }

  Widget _framed(String asset, Size source, Rect crop) => FittedBox(
    fit: full ? BoxFit.contain : BoxFit.cover,
    child: SizedBox(
      width: crop.width,
      height: crop.height,
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: -crop.left,
              top: -crop.top,
              width: source.width,
              height: source.height,
              child: Image.asset(
                asset,
                fit: BoxFit.fill,
                cacheWidth: source.width > 2500 ? 1600 : 1000,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.person_outline_rounded),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class TutorPortrait extends StatelessWidget {
  const TutorPortrait({
    super.key,
    required this.name,
    this.size = 80,
    this.mood = TutorMood.neutral,
    this.asset,
  });
  final String name;
  final String? asset;
  final double size;
  final TutorMood mood;
  @override
  Widget build(BuildContext context) {
    final tutor = tutorFor(name);
    return Semantics(
      label: 'Retrato de ${tutor.name}',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: lavender,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: tutor.accent.withValues(alpha: .23),
              blurRadius: 13,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(3),
        child: ClipOval(
          child: TutorArtwork(tutor: tutor, mood: mood, assetOverride: asset),
        ),
      ),
    );
  }
}

class TutorMessage extends StatelessWidget {
  const TutorMessage({
    super.key,
    required this.tutor,
    required this.message,
    this.mood = TutorMood.neutral,
  });
  final String tutor, message;
  final TutorMood mood;
  @override
  Widget build(BuildContext context) => Panel(
    color: const Color(0xFFFFEFF8),
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TutorPortrait(name: tutor, size: 58, mood: mood),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tutorFor(tutor).name,
                      style: const TextStyle(
                        color: violet,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Icon(Icons.favorite_rounded, color: rose, size: 14),
                ],
              ),
              const SizedBox(height: 6),
              Text(message, style: const TextStyle(height: 1.6)),
            ],
          ),
        ),
      ],
    ),
  );
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const Positioned.fill(
        child: IgnorePointer(child: CustomPaint(painter: _KawaiiPainter())),
      ),
      SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 36),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    ],
  );
}

class _KawaiiPainter extends CustomPainter {
  const _KawaiiPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFF5FB), Color(0xFFF4EDFF), Color(0xFFFFF6EC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Offset.zero & size),
    );
    final dot = Paint()..color = violet.withValues(alpha: .045);
    for (double x = 10; x < size.width; x += 26) {
      for (double y = 10; y < size.height; y += 26) {
        canvas.drawCircle(Offset(x, y), 1.3, dot);
      }
    }
    for (var i = 0; i < 11; i++) {
      final x = (i * 97.0 + 24) % size.width;
      final y = (i * 137.0 + 40) % math.max(size.height, 1);
      final path = Path()
        ..moveTo(x, y + 7)
        ..cubicTo(x - 18, y - 5, x - 8, y - 18, x, y - 8)
        ..cubicTo(x + 8, y - 18, x + 18, y - 5, x, y + 7);
      canvas.drawPath(path, Paint()..color = rose.withValues(alpha: .085));
      final star = Paint()
        ..color = violet.withValues(alpha: .1)
        ..strokeWidth = 1.5;
      canvas.drawLine(Offset(x + 26, y - 12), Offset(x + 26, y), star);
      canvas.drawLine(Offset(x + 20, y - 6), Offset(x + 32, y - 6), star);
    }
  }

  @override
  bool shouldRepaint(_KawaiiPainter oldDelegate) => false;
}

class Stat extends StatelessWidget {
  const Stat(this.value, this.label, this.icon, {super.key});
  final String value, label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Panel(
    padding: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: lavender,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: violet, size: 20),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        Text(label, style: const TextStyle(color: muted, fontSize: 12)),
      ],
    ),
  );
}

class KawaiiMenu extends StatelessWidget {
  const KawaiiMenu({
    super.key,
    required this.selected,
    required this.onSelected,
  });
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFEAD2ED), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: violet.withValues(alpha: .13),
            blurRadius: 22,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < 4; i++)
            Expanded(
              child: Semantics(
                selected: selected == i,
                button: true,
                label: ['Inicio', 'Lecciones', 'Práctica', 'Perfil'][i],
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onSelected(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      gradient: selected == i
                          ? const LinearGradient(
                              colors: [Color(0xFFEEDDFD), Color(0xFFFFDFED)],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          [
                            Icons.cottage_rounded,
                            Icons.auto_stories_rounded,
                            Icons.auto_awesome_rounded,
                            Icons.favorite_rounded,
                          ][i],
                          color: selected == i ? violet : muted,
                          size: 23,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ['Inicio', 'Lecciones', 'Práctica', 'Perfil'][i],
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: selected == i
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: selected == i ? violet : muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class TutorHero extends StatelessWidget {
  const TutorHero({
    super.key,
    required this.tutor,
    required this.action,
    this.seasonLabel = 'TEMPORADA 01 · ÁLGEBRA',
    required this.onContinue,
    required this.onChoose,
  });
  final TutorProfile tutor;
  final String action, seasonLabel;
  final VoidCallback onContinue, onChoose;
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF9371E2), Color(0xFF6742AF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(32),
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: [
        BoxShadow(
          color: violet.withValues(alpha: .28),
          offset: const Offset(0, 12),
          blurRadius: 25,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Tag(seasonLabel, dark: true),
              const SizedBox(height: 16),
              const Text(
                'Un mundo de ideas,\nun poquito de magia.',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 205,
          child: Stack(
            children: [
              Positioned(
                right: 14,
                top: 9,
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.white.withValues(alpha: .18),
                  size: 155,
                ),
              ),
              const Positioned(
                left: 22,
                top: 40,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFFFD9EC),
                  size: 25,
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(35, 10, 35, 0),
                  child: tutor.body != null
                      ? TutorArtwork(tutor: tutor, full: true)
                      : Center(
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: TutorPortrait(name: tutor.id, size: 180),
                          ),
                        ),
                ),
              ),
              Positioned(
                right: 14,
                bottom: 14,
                child: Material(
                  color: Colors.white.withValues(alpha: .93),
                  borderRadius: BorderRadius.circular(30),
                  child: IconButton(
                    tooltip: 'Elegir tutora',
                    onPressed: onChoose,
                    icon: const Icon(Icons.favorite_rounded, color: rose),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tutor.name,
                      style: const TextStyle(
                        color: violet,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Icon(Icons.favorite_rounded, color: rose, size: 17),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                tutor.say(TutorMoment.welcome),
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onContinue,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(action),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
