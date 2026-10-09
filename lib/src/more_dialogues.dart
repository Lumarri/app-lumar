part of 'reactions.dart';

// Additional original dialogue. Existing variants retain their order and tone.
const extendedReactionVariants = <String, Map<ExerciseReaction, List<String>>>{
  'kurisu': {
    ExerciseReaction.observing: [
      '[Ajusta su bata] En el laboratorio de Okabe discutiríamos la hipótesis antes de tocar nada. Aquí los botones están abajo, pero tu razonamiento va primero.',
      '[Te mira de reojo] Si intentas invocar a la Organización para resolver esto, te detengo. Identifica los datos… sí, puedo revisarlos contigo.',
      '[Levanta una ceja] Daru tiene sus programas; tú tienes lápiz, papel y una incógnita. Herramientas suficientes. Ahora enséñame una idea comprobable.',
      '[Se cruza de brazos] No soy una decoración del menú. Soy Kurisu, y quiero saber por qué elegirías esa respuesta. La cara de concentración te queda bien… digo, ¡concéntrate!',
    ],
    ExerciseReaction.hint: [
      '[Se inclina hacia el enunciado] Ayuda del laboratorio: separa lo que conoces de lo que buscas. Hasta Okabe necesita ordenar sus notas entre discursos dramáticos.',
      '[Aparta la mirada] Preparé esta pista antes de que la pidieras. No significa nada raro; un buen experimento necesita un método reproducible.',
      '[Golpea suavemente la mesa] Una pista no es un salto temporal. No te saltes el paso: léelo, aplícalo y dime qué cambió en tu cálculo.',
      '[Sonríe apenas] Toma esta ayuda. Si Okabe pregunta, di que seguimos el protocolo científico. Nada de decir que estaba preocupada por ti… aunque sí quería que avanzaras.',
    ],
    ExerciseReaction.wrong: [
      '[Se queda mirando el resultado] Okabe podría culpar a otra línea de mundo. Nosotros vamos a culpar al paso concreto que no coincide. Revisa la explicación.',
      '[Frunce el ceño] Tu resultado acaba de contradecir los datos. Eso es información útil, maldición. Corrige la hipótesis en lugar de defenderla por orgullo.',
      '[Se arremanga] Daru revisaría su código. Tú revisa tu operación: una cosa por vez. No necesito que aciertes siempre; necesito que entiendas la corrección.',
      '[Baja el tono] Ese intento no funcionó. Estoy aquí para revisar contigo, no para verte rendirte. Y si me llamas Christina mientras calculamos… ¡Kurisu!',
    ],
    ExerciseReaction.repeatedError: [
      '[Deja a un lado sus notas] Ya tenemos suficientes resultados fallidos. Vamos a diseñar otro procedimiento: pista, primer paso y comprobación. El laboratorio empieza de nuevo.',
      '[Te mira con firmeza] Okabe repite sus teorías con convicción. Tú no repitas un cálculo sin revisarlo. Encontrar el error es parte del descubrimiento.',
      '[Suspira y señala la ayuda] Probamos varios caminos y ninguno pasó la comprobación. Bien: ahora sabemos cuáles descartar. Sigue la pista conmigo.',
      '[Se sienta a tu lado] Olvida por un momento la respuesta final. Si puedes explicarme el primer paso, ya tendremos un avance. Sí, esperaré; no tengo otra reunión con Okabe ahora.',
    ],
    ExerciseReaction.correct: [
      '[Oculta una sonrisa] Tu hipótesis pasó la prueba. Hasta el laboratorio aprobaría ese razonamiento… Yo también. Puedes quedarte con el cumplido.',
      '[Asiente satisfecha] Datos, método y resultado: los tres encajan. Okabe pondría un nombre larguísimo a esta victoria. Yo prefiero decir: lo hiciste bien.',
      '[Se sonroja ligeramente] Correcto. Y bastante elegante. No estoy exagerando para animarte; puedo demostrar que tu respuesta cumple el enunciado.',
      '[Te ofrece una sonrisa breve] Daru podría registrar otro éxito del laboratorio. Lo importante es que lo resolviste tú. Está bien sentirse orgulloso de eso.',
    ],
    ExerciseReaction.streak: [
      '[Abre mucho los ojos] ¡{racha} aciertos! Tu método está resistiendo varias pruebas. Esto merece algo mejor que un discurso de Okabe: excelente trabajo.',
      '[Se tapa una pequeña sonrisa] Racha de {racha}. Si sigues comprobando así, tendré que admitir que me gusta estudiar contigo… ¡Me gusta tu método!',
      '[Levanta el pulgar] {racha} resultados correctos seguidos. Evidencia consistente. Hasta Daru guardaría una copia de estas buenas noticias.',
      '[Se sonroja y cruza los brazos] ¡{racha}! Claro que llevo la cuenta. Soy científica, observo datos… y sí, también celebro tus avances.',
    ],
    ExerciseReaction.idle: [
      '[Mira fuera de la pantalla] Okabe ya habría dado dos discursos mientras espero. ¿Una pausa? De acuerdo. El problema seguirá aquí cuando vuelvas.',
      '[Revisa sus notas] Si tu cerebro necesita procesar la hipótesis, tómate el tiempo. Yo no puedo hacer un salto temporal para apresurarlo.',
      '[Se estira discretamente] Hasta una investigadora de PNG necesita descansar de la misma pose. Avísame con una respuesta o pide la pista.',
      '[Tamborilea con los dedos] Podría llamar a Daru para hablar de esto… pero prefiero escuchar tu idea cuando estés listo. Sí, seguiré esperando.',
    ],
  },
  'yuno': {
    ExerciseReaction.observing: [
      '[Sujeta el diario contra el pecho] Esta página todavía no tiene respuesta. Qué emoción… Tú vas a escribirla con tus cálculos, igual que Yukki decide su siguiente paso.',
      '[Se asoma hacia ti] Te veo mirar el enunciado. Mi diario no puede reemplazar tu razonamiento; cuéntame qué dato usarías primero. ♡',
      '[Sonríe muy atenta] A Yukki le preguntaría qué está pensando. A ti también: ¿buscamos una cantidad, un lado o una relación? Primero entiende la pregunta.',
      '[Abre una página limpia] Hoy mi Diario del Futuro tiene espacio para tus descubrimientos. No necesitas adivinar la respuesta; puedes construirla.',
    ],
    ExerciseReaction.hint: [
      '[Desliza una nota] Guardé esta pequeña ayuda para ti. Yukki sabe que un detalle cambia el siguiente paso; lee qué detalle señala la pista.',
      '[Sonríe y señala el texto] Una página del diario para orientarte. No tiene el resultado escrito por arte de magia: tiene una idea para que tú llegues.',
      '[Se inclina con curiosidad] ¿Pediste ayuda? Aquí estoy. Anotemos primero la regla y después los datos, como si organizáramos nuestro diario de estudio.',
      '[Levanta un dedo] Pista importante: no intentes todo a la vez. Acompañaría a Yukki paso a paso; también puedo acompañarte a ti. ♡',
    ],
    ExerciseReaction.wrong: [
      '[Aprieta los labios y luego sonríe] Esa página salió distinta a lo previsto. Bueno… todavía podemos corregirla. La explicación nos dice dónde mirar.',
      '[Observa el cálculo con seriedad] No coincide. Quiero que entiendas por qué antes de volver a elegir. Hasta Yukki necesita revisar una decisión.',
      '[Pasa una página] Un resultado fallido no decide todo tu futuro. Este siguiente intento puede usar lo que acabamos de aprender.',
      '[Te mira con atención] Qué rabia cuando una cuenta se tuerce… Pero tú sigues aquí, y yo también. Revisemos el error concreto. ♡',
    ],
    ExerciseReaction.repeatedError: [
      '[Cierra el diario un instante] Dejemos de buscar una predicción perfecta. Leamos la pista y construyamos una explicación pequeña, desde el principio.',
      '[Se pone pensativa] Yukki probaría otra estrategia. Nosotros también podemos: escribe el dato conocido y dime qué operación lo conecta con la pregunta.',
      '[Habla despacito] Varios intentos, varias pistas sobre lo que falta entender. No borremos todo: revisemos solo un paso con calma.',
      '[Vuelve a abrir el diario] Nueva página, nuevo plan. El primer paso cuenta aunque todavía no tengamos el resultado. Yo lo revisaré contigo.',
    ],
    ExerciseReaction.correct: [
      '[Dibuja un corazón en el aire] ¡Correcto! Si esto fuera mi diario, guardaría también tu explicación. El resultado tiene una historia: cómo llegaste a él.',
      '[Sonríe emocionada] ¡Lo conseguiste! Yukki estaría feliz de ver un plan que funciona. Yo estoy feliz de ver tu esfuerzo convertido en comprensión.',
      '[Asiente varias veces] Sí, sí, ¡esa es! Esta página del futuro la escribiste tú. Yo solo me quedo para celebrar contigo. ♡',
      '[Junta las manos] Resultado confirmado. Me gusta esta parte: cuando algo que parecía confuso por fin encaja. Guardemos el método también.',
    ],
    ExerciseReaction.streak: [
      '[Abre el diario con entusiasmo] ¡{racha} aciertos! Cada página tiene una buena noticia. Yukki, mira cómo está avanzando nuestro estudiante.',
      '[Sonríe radiante] Racha de {racha}. No fueron predicciones; fueron respuestas que comprobaste. Eso hace que me gusten todavía más.',
      '[Cuenta con los dedos] ¡{racha} seguidos! Ya no me caben todos en una mano… o pronto no cabrán. El diario sí tiene espacio para celebrarlos.',
      '[Abraza su diario] {racha} pequeñas victorias consecutivas. Me encanta ver esta colección crecer, pero sigamos con atención en la siguiente pregunta. ♡',
    ],
    ExerciseReaction.idle: [
      '[Mira la página en blanco] Todavía no sé qué respuesta escribirás. Puedes pensarlo; las buenas ideas también necesitan una pausa.',
      '[Se estira y vuelve a sonreír] Estoy aquí dentro de tu pantalla, esperando como una nota del diario. Tócame la pista si necesitas una idea.',
      '[Inclina la cabeza] ¿Fuiste por un lápiz? Yukki también se prepara antes de continuar. Mientras tanto guardaré el lugar de esta página.',
      '[Cierra suavemente el diario] Descansar no borra tus aciertos. Cuando vuelvas, abrimos la misma página y seguimos desde aquí. ♡',
    ],
  },
  'kotoko': {
    ExerciseReaction.observing: [
      '[Se acerca sonriendo] ¡Vamos, otaku del cálculo! Takuya tiene sus temas favoritos; yo quiero descubrir cuál de estos ejercicios te empieza a gustar.',
      '[Saluda a través de la pantalla] Kei, Takuya y tú formarían un buen grupo de estudio. Nada de quedarse callado por vergüenza: las dudas se preguntan.',
      '[Se remanga] Entre mis hermanos y las tareas aprendí algo: un problema enorme se vuelve más amable si lo partes. ¿Qué dato miramos primero?',
      '[Guiña un ojo] Hoy el episodio no es de Kiramon: es de tu próxima idea. Yo pongo el ánimo y tú pones un intento pensado. ¡Buen equipo!',
    ],
    ExerciseReaction.hint: [
      '[Señala la ayuda con entusiasmo] ¡Pista de compañera de clase! Igual que con Takuya, primero te escucho y luego buscamos qué regla falta.',
      '[Sonríe cerquita] No hace falta fingir que ya lo sabes, Kei… ni tú. Preguntar es parte de estudiar. Vamos a leer esta pista juntos.',
      '[Levanta un dedo] Primer movimiento del equipo: usa la pista para elegir la fórmula. Segundo: coloca los datos. ¡Ahora sí tenemos plan!',
      '[Ríe suavemente] Si te explicara Kiramon tan rápido como Takuya, nos perderíamos. Aquí voy despacio: una idea y una operación cada vez.',
    ],
    ExerciseReaction.wrong: [
      '[Hace una mueca simpática] ¡Ah, casi! Ese botón no era, pero la explicación sí nos puede acercar. Ven, vemos qué se mezcló.',
      '[Niega con la cabeza y sonríe] Nada de esconderte como si fueras el único que falla. Yo también reviso cuentas; hasta un buen grupo de estudio se equivoca.',
      '[Señala el cálculo] Takuya contaría la escena completa de su anime; tú cuenta los pasos completos de tu operación. Quizá ahí aparezca lo que falta.',
      '[Pone las manos en la cintura] Esa cuenta nos engañó un poquito. ¡La pillamos en el siguiente intento! Primero lee por qué esta opción no encaja.',
    ],
    ExerciseReaction.repeatedError: [
      '[Se remanga otra vez] Está bien, cambiamos de ritmo. Ayudando a mis hermanos aprendí a no explicar lo mismo cada vez más rápido. Vamos desde cero.',
      '[Hace una pausa contigo] Este episodio tiene un enemigo terco: la confusión. No se vence apretando botones al azar. ¡Pista y primer paso!',
      '[Sonríe con paciencia] Kei y Takuya también necesitarían otra explicación a veces. Dime qué parte te enreda; aquí podemos revisar la ayuda sin perder vidas.',
      '[Acerca una libreta imaginaria] Escribe solo lo que sabes. Luego lo que te piden. Entre esas dos líneas buscamos juntos la conexión.',
    ],
    ExerciseReaction.correct: [
      '[Levanta el pulgar] ¡Eso estuvo genial! Hasta Takuya dejaría de hablar de Kiramon un momento para celebrar. Bueno… quizá un momento cortito.',
      '[Da un pequeño salto] ¡Sííí! Nuestra tarde de estudio acaba de ganar otra buena escena. Lo entendiste, y eso cuenta más que pulsar por suerte.',
      '[Sonríe ampliamente] ¡Acierto! Ya puedes explicarlo como si ayudaras a un amigo. Kei, escucha: hoy tenemos un experto en ese paso.',
      '[Ofrece un choque de manos] ¡Buen trabajo, equipo! Yo te animaba, pero la cuenta la hiciste tú. Ese mérito no me lo voy a quedar.',
    ],
    ExerciseReaction.streak: [
      '[Cuenta con entusiasmo] ¡{racha} seguidos! Esto merece un aplauso de todo el club. Takuya, deja Kiramon un segundo y mira la racha.',
      '[Sonríe orgullosa] Racha de {racha}. Vas agarrando confianza, ¿eh? Quédate también con el hábito de comprobar; ese sí es un buen compañero.',
      '[Levanta ambos brazos] ¡{racha}! Parece final de episodio con música alegre. La próxima pregunta se resuelve con el mismo cuidado, equipo.',
      '[Ríe y guiña un ojo] {racha} respuestas correctas. Kei diría que no está emocionada, pero yo sí: ¡qué bonito verte avanzar!',
    ],
    ExerciseReaction.idle: [
      '[Se asoma por un lado] ¡Hola, estudiante al otro lado del cristal! Si estás pensando, sigo contigo. Si estás descansando, también está bien.',
      '[Mira alrededor] Takuya ya estaría buscando otro episodio de Kiramon. Yo estoy buscando tu próxima idea. ¿Quieres una pista para arrancar?',
      '[Estira los brazos] Ni mis hermanos me dejan tanto rato quieta. ¡Esta pose de PNG cuenta como ejercicio de paciencia! Tú calcula sin apuro.',
      '[Sonríe con calma] Podemos pausar la tarde de estudio. El club no desaparece; tus avances siguen guardados cuando regreses.',
    ],
  },
  'hakari': {
    ExerciseReaction.observing: [
      '[Sonríe como si guardara un secreto] Tengo un plan: entender la pregunta antes de elegir. Rentarou confiaría en nuestro equipo; Karane diría que era obvio. ♡',
      '[Ordena sus notas] Un buen plan necesita datos, no solo entusiasmo. Observa el enunciado conmigo y decidimos cuál será el primer movimiento.',
      '[Mira hacia Karane con picardía] Ella dice que no está pendiente de tu respuesta. Yo sí lo estoy: quiero ver qué estrategia eliges, paso a paso.',
      '[Junta las manos] Rentarou se esfuerza por cada persona. Yo me esfuerzo por que cada explicación tenga sentido para ti. Empecemos leyendo qué buscan.',
    ],
    ExerciseReaction.hint: [
      '[Despliega un pequeño plan] Paso uno, leer la pista; paso dos, probarla. Paso tres… celebrar si funciona. No te saltes el segundo por llegar al tercero. ♡',
      '[Sonríe a Karane] Ves, pedir ayuda es una estrategia inteligente. No hace falta decir que la preparaste por casualidad. Aquí tienes nuestra siguiente idea.',
      '[Te señala el dato clave] Rentarou no dejaría fuera ningún detalle. Nosotros tampoco: revisa esta pista y comprueba qué dato necesitas.',
      '[Guiña un ojo] Ayuda especial de Hakari. Parece una cosita pequeña, pero un plan bien elegido puede ordenar todo el problema.',
    ],
    ExerciseReaction.wrong: [
      '[Se queda pensativa] Mmm… nuestro plan se adelantó al cálculo. Antes de improvisar otro, revisemos la explicación de esta opción.',
      '[Suspira y luego sonríe] No salió como esperaba. Incluso una estratega tiene que corregirse; prefiero un plan revisado a una respuesta defendida por orgullo.',
      '[Mira a Karane de reojo] Sí, sí, ya sé que hay que comprobar. Karane tiene razón en eso. Vamos a mirar el paso donde se nos escapó un detalle.',
      '[Se pone seria un momento] El resultado no cumple la condición. Rentarou se esforzaría por entender la causa; nosotros haremos lo mismo.',
    ],
    ExerciseReaction.repeatedError: [
      '[Guarda su primer plan] Hora de cambiar la estrategia, no de culparte. Una pista y una operación pequeña nos darán un comienzo más claro.',
      '[Sonríe con paciencia] Karane protesta, pero ya está lista para ayudarte. Yo también. Volvamos a los datos antes de elegir otra opción.',
      '[Reordena sus notas] Mis planes a veces se enredan demasiado. Hagámoslo sencillo: qué sabemos, qué buscamos y qué regla los conecta.',
      '[Te mira con atención] Ninguna cantidad de entusiasmo sustituye una explicación. Vamos desde el primer paso; el equipo de Rentarou no abandonaría una duda a medias.',
    ],
    ExerciseReaction.correct: [
      '[Aplaude suavemente] ¡Todo encajó! Me gusta cuando el plan incluye una buena comprobación. Karane, ahora sí puedes presumir de nuestro equipo.',
      '[Sonríe con picardía] Respuesta correcta. Mi plan incluía animarte, pero tu razonamiento hizo el trabajo importante. Rentarou estaría orgulloso. ♡',
      '[Junta las manos feliz] Qué bonito resultado… y qué buena explicación detrás. Guardemos ese método para cuando aparezca un problema parecido.',
      '[Guiña un ojo a Karane] ¿Ves? No era suerte. Miró los datos, aplicó la regla y comprobó. Esta victoria tiene una estrategia que podemos repetir.',
    ],
    ExerciseReaction.streak: [
      '[Hace cuentas con una sonrisa] ¡{racha} aciertos! Mi plan de celebración va creciendo. Rentarou querría felicitarte por cada uno, seguro.',
      '[Mira a Karane divertida] Racha de {racha}. Ella también la lleva contada, aunque niegue todo. ¡Bien hecho! El siguiente paso sigue mereciendo atención.',
      '[Aplaude emocionada] {racha} seguidos: el equipo está encontrando su ritmo. No necesitas acelerar; esta estrategia funciona porque piensas.',
      '[Sonríe satisfecha] ¡{racha}! Ya tenemos evidencia de que el plan ayuda. Conserva la comprobación final; es nuestra pequeña ventaja. ♡',
    ],
    ExerciseReaction.idle: [
      '[Apoya la mejilla en una mano] Estoy diseñando otro plan mientras espero. Karane dirá que es demasiado elaborado… quizá esta vez tenga razón.',
      '[Mira fuera del globo de diálogo] Vivir en una interfaz tiene sus pausas. Puedes descansar; yo reservaré el siguiente movimiento para cuando vuelvas.',
      '[Sonríe a Karane] No, no estoy calculando cuánto tardará. Estoy pensando cómo explicar mejor. Pide una pista si quieres probar nuestro plan.',
      '[Ordena sus notas otra vez] Rentarou también cuidaría los descansos de todos. Tómate el tuyo; el problema no necesita resolverse a toda velocidad. ♡',
    ],
  },
  'karane': {
    ExerciseReaction.observing: [
      '[Cruza los brazos] ¡A ver, primero lee! Hakari puede inventar cien planes, pero ninguno sirve si no sabes qué te preguntan. Y sí, voy a revisar contigo.',
      '[Se sonroja y mira al enunciado] Rentarou siempre presta atención. Tú también puedes… ¡al problema, no a mi cara! Muéstrame por dónde empezarías.',
      '[Se acerca disimuladamente] No estoy encima de la interfaz porque quiera vigilarte. Estoy aquí para ayudar. ¡Es distinto! Bueno, intenta un paso.',
      '[Aparta la mirada] Hakari dice que animo a gritos. Pues hoy lo diré claro: puedes aprenderlo. Ahora concéntrate y dime qué datos ves.',
    ],
    ExerciseReaction.hint: [
      '[Extiende una nota y mira a otro lado] Preparé otra pista. ¡No me mires así! Rentarou se esforzaría por ayudar y yo también puedo hacerlo.',
      '[Señala con firmeza] Usa esta ayuda para pensar, no para saltarte todo. Hakari, deja de sonreír: ¡dar una pista no es una declaración de nada!',
      '[Suspira, un poco roja] Está bien, vamos juntas con el primer paso… digo, juntos. Ya entendiste. Lee la regla y aplícala a los datos.',
      '[Se cruza de brazos otra vez] ¡Toma! Ahí tienes una explicación. Si el paso era confuso, se pregunta. No tienes que fingir que lo sabes todo.',
    ],
    ExerciseReaction.wrong: [
      '[Chasquea la lengua] ¡Rayos, esa no! Hakari no arreglará la cuenta con una sonrisa. La explicación sí puede ayudarnos: léela conmigo.',
      '[Frunce el ceño y luego suaviza la voz] Te equivocaste en este intento. Ya está, se corrige. No voy a dejar que una opción te quite las ganas.',
      '[Señala el enunciado] El resultado tiene que cumplir lo que piden. Rentarou revisaría el detalle; nosotros también. ¡Vamos, otra vez con atención!',
      '[Respira hondo] No era por ahí. Puedes cambiar de idea después de entender el error. ¡Eso es aprender, no perder! Hakari, deja que termine de explicarlo.',
    ],
    ExerciseReaction.repeatedError: [
      '[Deja de protestar un instante] Escucha: si no se entiende, cambiamos la explicación. No te voy a pedir lo mismo sin ayudarte. Abre la pista.',
      '[Se remanga] ¡Este maldito problema no va a ganar por cansancio! Lo partimos en pasos. Primero dime qué operación necesitas, y la comprobamos.',
      '[Se sonroja ligeramente] Rentarou tendría paciencia. Yo también la tengo… aunque haga ruido. Vamos despacio desde los datos, sin adivinar.',
      '[Mira a Hakari y asiente] Vale, esta vez su plan es bueno: una pista, un paso y una comprobación. ¡No digas que admití eso con tanta facilidad!',
    ],
    ExerciseReaction.correct: [
      '[Levanta el puño y se sonroja] ¡Sí!… Digo, respuesta correcta. Hakari, deja de mirarme como si acabara de gritar de alegría. ¡Fue un grito de comprobación!',
      '[Sonríe sin poder evitarlo] Lo resolviste. Rentarou te felicitaría, y yo… yo también. ¡No tienes que hacerme repetirlo para que cuente!',
      '[Aparta la mirada, contenta] Buen cálculo y buena comprobación. No es que dudara de ti; quería ver que lo entendías. Y lo entendiste.',
      '[Cruza los brazos, todavía sonriendo] Hakari tenía razón: ese plan funcionó. Pero tú hiciste las cuentas. ¡Acepta el mérito, que te lo ganaste!',
    ],
    ExerciseReaction.streak: [
      '[Cuenta con los dedos y se sonroja] ¡{racha} seguidos! No los cuento porque esté emocionada… Los cuento porque es una racha. ¡Y sí, estoy emocionada!',
      '[Mira a Hakari con orgullo] Racha de {racha}. Puedes dejar de insinuar cosas: estoy celebrando su esfuerzo. Rentarou haría lo mismo.',
      '[Levanta ambos puños] ¡{racha}! Así se hace. Ahora respira y lee la siguiente pregunta; presumir no reemplaza la comprobación.',
      '[Sonríe, luego se cruza de brazos] {racha} aciertos y un montón de esfuerzo. Te felicito. ¡No voy a esconder todos los cumplidos para siempre!',
    ],
    ExerciseReaction.idle: [
      '[Mira hacia otro lado] No te estoy esperando… Estoy haciendo compañía al botón de pista. ¡Qué! Está bien, sí te espero. Vuelve cuando estés listo.',
      '[Estira los brazos] Hakari ya tiene un plan hasta para esta pausa. Yo tengo uno más sencillo: descansa y luego piensa con calma.',
      '[Golpea el suelo suavemente] ¡Oye, sigo dentro de la pantalla! Puedes pedir ayuda cuando vuelvas. No tengo que fingir que me aburro para ofrecerla.',
      '[Se sonroja y baja la voz] Rentarou diría que descansar también importa. Yo digo lo mismo… pero no hagas bromas porque lo dije suave.',
    ],
  },
};
