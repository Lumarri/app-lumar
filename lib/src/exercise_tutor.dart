import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'widgets/tutor_overlay.dart';
import 'widgets/tutor_hint_avatar.dart';

import 'reactions.dart';
import 'tutors.dart';
import 'widgets.dart';

class ExerciseTutor extends StatelessWidget {
  const ExerciseTutor({
    super.key,
    required this.tutor,
    required this.reaction,
    required this.variant,
    required this.message,
    required this.streak,
    this.onHint,
    this.showingHint = false,
    this.feedbackTitle,
    this.explanation,
  });
  final TutorProfile tutor;
  final ExerciseReaction reaction;
  final int variant, streak;
  final String message;
  final VoidCallback? onHint;
  final bool showingHint;
  final String? feedbackTitle, explanation;
  @override
  Widget build(BuildContext context) {
    final image = tutorReactions[tutor.id]!.image(reaction, variant);
    final expression = reactionExpression(tutor.id, reaction);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (streak > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '♥ Racha: $streak ${streak == 1 ? 'acierto' : 'aciertos'}',
              style: const TextStyle(color: rose, fontWeight: FontWeight.w800),
            ),
          ),
        LayoutBuilder(
          builder: (context, constraints) {
            final narrow =
                constraints.maxWidth < 300 ||
                MediaQuery.textScalerOf(context).scale(14) > 18;
            final bubble = Panel(
              color: const Color(0xFFFFEDF8),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    tutor.name,
                    style: TextStyle(
                      color: tutor.accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (exclusiveTutorIcons.containsKey(tutor.id)) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TutorHintAvatar(tutor: tutor, reaction: reaction),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    expression,
                    key: const ValueKey('tutor-expression'),
                    style: const TextStyle(
                      color: violet,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 9),
                  if (feedbackTitle != null) ...[
                    Text(
                      feedbackTitle!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Semantics(
                    liveRegion: true,
                    child: Text(message, key: const ValueKey('tutor-dialogue')),
                  ),
                  if (explanation != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      explanation!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                  if (onHint != null) ...[
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: onHint,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(9),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 42,
                            height: 46,
                            child: TutorHintAvatar(
                              tutor: tutor,
                              reaction: ExerciseReaction.hint,
                              size: 42,
                            ),
                          ),
                          Text(
                            showingHint
                                ? 'Ocultar pista'
                                : 'Necesito una pista',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: narrow ? 0 : 108,
                    top: narrow ? 222 : 22,
                    bottom: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: narrow ? 0 : 270),
                    child: bubble,
                  ),
                ),
                Positioned(
                  left: narrow ? -6 : -20,
                  top: -26,
                  bottom: narrow ? null : 0,
                  height: narrow ? 245 : null,
                  width: narrow ? math.min(200, constraints.maxWidth) : 140,
                  child: TutorOverlay(
                    asset: image,
                    label: '${tutor.name}, $expression',
                    accent: tutor.accent,
                    animationToken: '$image:${reaction.name}:$variant',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
