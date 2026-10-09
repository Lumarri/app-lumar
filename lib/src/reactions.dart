import 'tutors.dart';

part 'more_dialogues.dart';

enum ExerciseReaction {
  observing,
  hint,
  wrong,
  repeatedError,
  correct,
  streak,
  idle,
}

class TutorReactions {
  const TutorReactions({
    required this.images,
    required this.idleLine,
    required this.streakLine,
    this.streakAt = 3,
  });
  final Map<ExerciseReaction, List<String>> images;
  final String idleLine, streakLine;
  final int streakAt;

  String image(ExerciseReaction reaction, int variant) {
    final options = images[reaction] ?? images[ExerciseReaction.observing]!;
    return options[variant % options.length];
  }
}

const _root = 'assets/tutors';

String reactionExpression(String id, ExerciseReaction reaction) {
  final tsundere = id == 'kurisu' || id == 'karane';
  return switch (reaction) {
    ExerciseReaction.observing =>
      tsundere
          ? 'Hmm… te observa con curiosidad'
          : 'Sonríe, lista para acompañarte',
    ExerciseReaction.hint =>
      tsundere
          ? 'Ahem… señala el primer paso'
          : 'Se acerca con una idea: ¡mira!',
    ExerciseReaction.wrong =>
      tsundere
          ? 'Mmm… frunce el ceño, pensativa'
          : 'Oh… ladea la cabeza, pensativa',
    ExerciseReaction.repeatedError => 'Respira hondo… volvamos paso a paso',
    ExerciseReaction.correct =>
      tsundere
          ? '¡B-bien hecho! Sonríe con timidez'
          : '¡Yay! Sonríe con alegría',
    ExerciseReaction.streak =>
      tsundere ? '¡Wow! Intenta ocultar su emoción' : '¡Siii! Celebra tu racha',
    ExerciseReaction.idle => 'Aaah… se estira mientras espera',
  };
}

const tutorReactions = <String, TutorReactions>{
  'hahari': TutorReactions(
    idleLine: '[Sonríe] Hakari dice que estoy esperando demasiado. Puedes pensar con calma; la pista sigue aquí.',
    streakLine:
        '[Aplaude] ¡{racha} seguidos! Rentarou celebraría cada acierto. ♡',
    images: {
      ExerciseReaction.observing: [
        '$_root/hakari/hahari cuando fallaste su problema (exclusivo).png',
      ],
      ExerciseReaction.hint: [
        '$_root/hakari/hahari cuando fallaste su problema (exclusivo).png',
      ],
      ExerciseReaction.wrong: [
        '$_root/hakari/hahari cuando fallaste su problema (exclusivo).png',
      ],
      ExerciseReaction.repeatedError: [
        '$_root/hakari/hahari cuando fallaste su problema (exclusivo).png',
      ],
      ExerciseReaction.correct: [
        '$_root/hakari/hahari cuando fallaste su problema (exclusivo).png',
      ],
      ExerciseReaction.streak: [
        '$_root/hakari/hahari hanazono felicitandote cuando hagas 10 problemas sin fallar.png',
      ],
      ExerciseReaction.idle: [
        '$_root/hakari/hahari cuando fallaste su problema (exclusivo).png',
      ],
    },
  ),
  'kurisu': TutorReactions(
    streakAt: 5,
    idleLine: 'Estoy al otro lado de esta pantalla, esperando tu hipótesis… Tómate tu tiempo; la pista sigue aquí.',
    streakLine: '¡{racha} seguidos! Tus resultados ya parecen una investigación seria. Sí, me emocioné un poco.',
    images: {
      ExerciseReaction.observing: [
        '$_root/kurisu/analiza_el_problema.png',
        '$_root/kurisu/quiere_que_resuelvas_solo.png',
      ],
      ExerciseReaction.hint: [
        '$_root/kurisu/te_explica.png',
        '$_root/kurisu/te_explica__2.png',
      ],
      ExerciseReaction.wrong: ['$_root/kurisu/fallaste_pero_no_le_importa.png'],
      ExerciseReaction.repeatedError: [
        '$_root/kurisu/fallaste y esta enojada.png',
      ],
      ExerciseReaction.correct: [
        '$_root/kurisu/felicitaciones cientifico loco.png',
        '$_root/kurisu/le_sorprendiste_al_resolverlo.png',
      ],
      ExerciseReaction.streak: [
        '$_root/kurisu/se_emociona_solo_si_estas_en_racha_de_5_problemas_resueltos.png',
      ],
      ExerciseReaction.idle: [
        '$_root/kurisu/no_quiere_que_la_interrumpas_y_hagas_el_problema_solo.png',
      ],
    },
  ),
  'yuno': TutorReactions(
    streakAt: 4,
    idleLine: '¡Eh, sigo aquí en tu pantalla! Mientras piensas, preparo otra página del diario. ¿Te acompaño con una pista?',
    streakLine: '¡{racha} respuestas seguidas! El diario está lleno de corazones de ánimo. ¡Qué bien lo estás haciendo!',
    images: {
      ExerciseReaction.observing: [
        '$_root/yuno/quiere_que_resuelvasel_problema_para_ella_sola.png',
      ],
      ExerciseReaction.hint: [
        '$_root/yuno/te_explica.png',
        '$_root/yuno/te_explica__2.png',
      ],
      ExerciseReaction.wrong: ['$_root/yuno/fallaste_pero_te_perdona.png'],
      ExerciseReaction.repeatedError: [
        '$_root/yuno/fallaste_pero_te_perdona.png',
      ],
      ExerciseReaction.correct: [
        '$_root/yuno/te_felicita.png',
        '$_root/yuno/te_felicita_2.png',
      ],
      ExerciseReaction.streak: [
        '$_root/yuno/hiciste_racha_de_4_problemas_resueltos.png',
      ],
      ExerciseReaction.idle: [
        '$_root/yuno/quiere_que_resuelvasel_problema_para_ella_sola.png',
      ],
    },
  ),
  'kotoko': TutorReactions(
    idleLine: '¡Hola, tú, detrás de la pantalla! Me estaba quedando sin poses… Piensa con calma; podemos mirar una pista.',
    streakLine: '¡{racha} seguidos! Tu razonamiento está brillando. ¡Choca esos cinco con la pantalla… con suavidad!',
    images: {
      ExerciseReaction.observing: ['$_root/kotoko/explicando__1.png'],
      ExerciseReaction.hint: [
        '$_root/kotoko/explicando__3.png',
        '$_root/kotoko/kotoko resolviendo tu duda.png',
      ],
      ExerciseReaction.wrong: ['$_root/kotoko/asustada_por_el_error.png'],
      ExerciseReaction.repeatedError: ['$_root/kotoko/corrigiendote.png'],
      ExerciseReaction.correct: ['$_root/kotoko/felicitaciones.png'],
      ExerciseReaction.streak: ['$_root/kotoko/felicitaciones.png'],
      ExerciseReaction.idle: ['$_root/kotoko/explicando__1.png'],
    },
  ),
  'hakari': TutorReactions(
    idleLine: 'Psst… aunque viva en esta pantalla, puedo ayudarte. ¿Preparamos una estrategia? No hay ninguna prisa.',
    streakLine: '¡{racha} seguidos! Nuestro pequeño plan funciona. Tú pones el razonamiento; yo pongo los corazones.',
    images: {
      ExerciseReaction.observing: [
        '$_root/hakari/esta_pensando_en_ayudarte.png',
      ],
      ExerciseReaction.hint: [
        '$_root/hakari/te_explica.png',
        '$_root/hakari/te_explica__2.png',
      ],
      ExerciseReaction.wrong: [
        '$_root/hakari/fallaste_y_quiere_que_lo_hagas_de_nuevo.png',
      ],
      ExerciseReaction.repeatedError: [
        '$_root/hakari/no_le_gusta_que_falles.png',
      ],
      ExerciseReaction.correct: [
        '$_root/hakari/le_gusta_que_hayas_resuelto_el_problema.png',
        '$_root/hakari/te_feliciita.png',
      ],
      ExerciseReaction.streak: ['$_root/hakari/te_feliciita.png'],
      ExerciseReaction.idle: ['$_root/hakari/esta_pensando_en_ayudarte.png'],
    },
  ),
  'karane': TutorReactions(
    idleLine: '¡Oye! Llevo un rato posando aquí en tu pantalla… Está bien, piensa tranquilo. Si quieres, te doy una pista.',
    streakLine: '¡{racha} seguidos! Vale, eso estuvo genial… Sí, te estoy felicitando. ¡Sigue así!',
    images: {
      ExerciseReaction.observing: [
        '$_root/karane/lo_hiciste_bien.png',
        '$_root/karane/no_quiere_que_le_hables_hasta_que_resuelvas_el_problema.png',
      ],
      ExerciseReaction.hint: [
        '$_root/karane/te_explica.png',
        '$_root/karane/te_explica.png',
        '$_root/karane/te_explica.png',
      ],
      ExerciseReaction.wrong: ['$_root/karane/fallaste_y_esta_enojada.png'],
      ExerciseReaction.repeatedError: ['$_root/karane/fallaste_mas_de_3.png'],
      ExerciseReaction.correct: [
        '$_root/karane/lo_hiciste_bien.png',
        '$_root/karane/hallaste_la_solucion_pero_es_orgullosa.png',
        '$_root/karane/te_felicita.png',
      ],
      ExerciseReaction.streak: ['$_root/karane/felicitaciones.png'],
      ExerciseReaction.idle: [
        '$_root/karane/no_quiere_que_le_hables_hasta_que_resuelvas_el_problema.png',
      ],
    },
  ),
};

String reactionLine(
  TutorProfile tutor,
  ExerciseReaction reaction, {
  int streak = 0,
  int variant = 0,
}) {
  final base = switch (reaction) {
    ExerciseReaction.idle => tutorReactions[tutor.id]!.idleLine,
    ExerciseReaction.streak => tutorReactions[tutor.id]!.streakLine,
    ExerciseReaction.correct => tutor.say(TutorMoment.correct),
    ExerciseReaction.wrong => tutor.say(TutorMoment.retry),
    ExerciseReaction.repeatedError =>
      '${tutor.say(TutorMoment.retry)} Probemos el primer paso con la pista, juntos.',
    ExerciseReaction.hint => tutor.say(TutorMoment.lesson),
    _ => tutor.say(TutorMoment.practice),
  };
  final choices = [
    ...?animeReferences[tutor.id]?[reaction],
    base,
    ...?reactionVariants[tutor.id]?[reaction],
    ...?extendedReactionVariants[tutor.id]?[reaction],
  ];
  return choices[variant % choices.length].replaceAll(
    '{racha}',
    '${streak > 0 ? streak : tutorReactions[tutor.id]!.streakAt}',
  );
}

// New Spanish lines, with references rather than copied anime dialogue.
const animeReferences = <String, Map<ExerciseReaction, List<String>>>{
  'kurisu': {
    ExerciseReaction.observing: [
      '[Cruza los brazos] Okabe llamaría a esto una operación con un nombre ridículo. Yo lo llamo leer el enunciado. Vamos, demuestra tu hipótesis.',
    ],
    ExerciseReaction.hint: [
      '[Señala el problema] No necesitas un D-mail para arreglar este paso. Te doy una pista aquí y ahora… ¡y deja de llamarme Christina!',
    ],
    ExerciseReaction.wrong: [
      '[Frunce el ceño] Maldición, ese cálculo tomó una línea de mundo equivocada. Revisa la explicación; aún podemos corregir el experimento.',
    ],
    ExerciseReaction.repeatedError: [
      '[Suspira y se acerca] Ni el microondas del laboratorio arregla un cálculo a base de pulsar botones. Lee la pista conmigo, un paso cada vez.',
    ],
    ExerciseReaction.correct: [
      '[Sonríe de reojo] Resultado confirmado. Daru podría archivarlo y Okabe presumiría durante media hora. Yo… estoy orgullosa de tu método.',
    ],
    ExerciseReaction.streak: [
      '[Se sonroja] ¡{racha} seguidos! Hasta Okabe dejaría su discurso para mirar esto. ¡No es que estuviera pendiente de cada acierto!… Bueno, sí.',
    ],
    ExerciseReaction.idle: [
      '[Mira el reloj] ¿Esperas una llamada de Okabe? Yo también estoy aquí, atrapada en tu pantalla. Cuando vuelvas, nuestro experimento sigue pendiente.',
    ],
  },
  'yuno': {
    ExerciseReaction.observing: [
      '[Sonríe con intensidad] Mi Diario del Futuro dice que hoy habrá un descubrimiento. Yukki preguntaría cómo lo sé… Tendrás que comprobarlo tú. ♡',
    ],
    ExerciseReaction.hint: [
      '[Abre el diario] Dejé una anotación para este momento. Yukki también necesita pistas a veces. Ven, mira el primer paso conmigo.',
    ],
    ExerciseReaction.wrong: [
      '[Se queda seria] Esa predicción salió mal… Qué rabia. Cambiemos esta página del futuro: mira dónde se torció el cálculo.',
    ],
    ExerciseReaction.repeatedError: [
      '[Baja la voz] El diario no decide por ti. Yukki y yo sabemos que una decisión cambia el siguiente paso. Probemos con la pista.',
    ],
    ExerciseReaction.correct: [
      '[Junta las manos] ¡Lo sabía! Bueno… mi diario no hizo las cuentas; las hiciste tú. Quiero guardar este momento junto a los de Yukki. ♡',
    ],
    ExerciseReaction.streak: [
      '[Sonríe emocionada] ¡{racha} aciertos! Mi Diario del Futuro se está llenando de buenas noticias. Yukki tendría que ver esta racha.',
    ],
    ExerciseReaction.idle: [
      '[Inclina la cabeza] Ni el diario me dice si estás calculando o fuiste por agua. Yukki también se distrae… Yo guardaré esta página hasta que vuelvas.',
    ],
  },
  'kotoko': {
    ExerciseReaction.observing: [
      '[Te saluda de cerca] ¡Ey, equipo! Takuya puede explicar Kiramon sin respirar; tú puedes explicarme este problema. Te escucho, sin juzgarte.',
    ],
    ExerciseReaction.hint: [
      '[Guiña un ojo] ¡Pista de Kotoko! Kei, deja de fingir que no te interesa y ven a estudiar. Vamos a partir el problema en trocitos.',
    ],
    ExerciseReaction.wrong: [
      '[Hace una mueca] Uf, ese no era. Con Takuya repasaría el paso igual que contigo. Ser otaku no te quita puntos; saltarte la fórmula sí cambia el resultado.',
    ],
    ExerciseReaction.repeatedError: [
      '[Se remanga] Tengo práctica ayudando a mis hermanos. ¡No me asusta un problema terco! Primero la pista; después me cuentas qué entendiste.',
    ],
    ExerciseReaction.correct: [
      '[Levanta los brazos] ¡Esooo! Takuya pondría cara de final de temporada de Kiramon. Yo pongo cara de “sabía que podías”. ¡Choca esos cinco!',
    ],
    ExerciseReaction.streak: [
      '[Ríe] ¡{racha} seguidos! Hasta Kei tendría que admitir que esto engancha. Nuestro club de estudio se está luciendo.',
    ],
    ExerciseReaction.idle: [
      '[Se asoma al borde de la pantalla] ¿Te quedaste viendo anime, como Takuya? Te espero, pero luego me cuentas tu idea. ¡Kei y yo no hacemos las cuentas por telepatía!',
    ],
  },
  'hakari': {
    ExerciseReaction.observing: [
      '[Sonríe con picardía] Rentarou haría cien planes para ayudarnos. Yo tengo uno bastante bueno: tú calculas, yo te acompaño y Karane finge que no le importa. ♡',
    ],
    ExerciseReaction.hint: [
      '[Susurra una idea] Una estrategia de Hakari, solo para este paso. Si Karane pregunta, dile que también puede pedir ayuda. Ya la vi mirando el botón.',
    ],
    ExerciseReaction.wrong: [
      '[Infla las mejillas] Vaya, mi plan tenía un agujero. Karane ya estaría protestando… Mejor revisamos el cálculo antes de discutir quién tenía razón.',
    ],
    ExerciseReaction.repeatedError: [
      '[Se pone seria] Hasta mis mejores planes necesitan revisiones. Rentarou no se rendiría con nosotros; volvamos al primer paso y usemos la pista.',
    ],
    ExerciseReaction.correct: [
      '[Sonríe satisfecha] ¡Plan perfecto! Me encantan las buenas cuentas. Karane, puedes felicitarnos sin decir que lo haces por obligación. ♡',
    ],
    ExerciseReaction.streak: [
      '[Aplaude] ¡{racha} seguidos! Rentarou celebraría cada uno. Yo ya estoy organizando la próxima victoria… Karane, deja de sonreír a escondidas.',
    ],
    ExerciseReaction.idle: [
      '[Juega con un mechón] Karane dice que no está esperando y lleva rato mirando la pantalla. Yo sí te espero; mi plan admite una pausa. ♡',
    ],
  },
  'karane': {
    ExerciseReaction.observing: [
      '[Cruza los brazos, sonrojada] Hakari dice que no puedo animarte sin protestar. ¡Qué tontería!… Vamos, concéntrate. Rentarou también querría verte intentarlo.',
    ],
    ExerciseReaction.hint: [
      '[Aparta la mirada] ¡Toma la pista de una vez! No es un plan secreto de Hakari. La preparé yo… porque este maldito paso merece una explicación clara.',
    ],
    ExerciseReaction.wrong: [
      '[Frunce el ceño] ¡Argh, ese no! No voy a endulzarlo como Hakari: toca revisar el cálculo. Y sí, me quedo contigo. ¿Algún problema?',
    ],
    ExerciseReaction.repeatedError: [
      '[Respira hondo] ¡Basta de adivinar! Rentarou siempre se esfuerza por entender a todos; nosotros podemos esforzarnos por entender un paso. Abre la pista.',
    ],
    ExerciseReaction.correct: [
      '[Sonríe y luego mira a otro lado] ¡Bien hecho! Hakari, no digas nada de mi cara. ¡Estoy contenta por el acierto, y ya está!',
    ],
    ExerciseReaction.streak: [
      '[Se sonroja muchísimo] ¡{racha} seguidos! Hasta Rentarou se quedaría impresionado. ¡Y no, Hakari, no estoy llevando la cuenta porque me encante celebrar!',
    ],
    ExerciseReaction.idle: [
      '[Golpea el suelo con el pie] ¡Oye! Hakari ya inventó tres planes mientras esperamos. ¿Sigues ahí? Puedes descansar… pero avisa con una respuesta cuando vuelvas.',
    ],
  },
};

// Original educational dialogue: inspired by traits, never canonical quotes.
const reactionVariants = <String, Map<ExerciseReaction, List<String>>>{
  'kurisu': {
    ExerciseReaction.observing: [
      'Antes de tocar una respuesta, formula tu hipótesis. Quiero ver el método detrás de ese dedo en la pantalla.',
      'No me mires a mí todo el rato: la incógnita está arriba. Aunque… sí, me quedaré para revisar tu razonamiento.',
    ],
    ExerciseReaction.hint: [
      'Una pista, no una solución completa. El laboratorio funciona mejor cuando tú haces el descubrimiento.',
      'Te prestaré una idea: identifica qué operación corresponde primero. Después comprobamos tu hipótesis.',
    ],
    ExerciseReaction.wrong: [
      'Ese resultado no supera la comprobación. Nada grave: acabamos de descubrir un camino que necesita corregirse.',
      'Mmm… hay un paso que no encaja. Antes de cambiar de respuesta, comprueba qué operación hiciste primero.',
    ],
    ExerciseReaction.repeatedError: [
      'Varias hipótesis descartadas. Cambiemos de estrategia: lee la pista y justifica solamente el primer paso.',
      'No pruebes botones al azar. Te acompaño desde el inicio; entender un paso vale más que acertar por suerte.',
    ],
    ExerciseReaction.correct: [
      'La comprobación coincide. Un resultado elegante… No pongas esa cara, claro que reconozco un buen trabajo.',
      'Método correcto, conclusión correcta. Me sorprendiste. Para bien, por si hacía falta aclararlo.',
    ],
    ExerciseReaction.streak: [
      '¡{racha} aciertos consecutivos! Ya puedes presentar tus resultados al laboratorio. Yo revisé todo… porque me interesa tu progreso.',
      'Racha de {racha}. Evidencia suficiente para decir que lo estás entendiendo. Está bien: ¡excelente trabajo!',
    ],
    ExerciseReaction.idle: [
      'Mi pose lleva demasiado tiempo congelada en esta pantalla. Tu investigación puede continuar a su ritmo; avísame con la pista.',
      '¿Estás calculando o pensando en otra cosa? Podemos hacer una pausa. Las ecuaciones y yo seguiremos aquí.',
    ],
  },
  'yuno': {
    ExerciseReaction.observing: [
      '¡Tengo el diario abierto! Cuéntame tu idea con una respuesta y la comprobamos juntos.',
      'Te veo pensando desde este lado de la pantalla. No necesitas correr; vamos paso a paso.',
    ],
    ExerciseReaction.hint: [
      'Guardé una pequeña ayuda para este momento. Léela despacito y después prueba tu propia idea.',
      'Vamos a iluminar una parte del problema. Tú eliges cuándo dar el siguiente paso; yo te acompaño.',
    ],
    ExerciseReaction.wrong: [
      'Esta página necesita una corrección, no borrarse. Tu esfuerzo sigue contando; revisemos la explicación.',
      'No salió todavía. Respiremos un momento y busquemos juntos el paso que se desvió.',
    ],
    ExerciseReaction.repeatedError: [
      'Hemos hecho varios intentos. Voy a acompañarte con una pista; esta vez probemos solamente el primer paso.',
      'No tienes que resolverlo todo de golpe. Dividamos el problema y anotemos una idea a la vez.',
    ],
    ExerciseReaction.correct: [
      '¡Otra pequeña victoria para el diario! Lo resolviste tú, con tu esfuerzo. Me alegra acompañarte.',
      '¡Sí, esa es! Dibujaría un corazón junto a este logro… La pantalla ya tiene unos cuantos, ¿verdad?',
    ],
    ExerciseReaction.streak: [
      '¡{racha} seguidos! Voy a necesitar otra página para tantos logros. Puedes estar orgulloso de ti.',
      'Racha de {racha}: ¡qué bonita colección de ideas bien resueltas! Seguimos a tu ritmo.',
    ],
    ExerciseReaction.idle: [
      'Mi diario sigue abierto. ¿Quieres pensar un poco más o pedir una pista? Las dos opciones están bien.',
      '¡Psst, sigo aquí! Hasta una tutora de pantalla necesita estirarse. Podemos tomar una pequeña pausa.',
    ],
  },
  'kotoko': {
    ExerciseReaction.observing: [
      '¡Vamos, equipo! Parece un reto grande, pero lo convertimos en pasos pequeñitos.',
      'Tú, yo y una x misteriosa. ¡Buen plan para hoy! Prueba tu idea sin miedo a equivocarte.',
    ],
    ExerciseReaction.hint: [
      '¡Pista especial de Kotoko! Busca el primer paso; cuando lo encuentres, el resto será más claro.',
      'Vamos a quitarle el misterio a este ejercicio. Lee esta ayuda y luego inténtalo tú.',
    ],
    ExerciseReaction.wrong: [
      '¡Ups! Nos desviamos un poquito. Mira la explicación y volvemos al camino con calma.',
      'Ese intento nos dejó una pista sobre qué revisar. No te rindas: ¡tu siguiente idea puede funcionar!',
    ],
    ExerciseReaction.repeatedError: [
      'Probemos otro plan: nada de elegir al azar. Leemos la pista y hacemos solo la primera operación.',
      '¿Se está poniendo pesado? Tomamos aire, bajamos el ritmo y lo dividimos. ¡Cuenta conmigo!',
    ],
    ExerciseReaction.correct: [
      '¡Esooo! Te quedó genial. Ahora sabes algo que antes parecía difícil.',
      '¡Acierto con estilo! Un corazón de ánimo para ti y una sonrisa enorme de mi parte.',
    ],
    ExerciseReaction.streak: [
      '¡{racha} seguidos! Estás brillando más que los corazones del menú. ¡Qué buen trabajo!',
      'Racha de {racha}. ¡Nuestro equipo está en forma! Sigue comprobando cada respuesta, ¿sí?',
    ],
    ExerciseReaction.idle: [
      '¡Eh, sigo posando aquí! Si necesitas pensar, perfecto. Si necesitas ayuda, mi botón de pista está listo.',
      'Creo que estos corazones ya dieron tres vueltas mientras espero. Tú tranquilo: podemos hacer una pausa.',
    ],
  },
  'hakari': {
    ExerciseReaction.observing: [
      'Tengo una pequeña estrategia: observa qué te piden y elige el primer movimiento. Tú puedes descubrirlo.',
      'Cada problema guarda un camino. Miremos con atención antes de elegir; me gustan los planes bien pensados.',
    ],
    ExerciseReaction.hint: [
      'Preparé una ayuda para el punto más importante. Vamos a probarla sin saltarnos el razonamiento.',
      'Aquí tienes nuestro siguiente movimiento. Una pista pequeña puede ordenar muchas ideas.',
    ],
    ExerciseReaction.wrong: [
      'Nuestro plan necesita un ajuste. Esta explicación nos dice exactamente dónde empezar otra vez.',
      'Todavía no encajan todas las piezas. Miremos ese paso con cariño y con atención.',
    ],
    ExerciseReaction.repeatedError: [
      'Cambiemos de estrategia: primero la pista, luego un solo paso. No hace falta resolverlo todo ahora.',
      'Varios intentos nos enseñaron qué caminos descartar. Ahora construyamos uno nuevo, despacito.',
    ],
    ExerciseReaction.correct: [
      '¡Nuestro plan funcionó! Qué bonito ver que tu razonamiento encuentra el camino.',
      '¡Una idea muy bien resuelta! Merece un corazón de ánimo y una comprobación final.',
    ],
    ExerciseReaction.streak: [
      '¡{racha} seguidos! Tu estrategia está dando frutos. Me encanta celebrar cada descubrimiento contigo.',
      'Racha de {racha}: todo encaja. Conserva ese hábito de observar, resolver y comprobar.',
    ],
    ExerciseReaction.idle: [
      'Estoy preparando otro plan mientras tú piensas. Hasta puedo esperar dentro de este globo de diálogo.',
      'Parece que mi pose se quedó en pausa. ¿Continuamos con una pista o descansamos un poquito?',
    ],
  },
  'karane': {
    ExerciseReaction.observing: [
      '¡A ver esa idea! Quiero que lo intentes por ti mismo… pero claro que estaré aquí para ayudarte.',
      'La respuesta no va a saltar sola de la pantalla. Probemos un paso. ¡No te estoy apurando!',
    ],
    ExerciseReaction.hint: [
      'Está bien, te doy una pista. No tienes que hacerlo todo sin ayuda; aprender también es saber preguntar.',
      'Mira este paso con atención. Preparé la ayuda porque… ¡porque quiero que entiendas el ejercicio!',
    ],
    ExerciseReaction.wrong: [
      '¡Ese paso se torció! Pero no vamos a rendirnos por eso. Mira la explicación y prueba otra vez.',
      'Todavía no. Revisa el orden antes de elegir de nuevo. Sí, me quedo contigo hasta que lo entiendas.',
    ],
    ExerciseReaction.repeatedError: [
      '¡Cambio de plan! Vamos desde el primer paso, con la pista. No voy a dejar que este problema te quite las ganas.',
      'Ya probamos varias veces. Baja el ritmo y piensa en una sola operación. ¡Te ayudaré, claro que sí!',
    ],
    ExerciseReaction.correct: [
      '¡Lo hiciste bien! No es que esté sorprendida… Vale, sí estoy contenta por ti.',
      'Respuesta comprobada. Buen trabajo… ¡Puedes aceptar el cumplido sin hacer tanto alboroto!',
    ],
    ExerciseReaction.streak: [
      '¡{racha} seguidos! Eso merece una felicitación. Ahí la tienes: ¡excelente trabajo!',
      'Racha de {racha}. Sabía que tenías buenas ideas… Sí, estaba prestando atención a tus aciertos.',
    ],
    ExerciseReaction.idle: [
      '¡Oye, yo también llevo rato esperando en esta pantalla! Está bien: piensa con calma. La pista no se va a escapar.',
      'Mi pose se está cansando… Podemos descansar un momento y luego volver. ¡No hace falta correr!',
    ],
  },
};
