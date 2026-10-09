import 'package:flutter/material.dart';

import 'curriculum.dart';
import 'advanced_dialogues.dart';
import 'tutors.dart';
import 'widgets.dart';
import 'widgets/tutor_overlay.dart';

const farewellAssets = {
  'kurisu': [
    'assets/tutors/kurisu/te felicita por pasar la etapa del curso.png',
    'assets/tutors/kurisu/(esta imagen va al final del curso como una despedida con ella).png',
  ],
  'yuno': [
    'assets/tutors/yuno/despedida del curso de ella o la etapa diciedote woof que te ama mucho.png',
    'assets/tutors/yuno/lograste superar el curso con ella.png',
  ],
  'kotoko': [
    'assets/tutors/kotoko/felicitaciones por aprobar el curso con ella.png',
    'assets/tutors/kotoko/felicitaciones por aprobar el curso con ella.png',
  ],
  'hakari': [
    'assets/tutors/hakari/felicitandote7.png',
    'assets/tutors/hakari/felicitandote4.png',
  ],
  'karane': [
    'assets/tutors/karane/felicitandote por pasar el curso con ella.png',
    'assets/tutors/karane/felicitandote por pasar el curso con ella.png',
  ],
};
const stageGoodbyes = {
  'kurisu': [
    '[Sonríe de reojo] Etapa completada, investigador. Daru puede archivar tus resultados; Okabe seguro les inventará un nombre. Yo prefiero decir: buen trabajo.',
    '[Se cruza de brazos] Tu método superó las pruebas. Sí, disfruté investigar contigo… ¡No pongas esa cara! Guarda la regla para la siguiente etapa.',
  ],
  'yuno': [
    '[Hace una pose juguetona] ¡Woof! Una página del diario completada. Yukki se reiría de mi despedida, pero tu esfuerzo merece esta sonrisa. ♡',
    '[Te saluda] Esta etapa ya tiene final feliz. En el Diario del Futuro guardaría tus ideas y las correcciones que aprendimos juntos.',
  ],
  'kotoko': [
    '[Levanta ambos brazos] ¡Etapa aprobada! Takuya puede contar otro episodio de Kiramon, pero primero celebramos el tuyo. ¡Qué buen equipo!',
    '[Sonríe a la cámara imaginaria] Kei, ven a felicitarle: terminó la etapa. Yo me quedo con lo mejor de esta tarde de estudio, verte entender.',
  ],
  'hakari': [
    '[Junta las manos] Nuestro plan cerró esta etapa. Rentarou estaría orgulloso; Karane lo está, aunque diga que solo estaba revisando. ♡',
    '[Sonríe con picardía] Objetivo conseguido. Mi siguiente estrategia incluye una pausa y luego otra etapa contigo. Guarda también el procedimiento.',
  ],
  'karane': [
    '[Se sonroja y levanta el puño] ¡Etapa superada! Hakari, deja de mirar mi sonrisa. Estoy contenta porque se esforzó… ¡Y lo digo sin esconderme!',
    '[Aparta la mirada] Rentarou te felicitaría. Yo también: lo hiciste bien. No creas que me iré sin despedirme después de estudiar contigo.',
  ],
};
const courseGoodbyes = {
  'kurisu': [
    '[Sonríe, sin ocultarlo] Curso completo. El laboratorio puede confirmar que terminaste todos sus ejercicios. No soy t-tsundere… ¡Está bien, estoy orgullosa de ti!',
    '[Te saluda con su bata] Okabe haría un discurso de una hora. Yo te digo gracias por investigar conmigo. Descansa; el siguiente experimento puede esperar.',
  ],
  'yuno': [
    '[Abraza el diario] Terminaste todo el curso. Qué bonito guardar tantas páginas de esfuerzo. Yukki tendría que verlas; yo disfruté cada descubrimiento contigo. ♡',
    '[Sonríe emocionada] Llegamos al final del curso. Esta despedida no borra tus logros: seguirán guardados cuando vuelvas para otra aventura.',
  ],
  'kotoko': [
    '[Ríe y levanta los brazos] ¡Curso aprobado! Nuestro club acaba de cerrar una temporada de estudio. Takuya, Kei: aplausos para nuestro compañero.',
    '[Te saluda con entusiasmo] Ya puedes enseñar algunos de estos pasos a un amigo. Gracias por estudiar conmigo; hoy tu logro fue el protagonista del episodio.',
  ],
  'hakari': [
    '[Sonríe a su recuerdo de Rentarou] El plan más bonito fue verte terminar todo el curso. Karane y yo celebramos contigo… y mi mamá también, claro. ♡',
    '[Aplaude feliz] Curso completo, estrategia comprobada. Lleva contigo las reglas, no solo los puntos. Me encantó compartir estos descubrimientos.',
  ],
  'karane': [
    '[Se sonroja muchísimo] ¡Terminaste el curso! No es que esté emocionada… ¡Sí lo estoy! Rentarou y Hakari pueden oírlo: estoy orgullosa de tu esfuerzo.',
    '[Sonríe y te saluda] Gracias por quedarte hasta el final. Puedes descansar ahora. ¡Y si vuelves a estudiar conmigo, también voy a alegrarme!',
  ],
};

class TutorFarewell extends StatelessWidget {
  const TutorFarewell({
    super.key,
    required this.tutor,
    required this.lesson,
    required this.courseComplete,
  });
  final TutorProfile tutor;
  final Lesson lesson;
  final bool courseComplete;
  @override
  Widget build(BuildContext context) {
    final variants = (courseComplete
        ? courseGoodbyes
        : stageGoodbyes)[tutor.id]!;
    final message =
        '${variants[allLessons.indexOf(lesson) % variants.length]}\n\n${personalizedFarewell(tutor, lesson, courseComplete)}';
    return Column(
      children: [
        SizedBox(
          height: 230,
          child: TutorOverlay(
            asset: farewellAssets[tutor.id]![courseComplete ? 1 : 0],
            label:
                '${tutor.name} se despide de ${courseComplete ? seasonForLesson(lesson).title : lesson.title}',
            accent: tutor.accent,
            animationToken: 'farewell:${tutor.id}:${lesson.id}:$courseComplete',
          ),
        ),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                courseComplete
                    ? '¡Curso completado!'
                    : 'Hasta la siguiente etapa',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(message),
            ],
          ),
        ),
      ],
    );
  }
}
