import 'reactions.dart';
import 'tutors.dart';

/// Files are grouped by visible expression; suffix digits never set priority.
class TutorPose {
  const TutorPose(
    this.tutor,
    this.file,
    this.reaction,
    this.expression,
    this.lines, {
    this.minMistakes = 0,
    this.minStreak = 0,
    this.recovered = false,
    this.quick = false,
    this.exercises = const [],
  });
  final String tutor, file, expression;
  final ExerciseReaction reaction;
  final List<String> lines;
  final int minMistakes, minStreak;
  final bool recovered, quick;
  final List<int> exercises;
  String get asset => 'assets/tutors/$tutor/$file';
}

const newTutorPoses = <TutorPose>[
  TutorPose(
    'hakari',
    'es_pervertida_hasta_para_explicar_el_problema.png',
    ExerciseReaction.wrong,
    'Se sonroja al ver que su plan se enredó',
    [
      '[Se sonroja] Mi plan sonaba mejor en mi cabeza… Karane, no te rías. Vamos a revisar la cuenta antes de volver a elegir.',
      '[Se abanica] Hasta una estratega pierde el hilo. Rentarou revisaría los datos con nosotros; hagamos eso primero.',
    ],
  ),
  TutorPose(
    'karane',
    'no_le_gusta_los_halagos_pero_tu_le_gusto_que_resuelvas_el_problema.png',
    ExerciseReaction.correct,
    'Se sonroja, intentando esconder su sonrisa',
    [
      '[Se sonroja] ¡No exageres con los cumplidos! Lo importante es que lo resolviste. Bueno… sí, me alegro de haberte ayudado.',
      '[Mira a Hakari de reojo] Ya sé que estoy sonriendo. Rentarou también lo celebraría, ¿y qué? ¡Buen trabajo!',
    ],
  ),
  TutorPose(
    'karane',
    'te_dice_si_estas_idiota_por_no_resolverlo.png',
    ExerciseReaction.wrong,
    'Protesta, luego vuelve a explicar',
    [
      '[Protesta] ¡Ese cálculo se fue de paseo! Hakari, trae el mapa… digo, la pista. Vamos a comprobar qué operación tocaba.',
      '[Cruza los brazos] Si no sale, se pregunta. No te voy a pedir que adivines como si fueras un personaje leyendo el guion.',
    ],
  ),
  TutorPose(
    'kotoko',
    'coqueteandote.png',
    ExerciseReaction.idle,
    'Guiña un ojo, esperando tu idea',
    [
      '[Guiña un ojo] ¿Sigues ahí, compañero? Takuya también se distrae con su anime favorito. Podemos volver con una pista.',
      '[Sonríe] Yo pongo la compañía y tú vuelves cuando estés listo. El club de estudio no se cierra por una pausa.',
    ],
  ),
  TutorPose(
    'kotoko',
    'explicando.png',
    ExerciseReaction.hint,
    'Señala la regla con entusiasmo',
    [
      '[Levanta un dedo] ¡Regla importante! Takuya memoriza nombres de Kiramon; nosotros vamos a recordar para qué sirve esta fórmula.',
      '[Sonríe] Antes de elegir, piensa qué dato se conecta con lo que te piden. Mi pista empieza justamente ahí.',
    ],
  ),
  TutorPose(
    'kotoko',
    'kotoko sorprendida por tu hallazgo.png',
    ExerciseReaction.correct,
    'Abre mucho los ojos, impresionada por la idea',
    [
      '[Se queda boquiabierta] ¡Eso encajó perfecto! Kei, ven a mirar: nuestro compañero acaba de encontrar el camino.',
      '[Levanta las manos] ¡Qué buen descubrimiento! Un giro de guion digno de Kiramon… pero aquí lo explicaste con cálculos.',
    ],
  ),
  TutorPose(
    'kotoko',
    'riendose_de_ti_por_el_error.png',
    ExerciseReaction.wrong,
    'Sonríe para aliviar la tensión',
    [
      '[Suelta una risita y se calma] Esa cuenta hizo una pirueta. Nos reímos del lío, no de ti; vamos a revisar el paso juntos.',
      '[Sonríe con cariño] En el club también nos equivocamos. Takuya, Kei y tú pueden preguntar sin vergüenza; volvamos a la explicación.',
    ],
  ),
  TutorPose(
    'kurisu',
    'fallaste_y_te_va_a_dar_con_el_libro.png',
    ExerciseReaction.repeatedError,
    'Levanta el manual y propone repasarlo',
    [
      '[Levanta el manual] ¡Aquí está la regla que necesitamos! No es un ataque de la Organización; es una invitación a repasar el primer paso.',
      '[Se arremanga] Este libro tiene más paciencia que Okabe explicando sus planes. Vamos a abrir la pista y comprobar una operación.',
    ],
  ),
  TutorPose(
    'kurisu',
    'explicandote7.png',
    ExerciseReaction.hint,
    'Se cruza de brazos y explica el método',
    [
      '[Cruza los brazos] Okabe añadiría un nombre dramático; yo añado un paso verificable. Mira la pista y comprueba tu operación.',
      '[Te mira de reojo] No hace falta una máquina del tiempo: hace falta esta regla. Te la explico porque quiero que lo entiendas… ¡por razones científicas!',
    ],
  ),
  TutorPose(
    'kurisu',
    'enojada por fallar7.png',
    ExerciseReaction.wrong,
    'Frunce el ceño, dispuesta a corregir',
    [
      '[Aprieta los puños] ¡Argh! Esa cuenta no pasó el experimento. No le eches la culpa a la Organización: revisemos el paso.',
      '[Respira hondo] Okabe también me hace poner esta cara. Pero contigo podemos resolverlo: mira la explicación y vuelve a probar.',
    ],
  ),
  TutorPose(
    'kurisu',
    'houin kyoma eres idiota.png',
    ExerciseReaction.repeatedError,
    'Levanta una ceja y señala el error',
    [
      '[Levanta una ceja] Esta hipótesis tiene más agujeros que un discurso de Hououin Kyouma. Cambiemos de estrategia, empezando por la pista.',
      '[Suspira] No eres Okabe haciendo teatro; puedes corregir un paso concreto. Dime qué dato vas a usar primero.',
    ],
  ),
  TutorPose(
    'kurisu',
    'te dice idiota pero idiota intelgiente por resolver 8 seguidas.png',
    ExerciseReaction.streak,
    'Se acomoda las gafas, orgullosa',
    [
      '[Se acomoda las gafas] Ocho o más aciertos… hasta el científico loco tendría que reconocer tu método. ¡No te vuelvas presumido!',
      '[Sonríe de lado] Está bien, eres un científico loco bastante competente. Daru puede guardar los resultados: esta racha tiene evidencia.',
    ],
    minStreak: 8,
  ),
  TutorPose(
    'kurisu',
    'no le hables hasta que resuelvas el problema (aparece esta imagen cuando se encuentre en la tarea 10 y 18).png',
    ExerciseReaction.observing,
    'Espera tu hipótesis con los brazos cruzados',
    [
      '[Cruza los brazos] Esta vez quiero escuchar tu hipótesis primero. El laboratorio no funciona solo con mis explicaciones; luego la revisamos juntos.',
      '[Te observa en silencio] Tu turno, investigador. Okabe haría un discurso; tú puedes empezar con una operación. La pista sigue disponible.',
    ],
    exercises: [9, 17],
  ),
  TutorPose(
    'yuno',
    'dadonte la pista.png',
    ExerciseReaction.hint,
    'Se lleva un dedo a los labios y piensa',
    [
      '[Abre el diario] Guardé una pequeña pista en esta página. Yukki también se detendría a pensar antes del siguiente paso.',
      '[Se inclina hacia el texto] La respuesta no se predice: se construye. Mira esta ayuda; yo me quedo contigo. ♡',
    ],
  ),
  TutorPose(
    'yuno',
    'te da la pista .png',
    ExerciseReaction.hint,
    'Abre los ojos, lista para ayudarte',
    [
      '[Abre mucho los ojos] ¡Creo que encontramos la clave! Marca ese dato como una nota importante del Diario del Futuro.',
      '[Señala la pantalla] Yukki, mira… una pista pequeña cambia el camino. Ahora tú puedes probarla con tus datos.',
    ],
  ),
  TutorPose(
    'yuno',
    'explicadonte6.png',
    ExerciseReaction.observing,
    'Mira el problema con atención',
    [
      '[Mira el enunciado] Este futuro todavía no está escrito. Primero identifica lo que te piden; después anotamos el método.',
      '[Inclina la cabeza] ¿Qué pensaría Yukki al leer esto? Probablemente preguntaría qué dato tenemos. Empecemos por ahí.',
    ],
  ),
  TutorPose(
    'yuno',
    'diciendote que no te preocupes.png',
    ExerciseReaction.wrong,
    'Sonríe con calma y te anima',
    [
      '[Sonríe suavemente] No te preocupes por una página que salió mal. Podemos corregirla sin borrar todo el diario.',
      '[Habla despacito] Un error no decide tu futuro. Como con Yukki, reviso contigo qué paso podemos cambiar.',
    ],
  ),
  TutorPose(
    'yuno',
    'no le gusta que falles o si no ira contra el desarollador de la app.png',
    ExerciseReaction.repeatedError,
    'Hace una mueca y propone otro intento',
    [
      '[Hace una mueca] ¡Este problema es terco! Hasta miré al desarrollador detrás de la pantalla… Pero la pista nos ayudará más que protestar.',
      '[Se remanga] Mi diario registra intentos, no derrotas. Esta vez vamos a revisar una sola operación antes de elegir.',
    ],
  ),
  TutorPose(
    'yuno',
    'dandote feliciitaciones.png',
    ExerciseReaction.correct,
    'Levanta el teléfono para celebrar',
    [
      '[Levanta el teléfono] ¡Quedó registrado! Una buena noticia para el diario: lo resolviste con tus propias ideas.',
      '[Sonríe feliz] Quiero contarle a Yukki que este método funcionó. Guarda también la explicación, no solo el resultado.',
    ],
  ),
  TutorPose(
    'yuno',
    'esta feliz de que hayas resuelto el problema despues de varios intentos.png',
    ExerciseReaction.correct,
    'Cierra los ojos con alivio',
    [
      '[Sonríe aliviada] ¡Por fin encajó! Mi página favorita es esta: después de varios intentos, entendiste el paso.',
      '[Cierra los ojos, contenta] Cambiaste ese pequeño futuro con paciencia. Yukki estaría orgulloso de que no te rindieras.',
    ],
    recovered: true,
  ),
  TutorPose(
    'yuno',
    'emocionada de que lograras pasar el ejercisio que tanto te costaba.png',
    ExerciseReaction.correct,
    'Ríe, emocionada por tu recuperación',
    [
      '[Ríe emocionada] ¡Sí! El problema que se resistía acaba de entrar al diario de logros. Lo importante fue cómo lo corregiste.',
      '[Te mira feliz] Hubo intentos difíciles, pero el siguiente paso cambió todo. Así se escribe una buena página. ♡',
    ],
    recovered: true,
  ),
  TutorPose(
    'kotoko',
    'te explica8.png',
    ExerciseReaction.observing,
    'Muestra su teléfono con una sonrisa',
    [
      '[Levanta el teléfono] Hoy toca estudiar antes de comentar Kiramon con Takuya. ¿Qué dato te parece más útil?',
      '[Sonríe] Kei puede venir también; aquí cabemos todos. Tú empieza por leer la pregunta, que yo preparo el ánimo.',
    ],
  ),
  TutorPose(
    'kotoko',
    'te explica el problemat.png',
    ExerciseReaction.hint,
    'Levanta un dedo para destacar la regla',
    [
      '[Levanta un dedo] ¡Esta es la idea clave! Si puedo explicársela a mis hermanos, también podemos partirla en pasos para ti.',
      '[Guiña un ojo] Takuya se acelera con Kiramon; yo me freno con las fórmulas. Mira un solo paso de la pista.',
    ],
  ),
  TutorPose(
    'kotoko',
    'te da la pista.png',
    ExerciseReaction.hint,
    'Se inclina para explicarte con paciencia',
    [
      '[Se inclina hacia el ejercicio] Ven, estudiamos como compañeros de clase. La pista señala por dónde empezar, no tienes que adivinar.',
      '[Sonríe cerquita] Kei, no finjas que ya lo sabes. ¡Preguntar cuenta! Revisamos esta regla y después haces tú la operación.',
    ],
  ),
  TutorPose(
    'kotoko',
    'te da la pista pero aun asi no logras resolver el problema.png',
    ExerciseReaction.repeatedError,
    'Se sorprende y simplifica la explicación',
    [
      '[Abre la boca, sorprendida] ¡Uy, mi explicación no aterrizó! Probemos otro ejemplo mental y volvamos a la primera operación.',
      '[Se remanga] Nada de repetir la pista más rápido. Con mis hermanos funciona ir más despacio; contigo también lo intentamos.',
    ],
  ),
  TutorPose(
    'kotoko',
    'quiere renunicar por que fallaste varias veces.png',
    ExerciseReaction.repeatedError,
    'Hace una pausa para ordenar las ideas',
    [
      '[Se gira un momento] Necesito ordenar esta explicación, no abandonar el club. Takuya, trae una libreta; vamos desde el dato conocido.',
      '[Respira hondo] El problema nos ganó un intento, no la tarde de estudio. Pausa, pista y un paso pequeño.',
    ],
  ),
  TutorPose(
    'kotoko',
    'te felicita por aprobar un problema.png',
    ExerciseReaction.correct,
    'Sonríe, orgullosa de tu avance',
    [
      '[Sonríe ampliamente] ¡Eso estuvo genial! Puedes contar este paso tan bien como Takuya cuenta sus escenas de Kiramon.',
      '[Ofrece un choque de manos] ¡Acierto! Kei, mira: nuestro equipo resolvió otro. Y las cuentas las hizo nuestro estudiante.',
    ],
  ),
  TutorPose(
    'kotoko',
    'esta grabando tu logro.png',
    ExerciseReaction.streak,
    'Levanta el móvil para guardar el logro',
    [
      '[Levanta el móvil] ¡Esto merece un recuerdo para el club! Es una pose de celebración; la app no activa ninguna cámara.',
      '[Sonríe al teléfono] Takuya grabaría sus teorías de Kiramon; yo celebraría tu racha. ¡Equipo, qué bien lo estamos haciendo!',
    ],
  ),
  TutorPose(
    'hakari',
    'explicadonte5.png',
    ExerciseReaction.observing,
    'Sonríe con una estrategia en mente',
    [
      '[Sonríe como si tuviera un secreto] Ya tengo una estrategia. Rentarou pondría el esfuerzo; tú puedes empezar identificando los datos.',
      '[Junta las manos] Hakari tiene un plan, Karane tiene objeciones… y tú tienes un problema que podemos entender paso a paso.',
    ],
  ),
  TutorPose(
    'hakari',
    'explicandote el procedimiento.png',
    ExerciseReaction.hint,
    'Junta las manos y presenta el plan',
    [
      '[Junta las manos] Mi siguiente movimiento es esta regla. No saltes al final del plan; primero comprueba cómo encajan los datos.',
      '[Sonríe con picardía] Rentarou atendería cada detalle. Nosotros también: mira el procedimiento y elige la primera operación.',
    ],
  ),
  TutorPose(
    'hakari',
    'explicadonte con silencio de que karane no escuche.png',
    ExerciseReaction.hint,
    'Susurra una idea, mirando a Karane',
    [
      '[Baja la voz] Una estrategia entre nosotros… Karane, puedes escuchar también. Es una pista, no un complot. ♡',
      '[Sonríe de lado] Si Karane pregunta, dile que estudiamos la regla. Ya la veo mirando de reojo nuestra explicación.',
    ],
  ),
  TutorPose(
    'hakari',
    'hakari tensa ya que estas fallando 3 veces seguidas.png',
    ExerciseReaction.wrong,
    'Se pone seria y revisa el plan',
    [
      '[Se pone seria] Tres intentos necesitan un plan distinto. Dejemos las prisas y leamos la explicación concreta de esta opción.',
      '[Frunce un poquito el ceño] Hasta mis estrategias se revisan. Rentarou no nos pediría adivinar; abriría la pista con nosotros.',
    ],
    minMistakes: 3,
  ),
  TutorPose(
    'hakari',
    'hakari asustada de que vas fallando 7 veces seguidas.png',
    ExerciseReaction.repeatedError,
    'Se sorprende y propone empezar de nuevo',
    [
      '[Se sobresalta] ¡Siete intentos! Bien, nada de insistir igual. Vamos a hacer solamente el primer paso y comprobarlo.',
      '[Respira hondo] Mi plan se complicó demasiado. Karane, ayúdanos a simplificar: datos, regla y una sola operación.',
    ],
    minMistakes: 7,
  ),
  TutorPose(
    'hakari',
    'burlandose de karane.png',
    ExerciseReaction.correct,
    'Sonríe de lado, bromeando con Karane',
    [
      '[Sonríe a Karane] ¿Ves? El plan funcionó. Puedes felicitarnos sin empezar con “no es que me importe”. ♡',
      '[Se ríe suavemente] Karane está sonriendo aunque lo niegue. Yo sí admito que me alegra tu respuesta correcta.',
    ],
  ),
  TutorPose(
    'hakari',
    'felicitandote4.png',
    ExerciseReaction.correct,
    'Abraza su pequeño recuerdo y celebra',
    [
      '[Sonríe a su pequeño recuerdo de Rentarou] Él se alegraría de ver tu esfuerzo. Yo también: ¡respuesta comprobada!',
      '[Junta las manos feliz] Otro plan resuelto con atención. Tu método merece el cumplido, no solo el número final.',
    ],
  ),
  TutorPose(
    'hakari',
    'felicitandote7.png',
    ExerciseReaction.correct,
    'Levanta un dedo, satisfecha',
    [
      '[Levanta un dedo] ¡Objetivo conseguido! Ahora guarda la regla en tu memoria; nos servirá para el siguiente plan.',
      '[Sonríe satisfecha] Rentarou celebra a todos; hoy te toca recibir el mérito de esta cuenta. ♡',
    ],
  ),
  TutorPose(
    'hakari',
    'felicitandote por resolver 4 en racha.png',
    ExerciseReaction.streak,
    'Ríe mientras cuenta los aciertos',
    [
      '[Ríe feliz] ¡Cuatro o más seguidos! Karane ya los lleva contados. Mi plan de celebrar está dando resultados.',
      '[Se lleva una mano a la cabeza] La racha crece y yo no puedo ocultar la sonrisa. Sigue comprobando, como haría Rentarou.',
    ],
    minStreak: 4,
  ),
  TutorPose(
    'hakari',
    'sonrojada de sigas invicto de 20 de racha o 4 de racha.png',
    ExerciseReaction.streak,
    'Se sonroja y casi pierde su plan',
    [
      '[Se sonroja muchísimo] ¡Veinte seguidos! Ahora la que se quedó sin palabras fui yo. Karane, deja de reírte de mi cara.',
      '[Se abanica con las manos] Mi plan no contemplaba una racha tan enorme… Rentarou estaría encantado. Respira y conserva el método.',
    ],
    minStreak: 20,
  ),
  TutorPose(
    'karane',
    'dandote la pista.png',
    ExerciseReaction.hint,
    'Cruza los brazos y señala la ayuda',
    [
      '[Cruza los brazos] ¡Aquí está la pista! Hakari, no la llames un plan secreto: es una regla que quiero que entienda.',
      '[Te mira con firmeza] Rentarou ayudaría sin hacer tanto ruido. Yo hago ruido y ayudo igual. Mira este paso.',
    ],
  ),
  TutorPose(
    'karane',
    'orgullosa por ayudarte con la pista.png',
    ExerciseReaction.hint,
    'Aparta la mirada, orgullosa de poder ayudarte',
    [
      '[Aparta la mirada, sonrojada] Me salió bastante bien la explicación… ¡No es que espere un cumplido! Usa la pista y comprueba.',
      '[Cruza los brazos] Hakari presume de estrategias. Pues esta pista la preparé yo, y sí quiero que te sirva.',
    ],
  ),
  TutorPose(
    'karane',
    'gritandote por no hacer bien el ejercisio.png',
    ExerciseReaction.wrong,
    'Protesta y señala el paso que falta',
    [
      '[Levanta la voz] ¡Ese paso no!… Está bien, bajo el volumen. Mira la explicación: todavía podemos corregirlo.',
      '[Frunce el ceño] Hakari lo diría más suave, pero te lo explico igual: revisa los datos antes de tocar otra respuesta.',
    ],
  ),
  TutorPose(
    'karane',
    'preocupada por fallar varias veces.png',
    ExerciseReaction.repeatedError,
    'Te mira con preocupación y se queda a ayudar',
    [
      '[Suaviza la voz] ¿Qué parte se está enredando? Rentarou tendría paciencia… yo también. Vamos con un paso pequeño.',
      '[Se acerca disimuladamente] No voy a dejar la explicación a medias. Si la pista no bastó, revisamos la solución paso a paso.',
    ],
  ),
  TutorPose(
    'karane',
    'te va a votar de su clase si sigues fallando aun con la pista.png',
    ExerciseReaction.repeatedError,
    'Respira hondo, frustrada con el problema',
    [
      '[Respira hondo] ¡Cambio de plan! Nadie se va de la clase por fallar. El que sale de aquí es este maldito error, cuando lo entendamos.',
      '[Se remanga] Hakari, trae otro método. No vamos a repetir lo mismo esperando magia. Primero explica una operación.',
    ],
  ),
  TutorPose(
    'karane',
    'sorprendida de que hayas resuelto en tiempo record.png',
    ExerciseReaction.correct,
    'Abre mucho los ojos, impresionada',
    [
      '[Abre mucho los ojos] ¡Eso fue rápido y correcto! Hakari, no hagas bromas con mi cara. La comprobación también salió bien.',
      '[Se sonroja] Rentarou se sorprendería. Yo ya me sorprendí… Pero la próxima puedes hacerla con calma; esto no es una carrera.',
    ],
    quick: true,
  ),
];

TutorPose? choosePose(
  String id,
  ExerciseReaction reaction,
  int variant, {
  required int exerciseIndex,
  required int mistakes,
  required int streak,
  bool quick = false,
}) {
  final eligible = newTutorPoses
      .where(
        (p) =>
            p.tutor == id &&
            p.reaction == reaction &&
            mistakes >= p.minMistakes &&
            streak >= p.minStreak &&
            (!p.recovered || mistakes > 0) &&
            (!p.quick || quick) &&
            (p.exercises.isEmpty || p.exercises.contains(exerciseIndex)),
      )
      .toList();
  final special =
      eligible
          .where(
            (p) =>
                p.minMistakes > 0 ||
                p.minStreak > 0 ||
                p.recovered ||
                p.quick ||
                p.exercises.isNotEmpty,
          )
          .toList()
        ..sort(
          (a, b) => (b.minMistakes + b.minStreak).compareTo(
            a.minMistakes + a.minStreak,
          ),
        );
  if (special.isNotEmpty) return special.first;
  // Alternate established poses and new ones, without deriving order from filenames.
  return eligible.isNotEmpty && variant.isOdd
      ? eligible[(variant ~/ 2) % eligible.length]
      : null;
}

const hahari = TutorProfile(
  id: 'hahari',
  name: 'Hahari Hanazono',
  origin: 'Las 100 novias',
  traits: 'Invitada · cariñosa · teatral',
  introduction: 'La mamá de Hakari se asoma en el reto diez.',
  portrait: 'assets/tutors/hakari/hahari hanazono felicitandote cuando hagas 10 problemas sin fallar.png',
  lines: {
    TutorMoment.welcome: '[Sonríe] ¡Una visita especial al ejercicio diez! Hakari, solo vine a ayudar. Rentarou estaría encantado de vernos estudiar.',
    TutorMoment.practice: '[Se asoma a la pantalla] Soy Hahari, la mamá de Hakari. Este reto tiene visita sorpresa: primero leemos los datos, cariño.',
    TutorMoment.lesson: '[Se inclina con una idea] Rentarou presta atención a cada persona. Yo prestaré atención a tu duda; aquí tienes una pista.',
    TutorMoment.retry: '[Se pone pensativa] Este plan necesita una corrección. Hakari, no te preocupes: revisaremos el paso con calma.',
    TutorMoment.correct: '[Aplaude] ¡Bien resuelto! Qué bonito ver que el método funciona. Karane, también puedes sonreír.',
    TutorMoment.journey: '[Sonríe] Mi visita es corta; tu tutora sigue acompañándote en el recorrido.',
    TutorMoment.complete: '[Te saluda] Gracias por recibirme en este reto. Hakari seguirá estudiando contigo. ♡',
  },
);
const hahariWin =
    'assets/tutors/hakari/hahari hanazono felicitandote cuando hagas 10 problemas sin fallar.png';
const hahariWrong =
    'assets/tutors/hakari/hahari cuando fallaste su problema (exclusivo).png';
const hahariEleven =
    'assets/tutors/hakari/hahari aburrida de que su hija no quiera que este con el usuario (exclusivo solo si haces 11 problemas invictos).png';

bool hahariAppears(
  int index,
  bool correct,
  int streak, {
  required String tutorId,
}) =>
    tutorId == 'hakari' &&
    (index == 9 || (index == 10 && correct && streak >= 11));
String hahariImage(int index, bool correct, int streak) => index == 10
    ? hahariEleven
    : correct && streak >= 10
    ? hahariWin
    : hahariWrong;
String hahariDialogue(
  ExerciseReaction reaction,
  int variant,
  int index,
  int streak,
) {
  if (index == 10) {
    return '[Se cruza de brazos, divertida] ¡Once o más sin fallar! Hakari dice que mi visita ya terminó… Está bien, hija, devuelvo el turno a su tutora. Rentarou celebraría esta racha. ♡';
  }
  if (reaction == ExerciseReaction.streak && streak >= 10) {
    return '[Aplaude emocionada] ¡Diez o más respuestas seguidas sin fallar! Vine al reto diez y encontré un motivo perfecto para celebrar. Hakari, mira qué bien va nuestro estudiante. ♡';
  }
  if (variant.isOdd) {
    final lines = guestLines[reaction]!;
    return lines[(variant ~/ 2) % lines.length];
  }
  return hahari.say(switch (reaction) {
    ExerciseReaction.hint => TutorMoment.lesson,
    ExerciseReaction.wrong ||
    ExerciseReaction.repeatedError => TutorMoment.retry,
    ExerciseReaction.correct || ExerciseReaction.streak => TutorMoment.correct,
    _ => variant.isEven ? TutorMoment.welcome : TutorMoment.practice,
  });
}

const guestLines = {
  ExerciseReaction.observing: [
    '[Se asoma con curiosidad] ¡Sorpresa del reto diez! Soy la mamá de Hakari. Rentarou siempre anima a todos; yo también vine a ver tu siguiente idea.',
    '[Sonríe] Hakari dijo que solo podía visitar una pregunta. Bueno, aquí estoy: primero identifica qué te piden y después buscamos la regla. ♡',
  ],
  ExerciseReaction.hint: [
    '[Se inclina para ayudar] Mi hija tiene sus planes y yo tengo esta pista. Karane, no protestes: estamos estudiando juntos.',
    '[Señala el texto] Una ayuda de invitada: lee la regla antes de elegir. Rentarou no saltaría un detalle; nosotros tampoco.',
  ],
  ExerciseReaction.wrong: [
    '[Se pone pensativa] Este resultado necesita una revisión. Hakari, tranquila: una opción incorrecta no termina la visita. Vamos con la explicación.',
    '[Habla con calma] El reto diez nos pidió otra estrategia. Busquemos el paso concreto, como haríamos en una tarde de estudio con Rentarou.',
  ],
  ExerciseReaction.repeatedError: [
    '[Ordena unas notas] Ya probamos varios caminos. Mi plan maternal es sencillo: pausa, pista y una operación. Luego vemos el resto.',
    '[Mira a Hakari] Hija, acerquemos otra explicación. Aprender no consiste en adivinar más veces; revisemos el primer paso juntos.',
  ],
  ExerciseReaction.correct: [
    '[Aplaude con cariño] ¡Qué bien! El ejercicio de mi visita quedó resuelto. Rentarou estaría feliz de ver cómo comprobaste tu idea.',
    '[Sonríe satisfecha] Hakari, nuestro estudiante encontró el método. Ahora tu tutora puede continuar; yo me quedo con esta buena noticia. ♡',
  ],
  ExerciseReaction.streak: [
    '[Junta las manos] Otro acierto para tu racha. Mira, Hakari: siguió el procedimiento y comprobó el resultado. Eso merece celebrarse.',
    '[Sonríe orgullosa] Rentarou felicitaría cada avance. Yo también: conserva la atención para la siguiente pregunta, aunque ya tengas una racha bonita.',
  ],
  ExerciseReaction.idle: [
    '[Se estira mientras espera] Mi visita puede incluir una pausa. Hakari dice que ya hablé demasiado… está bien, pensamos con calma.',
    '[Mira fuera de la pantalla] No desaparece el reto por descansar. Cuando vuelvas, esta invitada puede ofrecerte una pista. ♡',
  ],
};
