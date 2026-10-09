import 'package:flutter/material.dart';

enum TutorMoment {
  welcome,
  journey,
  practice,
  lesson,
  correct,
  retry,
  complete,
}

enum TutorMood { neutral, thinking, happy, surprised }

class TutorProfile {
  const TutorProfile({
    required this.id,
    required this.name,
    required this.origin,
    required this.traits,
    required this.introduction,
    required this.portrait,
    required this.lines,
    this.thinkingPortrait,
    this.happyPortrait,
    this.surprisedPortrait,
    this.accent = const Color(0xFFDA70AE),
    this.face = Alignment.topCenter,
    this.body,
  });
  final String id, name, origin, traits, introduction, portrait;
  final String? thinkingPortrait, happyPortrait, surprisedPortrait, body;
  final Color accent;
  final Alignment face;
  final Map<TutorMoment, String> lines;
  String say(TutorMoment moment) => lines[moment]!;
  String imageFor(TutorMood mood) => switch (mood) {
    TutorMood.thinking => thinkingPortrait ?? portrait,
    TutorMood.happy => happyPortrait ?? portrait,
    TutorMood.neutral => portrait,
    TutorMood.surprised => surprisedPortrait ?? thinkingPortrait ?? portrait,
  };
}

const tutors = [
  TutorProfile(
    id: 'kurisu',
    name: 'Kurisu Makise',
    origin: 'STEINS;GATE',
    traits: 'Analítica · ingeniosa · tsundere',
    introduction: 'Una buena hipótesis merece una comprobación. Te ayudaré a razonar… no te acostumbres a que te dé todas las respuestas.',
    portrait: 'assets/tutors/Gemini_Generated_Image_o69cjso69cjso69c.jpg',
    thinkingPortrait:
        'assets/tutors/Gemini_Generated_Image_3bicx63bicx63bic.jpg',
    happyPortrait: 'assets/tutors/Gemini_Generated_Image_zbr9mvzbr9mvzbr9.jpg',
    body: 'assets/tutors/Character_Profile_Kurisu_Makise.png',
    accent: Color(0xFF9470DA),
    lines: {
      TutorMoment.welcome: 'Hoy vamos a despejar dudas… y alguna x. Trae tu curiosidad; yo pongo el método.',
      TutorMoment.journey: 'Un resultado no se adivina: se construye. Revisa un paso a la vez. Sí, te acompaño.',
      TutorMoment.practice: 'El laboratorio está abierto. Prueba tu idea y comprueba el resultado; los errores también son datos.',
      TutorMoment.lesson: 'Primero la idea, después la evidencia. Observa cada transformación y pregúntate por qué funciona.',
      TutorMoment.correct:
          'Tu razonamiento se sostiene. Bien hecho… y sí, eso fue un cumplido.',
      TutorMoment.retry: 'Esa hipótesis necesita un ajuste. Revisa el paso señalado; la pista te ayudará a comprobarlo.',
      TutorMoment.complete: 'Resultados comprobados: unidad completada. Puedes estar orgulloso de tu esfuerzo. Yo… también lo estoy.',
    },
  ),
  TutorProfile(
    id: 'yuno',
    name: 'Yuno Gasai',
    origin: 'Mirai Nikki',
    traits: 'Dedicada · atenta · entusiasta',
    introduction: 'Voy a anotar cada pequeño logro en nuestro diario de estudio. ¡Hoy también podemos aprender algo bonito!',
    portrait: 'assets/tutors/Yuno_Gasai.webp',
    body: 'assets/tutors/yuno/Yuno_Gasai_presentacion en el menupng.png',
    accent: Color(0xFFCF659A),
    lines: {
      TutorMoment.welcome: '¡Te estaba esperando para estudiar! Abramos nuestro diario: hoy toca una pequeña victoria.',
      TutorMoment.journey: 'Cada ejercicio resuelto es una página más en tu diario. Vamos a tu ritmo, sin prisa.',
      TutorMoment.practice: 'Me quedaré aquí mientras lo intentas. Si necesitas una pista, solo tienes que pedirla.',
      TutorMoment.lesson: 'Vamos a cuidar cada paso. Primero vemos el ejemplo y después lo intentas tú.',
      TutorMoment.correct: '¡Sí! Voy a guardar este logro en nuestro diario. Tu esfuerzo está dando frutos.',
      TutorMoment.retry: 'Todavía podemos resolverlo. Respira, mira la pista y probemos con otra idea.',
      TutorMoment.complete: '¡Una página llena de logros! Lo hiciste con tu propio esfuerzo. ¿Seguimos o tomamos una pausa?',
    },
  ),
  TutorProfile(
    id: 'kotoko',
    name: 'Kotoko Ijichi',
    origin: 'Otaku ni Yasashii Gyaru wa Inai!?',
    traits: 'Alegre · sociable · buena estudiante',
    introduction: '¡Nada de rendirse ante una x! La dividimos en pasos y celebramos lo que descubras.',
    portrait: 'assets/tutors/ddd.jpg',
    body: 'assets/tutors/kotoko/presentacion de kotoko en la interfaz del menu.png',
    thinkingPortrait:
        'assets/tutors/Gemini_Generated_Image_lcj8kslcj8kslcj8.jpg',
    happyPortrait: 'assets/tutors/Gemini_Generated_Image_ua3i38ua3i38ua3i.jpg',
    surprisedPortrait:
        'assets/tutors/Gemini_Generated_Image_ae0u4fae0u4fae0u.jpg',
    accent: Color(0xFFBD803B),
    lines: {
      TutorMoment.welcome: '¡Hola! Una idea pequeña puede hacer brillar todo tu día. Vamos a descubrir la de hoy.',
      TutorMoment.journey: 'Tu ruta, tu ritmo. Hoy puede ser un solo paso, y ese paso también cuenta.',
      TutorMoment.practice: '¿Una x misteriosa? Me gustan los retos. Probemos con calma y una sonrisa.',
      TutorMoment.lesson: 'Vamos despacito: una idea, un ejemplo y tu gran intento. ¡Cuenta conmigo!',
      TutorMoment.correct: '¡Eso es! Te has ganado un corazón de ánimo y un poquito más de confianza.',
      TutorMoment.retry: 'Ups, revisemos esa parte. No pasa nada: las mejores ideas a veces llegan en el segundo intento.',
      TutorMoment.complete: '¡Qué buen trabajo! Has convertido un reto en algo que ya sabes hacer.',
    },
  ),
  TutorProfile(
    id: 'hakari',
    name: 'Hakari Hanazono',
    origin: 'Las 100 novias',
    traits: 'Dulce · astuta · considerada',
    introduction: 'Tengo una pequeña estrategia para esta x: dividir el problema en pasos. ¿La probamos juntos?',
    portrait: 'assets/tutors/dfd.jpg',
    thinkingPortrait: 'assets/tutors/dfd.jpg',
    happyPortrait: 'assets/tutors/dfd.jpg',
    body: 'assets/tutors/hakari/te_explica.png',
    face: Alignment(-.73, 0),
    accent: Color(0xFFCF659A),
    lines: {
      TutorMoment.welcome: 'Preparé un pequeño plan para tu aventura. Una idea, una pista y una victoria. ¿Empezamos?',
      TutorMoment.journey: 'Cada casilla guarda una idea bonita. Explora la que más curiosidad te dé.',
      TutorMoment.practice: 'Mi estrategia favorita: observar, probar y comprobar. Podemos intentarlo todas las veces que necesites.',
      TutorMoment.lesson: 'Lee conmigo y observa el ejemplo. Cuando estés listo, pasamos al siguiente paso.',
      TutorMoment.correct:
          '¡Lo entendiste! Qué bonito ver cómo encajan las ideas.',
      TutorMoment.retry: 'Vamos a mirar otra vez, con calma. La explicación nos muestra qué podemos cambiar.',
      TutorMoment.complete: '¡Una unidad más en tu aventura! Gracias por darte tiempo para aprender.',
    },
  ),
  TutorProfile(
    id: 'karane',
    name: 'Karane Inda',
    origin: 'Las 100 novias',
    traits: 'Tsundere · decidida · confiable',
    introduction: 'Te propongo un reto: entender el porqué, no solo acertar. ¡No te preocupes, te daré una mano!',
    portrait: 'assets/tutors/Gemini_Generated_Image_nlf4d8nlf4d8nlf4.jpg',
    thinkingPortrait:
        'assets/tutors/Gemini_Generated_Image_nlf4d8nlf4d8nlf4.jpg',
    happyPortrait: 'assets/tutors/Gemini_Generated_Image_nlf4d8nlf4d8nlf4.jpg',
    body: 'assets/tutors/karane/lo_hiciste_bien_2.png',
    face: Alignment(-1, -1),
    accent: Color(0xFF68865D),
    lines: {
      TutorMoment.welcome:
          '¿Listo para un reto? Hoy esa x no nos gana. Vamos, yo te acompaño.',
      TutorMoment.journey: 'No hace falta acabar hoy. Pero cada paso que des, ¡hazlo con curiosidad!',
      TutorMoment.practice: 'Quiero ver tu razonamiento. Si se complica, tienes pistas… claro que te ayudaré.',
      TutorMoment.lesson: 'Presta atención a cada paso. El truco es entender qué cambia y qué se conserva.',
      TutorMoment.correct:
          '¡Muy bien! Sabía que podías. Puedes sonreír, te lo has ganado.',
      TutorMoment.retry: 'Ese paso necesita otra mirada. No te rindas; revisa la pista y vuelve a probar.',
      TutorMoment.complete: 'Reto superado. Buen trabajo… sí, te estoy felicitando. ¡Vamos a por otra idea!',
    },
  ),
];

TutorProfile tutorFor(String id) =>
    tutors.firstWhere((t) => t.id == id, orElse: () => tutors.first);
String migrateTutor(String? id) => switch (id) {
  'Hikari' => 'yuno',
  'Rei' => 'kurisu',
  _ => tutors.any((t) => t.id == id) ? id! : 'kurisu',
};
