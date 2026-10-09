import 'package:flutter/material.dart';

import '../reactions.dart';
import '../tutors.dart';
import 'tutor_overlay.dart';

const exclusiveTutorIcons = {
  'karane': 'assets/tutors/karane/iconos y cuerpo de akane en las pistas , exclusivo de ella como tutora.png',
  'hakari': 'assets/tutors/hakari/iconos exclusivos de hakari en su pistas ,exclusiva de ella como tutora.png',
};

class TutorHintAvatar extends StatelessWidget {
  const TutorHintAvatar({
    super.key,
    required this.tutor,
    required this.reaction,
    this.size = 48,
  });
  final TutorProfile tutor;
  final ExerciseReaction reaction;
  final double size;
  @override
  Widget build(BuildContext context) {
    final sheet = exclusiveTutorIcons[tutor.id];
    final happy =
        reaction == ExerciseReaction.correct ||
        reaction == ExerciseReaction.streak;
    final thinking =
        reaction == ExerciseReaction.hint ||
        reaction == ExerciseReaction.wrong ||
        reaction == ExerciseReaction.repeatedError;
    final source = tutor.id == 'karane'
        ? const Size(669, 373)
        : const Size(746, 335);
    final crop = tutor.id == 'karane'
        ? happy
              ? const Rect.fromLTWH(25, 203, 155, 158)
              : thinking
              ? const Rect.fromLTWH(233, 85, 162, 177)
              : const Rect.fromLTWH(25, 7, 155, 163)
        : happy
        ? const Rect.fromLTWH(283, 62, 211, 243)
        : thinking
        ? const Rect.fromLTWH(523, 62, 216, 244)
        : const Rect.fromLTWH(37, 62, 212, 243);
    return Semantics(
      label:
          'Icono de ${tutor.name}: ${reactionExpression(tutor.id, reaction)}',
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFEAF5),
          border: Border.all(color: tutor.accent, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: tutor.accent.withValues(alpha: .2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: sheet == null
              ? PoseImage(
                  asset: tutorReactions[tutor.id]!.image(
                    ExerciseReaction.hint,
                    0,
                  ),
                  small: true,
                )
              : FittedBox(
                  fit: BoxFit.contain,
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
                              sheet,
                              fit: BoxFit.fill,
                              cacheWidth: 900,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
