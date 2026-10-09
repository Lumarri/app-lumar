import 'curriculum.dart';
import 'stage_dialogues.dart';
import 'reactions.dart';
import 'tutors.dart';

/// Two original variations for each tutor and action, contextualized by stage.
const advancedLines = <String, Map<ExerciseReaction, List<String>>>{
  'kurisu': {
    ExerciseReaction.observing: [
      '[Ajusta su bata] Okabe ya llamó a esto Operación Academia. Yo lo llamo {skill}: definiciones claras, datos y una prueba.',
      '[Mira tus apuntes] Daru pediría automatizarlo; primero explica tú {skill}. El laboratorio no acepta una intuición sin comprobar.',
    ],
    ExerciseReaction.hint: [
      '[Señala la regla] Mira: {hint} ¡No es que llevara esperando que me preguntaras! Aunque sí preparé el procedimiento.',
      '[Levanta un dedo] Una hipótesis por vez, como en el laboratorio: {hint} Ese es nuestro siguiente paso.',
    ],
    ExerciseReaction.wrong: [
      '[Frunce el ceño] Esa hipótesis no pasó la comprobación. En {stage} hay una trampa: {pitfall} Corrige el método; no hace falta cambiar de línea temporal.',
      '[Suspira y acerca sus notas] Okabe culparía a la Organización. Yo revisaría {skill} antes de acusar a nadie. Vuelve a los datos.',
    ],
    ExerciseReaction.repeatedError: [
      '[Se cruza de brazos] Detén el experimento un momento. {hint} Hagamos solo eso y comprobemos antes de seguir.',
      '[Respira hondo] Ningún investigador nace sabiendo {stage}. Abre los pasos; Daru y yo también revisamos cálculos cuando algo no cuadra.',
    ],
    ExerciseReaction.correct: [
      '[Sonríe de reojo] {skill}, comprobado. Eso sí merece una nota en el laboratorio. B-buen trabajo, investigador.',
      '[Asiente, satisfecha] Ahora puedes explicar por qué funciona, no solo marcar una opción. Okabe haría un discurso; yo te doy el siguiente reto.',
    ],
    ExerciseReaction.streak: [
      '[Se sonroja] Mantener el método en {stage} sí es progreso. ¡No pongas esa cara! Estoy celebrando la precisión del equipo.',
      '[Alza su cuaderno] Una racha de pruebas válidas. Daru puede archivar los resultados; tú guarda la regla que usaste.',
    ],
    ExerciseReaction.idle: [
      '[Apoya el mentón] Estoy aquí. Puedes comparar la gráfica o leer una fila por vez. Okabe tendría prisa; este experimento puede esperar.',
      '[Revisa sus notas] Si {stage} se siente enorme, elige un dato y escribe qué significa. Empezamos desde ahí.',
    ],
  },
  'karane': {
    ExerciseReaction.observing: [
      '[Se cruza de brazos] Hoy toca {skill}. Hakari ya dijo que tiene un plan. ¡Yo tengo los apuntes! No es que los hiciera especialmente… bueno, sí.',
      '[Se inclina hacia el problema] Rentarou se esforzaría hasta entender {stage}. Tú también puedes; empieza por decir qué te están preguntando.',
    ],
    ExerciseReaction.hint: [
      '[Señala con energía] ¡Aquí! {hint} No pases al siguiente cálculo sin terminar este. Sí, me quedo para ayudarte.',
      '[Se sonroja] Hakari, deja de decir que soy cariñosa. Le estoy dando una pista: {hint}',
    ],
    ExerciseReaction.wrong: [
      '[Frunce el ceño] ¡Ese paso se saltó una condición! {pitfall} Respira y revisa; no te voy a dejar atascado en {stage}.',
      '[Mira a Hakari de reojo] No hace falta un plan secreto: comprobemos {skill}. Rentarou tampoco resolvería esto solo por entusiasmo.',
    ],
    ExerciseReaction.repeatedError: [
      '[Baja la voz] Está bien pedir ayuda. Abre los pasos de {skill}. ¡No significa que seas incapaz! Significa que estamos aprendiendo.',
      '[Se acerca a los apuntes] Vamos más despacio: {hint} Hakari puede esperar para celebrar; primero quiero que lo entiendas.',
    ],
    ExerciseReaction.correct: [
      '[Sonríe y lo intenta esconder] ¡Eso! {skill} salió bien. Hakari, no te rías de mi sonrisa… ¡Me alegra su esfuerzo!',
      '[Levanta el puño] Rentarou también te felicitaría. Yo digo que tu razonamiento en {stage} estuvo bien. Sí, lo digo en serio.',
    ],
    ExerciseReaction.streak: [
      '[Se sonroja muchísimo] ¡Otra vez bien! En {stage}, además. No es que esté orgullosa… ¡Está bien, sí lo estoy!',
      '[Mira tu cuaderno] Mantén ese procedimiento. Hakari ya prepara el aplauso; yo reviso que la racha tenga explicación.',
    ],
    ExerciseReaction.idle: [
      '[Aparta la mirada] Puedes pensar. No voy a quitarte los apuntes por tardar en {stage}. ¡Y no estoy aburrida de ayudarte!',
      '[Golpea suavemente la mesa] Una fila, una regla, un paso. Eso basta para retomar {skill}. Aquí sigo.',
    ],
  },
  'hakari': {
    ExerciseReaction.observing: [
      '[Junta las manos] Mi estrategia para {stage}: entender {skill} antes de elegir. Rentarou confiaría en nuestro equipo. ♡',
      '[Sonríe con picardía] Karane cree que improviso, pero este plan tiene reglas. Primero identificamos {skill}; después comprobamos cada dato.',
    ],
    ExerciseReaction.hint: [
      '[Se acerca a tus notas] Un pequeño secreto del plan: {hint} Karane también lo estaba señalando, aunque fingía distraerse.',
      '[Levanta un dedo] Rentarou escucha a todos; escuchemos la condición del problema: {hint}',
    ],
    ExerciseReaction.wrong: [
      '[Se abanica, pensativa] El plan necesita un ajuste: {pitfall} Corregimos {skill} y volvemos a intentarlo juntos.',
      '[Mira a Karane] Tiene razón: faltó comprobar ese detalle. En {stage}, una respuesta bonita también debe cumplir las condiciones.',
    ],
    ExerciseReaction.repeatedError: [
      '[Baja la voz con cariño] Cambiemos la estrategia. {hint} No tenemos que resolver todo de golpe.',
      '[Ordena los apuntes] Rentarou no te dejaría estudiar solo cuando cuesta. Karane y yo tampoco: abre los pasos de {skill}.',
    ],
    ExerciseReaction.correct: [
      '[Aplaude feliz] ¡Plan comprobado! {skill} ya tiene sentido. Karane, ven a celebrar, que vi tu sonrisa. ♡',
      '[Sonríe orgullosa] Tu razonamiento en {stage} funciona. Rentarou lo celebraría; yo quiero oír cómo lo explicas.',
    ],
    ExerciseReaction.streak: [
      '[Se sonroja] Qué bonita racha de ideas claras en {stage}. Mi estrategia favorita sigue siendo estudiar contigo.',
      '[Mira a Karane con picardía] ¡Otro acierto! No lo digo por suerte: está usando bien {skill}. Podemos celebrarlo las dos.',
    ],
    ExerciseReaction.idle: [
      '[Apoya las manos en la mesa] Pausa de estrategia. Mira qué dato está definido y cuál falta; {stage} se vuelve más amable por partes.',
      '[Sonríe con calma] La siguiente idea puede tardar en llegar. Rentarou nos recordaría que descansar también ayuda a pensar.',
    ],
  },
  'kotoko': {
    ExerciseReaction.observing: [
      '[Levanta ambos brazos] ¡Episodio nuevo: {stage}! Hoy el protagonista es {skill}. Takuya, Kei: ¡apuntes listos!',
      '[Sonríe a la cámara imaginaria] En Kiramon habría una evolución dramática. Aquí evolucionamos explicando {skill}, paso a paso.',
    ],
    ExerciseReaction.hint: [
      '[Señala tus apuntes] ¡Pista del episodio! {hint} Después me cuentas qué cambió y por qué.',
      '[Mira a Kei] Trabajo en equipo: {hint} Takuya también revisaría la regla antes de elegir.',
    ],
    ExerciseReaction.wrong: [
      '[Hace una mueca y sonríe] ¡Giro del guion! {pitfall} Corregimos el episodio de {skill}; no hace falta borrar tus avances.',
      '[Inclina la cabeza] Esa opción no sigue la regla. Takuya puede contar la trama de Kiramon, pero tú puedes reconstruir este cálculo.',
    ],
    ExerciseReaction.repeatedError: [
      '[Deja la cámara imaginaria] Pausa: abre los pasos de {skill}. Kei y yo te acompañamos sin prisa.',
      '[Acerca un cuaderno] Un dato por vez: {hint} El capítulo se entiende mejor cuando no saltamos escenas.',
    ],
    ExerciseReaction.correct: [
      '[Levanta los brazos] ¡Esa es! {skill} resuelto. Takuya, guarda la escena: hoy explicó el procedimiento.',
      '[Sonríe emocionada] ¡Qué buena conexión en {stage}! Kei también aplaude. Ahora mira qué regla podrías reutilizar.',
    ],
    ExerciseReaction.streak: [
      '[Imita una cámara] ¡Racha grabada! El club está viendo cómo mejoras en {stage}. No olvides explicar el método.',
      '[Ríe] ¡Otro episodio conseguido! Si fuera Kiramon, aquí vendría la música. En nuestros apuntes viene una comprobación.',
    ],
    ExerciseReaction.idle: [
      '[Apoya el mentón] Los capítulos difíciles necesitan pausa. Puedes mirar la gráfica o escribir un ejemplo pequeño de {skill}.',
      '[Saluda a Kei] ¡Seguimos aquí! {stage} no se entiende con prisas. Dime primero qué parte reconoces.',
    ],
  },
  'yuno': {
    ExerciseReaction.observing: [
      '[Abre su diario] Página nueva: {stage}. Yukki escribiría una predicción; tú escribe qué significa {skill}. ♡',
      '[Sonríe con curiosidad] Mi Diario del Futuro no contiene esta respuesta. La construiremos leyendo las condiciones juntos.',
    ],
    ExerciseReaction.hint: [
      '[Se acerca con una nota] Guardé esta pista: {hint} Yukki empezaría con ese dato, y nosotros también.',
      '[Señala la página] Una predicción se comprueba: {hint} Después revisamos si la respuesta cumple el problema.',
    ],
    ExerciseReaction.wrong: [
      '[Ladea la cabeza] Esa predicción necesita corregirse. {pitfall} Todavía podemos cambiar la página de {skill}.',
      '[Cierra el diario un momento] Yukki también tendría que comprobarlo. Vuelve a {skill}; un error no borra lo aprendido.',
    ],
    ExerciseReaction.repeatedError: [
      '[Habla con calma] Abramos los pasos de {skill}. Una corrección por vez; no necesitas adivinar el futuro.',
      '[Te ofrece sus notas] {hint} Me quedo aquí mientras lo reconstruyes. La página puede esperar.',
    ],
    ExerciseReaction.correct: [
      '[Abraza su diario] ¡Una predicción comprobada! {skill} quedó claro. Yukki tendría que ver esta página. ♡',
      '[Sonríe emocionada] Tu respuesta en {stage} cumple las condiciones. Guardemos también la explicación, que vale mucho.',
    ],
    ExerciseReaction.streak: [
      '[Aplaude feliz] ¡Otra página con final correcto! Qué bonito ver tu método crecer en {stage}.',
      '[Muestra su diario] La racha no apareció por magia: estás comprobando {skill}. Yukki aprendería viendo estos pasos.',
    ],
    ExerciseReaction.idle: [
      '[Mira la página contigo] Puedes pensar despacio. Empezar por una condición de {stage} ya es avanzar.',
      '[Sonríe con calma] No hace falta llenar todo el diario ahora. Escribe un primer paso de {skill}, y seguimos desde ahí.',
    ],
  },
};

String advancedCourseDialogue(
  TutorProfile tutor,
  Lesson lesson,
  Exercise exercise,
  ExerciseReaction reaction,
  int variant,
) {
  final script = stageScripts[lesson.id];
  if (script == null) return '';
  final choices = advancedLines[tutor.id]?[reaction];
  if (choices == null) return '';
  final stage =
      '${lesson.title.toLowerCase()} de ${seasonForLesson(lesson).title.toLowerCase()}';
  final action = choices[variant % choices.length]
      .replaceAll('{stage}', stage)
      .replaceAll(
        '{skill}',
        exercise.skill.isEmpty
            ? lesson.title.toLowerCase()
            : exercise.skill.toLowerCase(),
      )
      .replaceAll('{hint}', exercise.hint)
      .replaceAll('{pitfall}', script.pitfall);
  final note = script.forTutor(tutor.id);
  final check =
      reaction == ExerciseReaction.correct ||
          reaction == ExerciseReaction.streak
      ? ' Para comprobar el método: ${script.check}'
      : '';
  return '$action $note$check';
}

String advancedStageGreeting(TutorProfile tutor, Lesson lesson) {
  final script = stageScripts[lesson.id];
  if (script == null) return '';
  final course =
      courseSignatures[seasonForLesson(lesson).number]?[tutor.id] ?? '';
  final goal = _advancedGoalGreeting(tutor, lesson);
  return '$course\n\n${script.forTutor(tutor.id)}${goal.isEmpty ? '' : '\n\n$goal'}';
}

String _advancedGoalGreeting(TutorProfile tutor, Lesson lesson) {
  if (lesson.guide == null) return '';
  final objective = lesson.guide!.objectives.first.toLowerCase();
  return switch (tutor.id) {
    'kurisu' =>
      '[Ajusta su bata] Nuestra primera prueba es $objective. Cinco niveles, de guiado a desafío; la dificultad sube, pero las definiciones siguen siendo nuestras aliadas.',
    'karane' =>
      '[Se cruza de brazos] Primero vamos a $objective. ¡No saltes al desafío solo para presumir! Preparé los veinte ejercicios para que construyas el método.',
    'hakari' =>
      '[Junta las manos] El primer objetivo del plan es $objective. Veinte retos y cinco niveles; si cuesta, cambiamos la estrategia, no el cariño del equipo. ♡',
    'kotoko' =>
      '[Levanta los brazos] ¡Primera misión: $objective! Son veinte escenas con dificultad creciente. Podemos consultar fórmulas sin perdernos el hilo.',
    _ =>
      '[Abre su diario] La primera página dice: $objective. Guardaremos cada avance entre estos veinte retos, del primer paso al desafío. ♡',
  };
}

String advancedGuestDialogue(
  Lesson lesson,
  Exercise exercise,
  ExerciseReaction reaction,
) {
  final script = stageScripts[lesson.id];
  if (script == null) return '';
  final skill = exercise.skill.isEmpty
      ? lesson.title.toLowerCase()
      : exercise.skill.toLowerCase();
  return switch (reaction) {
    ExerciseReaction.hint =>
      '[Señala los apuntes] Hakari y yo tenemos esta pista para $skill: ${exercise.hint}',
    ExerciseReaction.wrong =>
      '[Ladea la cabeza] El plan de $skill necesita una corrección: ${script.pitfall}',
    ExerciseReaction.repeatedError =>
      '[Acerca una silla] Rentarou también pediría ayuda si lo necesita. Vamos a reconstruir $skill leyendo los pasos.',
    ExerciseReaction.correct =>
      '[Aplaude] ¡$skill comprobado! Hakari, ven a mirar cómo justificó su respuesta.',
    ExerciseReaction.streak =>
      '[Sonríe emocionada] La racha llegó hasta ${lesson.title.toLowerCase()}. Hakari puede estar orgullosa de este razonamiento.',
    ExerciseReaction.idle =>
      '[Se acomoda, paciente] Podemos pensar un momento en $skill. La visita no tiene prisa.',
    ExerciseReaction.observing =>
      '[Junta las manos] Hoy visito ${lesson.title.toLowerCase()}. Veamos $skill; Hakari me reservó este reto. ♡',
  };
}

String personalizedFarewell(
  TutorProfile tutor,
  Lesson lesson,
  bool courseComplete,
) {
  final script = stageScripts[lesson.id];
  if (script == null) return '';
  final season = seasonForLesson(lesson);
  final topic = courseComplete
      ? season.title.toLowerCase()
      : lesson.title.toLowerCase();
  final signature = courseComplete
      ? (courseSignatures[season.number]?[tutor.id] ?? '')
      : script.forTutor(tutor.id);
  return 'Terminaste $topic. $signature\n\nPara tu próximo repaso: ${script.check}';
}
