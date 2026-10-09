# Tutoras de Lumar Academy

Las identidades de las imágenes fueron confirmadas por el usuario. Las descripciones se investigaron en fuentes oficiales; los diálogos de Lumar Academy son textos nuevos adaptados a la enseñanza de matemáticas. No son citas de los personajes ni reproducen todas las conductas de sus historias.

| Tutora | Base de la personalidad | Adaptación educativa |
| --- | --- | --- |
| Kurisu Makise | Inteligencia científica y carácter tsundere. | Analiza, propone hipótesis, pide comprobar resultados y elogia con un toque de timidez. |
| Yuno Gasai | Excelente rendimiento académico y dedicación intensa; su historia también incluye una fijación obsesiva. | Tutora atenta que registra logros en un diario de estudio. La app usa su dedicación como acompañamiento respetuoso, con libertad para cambiar de tutora. |
| Kotoko Ijichi | Alegre, sociable, buena estudiante y cuidadosa con sus hermanos. | Explica con cercanía, bromas suaves y apoyo paciente; anima a intentarlo otra vez. |
| Hakari Hanazono | Astuta, estratégica y considerada con los demás. | Ofrece pequeños planes para resolver problemas y celebra el razonamiento con dulzura. |
| Karane Inda | Tsundere, fuerte, confiable y con dificultad para expresar sus sentimientos. | Plantea retos, corrige con claridad y felicita de manera algo tímida, sin insultos ni castigos. |

## Fuentes

- **Kurisu:** [Kotobukiya, ficha oficial del personaje bajo licencia](https://www.kotobukiya.co.jp/en/product/detail/p4934054097746/) la presenta como una heroína genio y tsundere. [Sitio oficial de STEINS;GATE](https://steinsgate.jp/phenogram/story/makise.html) describe su participación científica en la máquina de salto temporal.
- **Yuno:** [Perfil oficial de Mirai Nikki](https://future-diary.tv/chara/2nd.html) describe su buen rendimiento y sus sentimientos obsesivos. La relación con el estudiante en Lumar Academy es una adaptación educativa, sin posesividad ni amenazas.
- **Kotoko:** [Personajes del sitio oficial de OtaGal](https://otagal.jp/character/) describe su alegría, habilidades sociales, buen rendimiento y cuidado de sus hermanos. [Presentación del editor COAMIX](https://www.coamix.co.jp/en/topics/otagyaru_251225) respalda esos rasgos.
- **Hakari:** [Perfil oficial de Las 100 novias](https://hyakkano.com/character/hakari/) respalda su astucia y consideración. Los diálogos de la app se centran en estrategias de estudio y no incluyen el contenido sexual del original.
- **Karane:** [Perfil oficial de Las 100 novias](https://hyakkano.com/character/karane/) describe su carácter tsundere, fuerte y confiable.

## Imágenes y expresiones

Se incorporan los 12 archivos aportados en `assets/tutors/`. Los JPG con varias expresiones se encuadran en Flutter para mostrar el rostro elegido. Los originales se conservan sin modificación. Los cuadriculados de los JPG forman parte de la imagen y no representan transparencia real.

Kurisu y Kotoko tienen variantes de retrato; Hakari y Karane utilizan distintas regiones de sus hojas de expresiones. Yuno reutiliza su retrato porque se aportó una sola imagen. Las pistas usan expresiones pensativas y los aciertos usan expresiones alegres. Las variantes disponibles también aparecen en el perfil.

Los corazones son decorativos y de ánimo: las respuestas incorrectas no restan vidas, puntos ni progreso.

## Interacciones durante los ejercicios

Las poses adicionales de las cinco carpetas se asignan de manera explícita en `lib/src/reactions.dart` según los nombres aportados. Las imágenes originales se conservan; nombres de archivo con bromas agresivas o sexuales no se convierten en mensajes para el estudiante.

Cada tutora tiene ocho variantes de diálogo en siete situaciones: observar el problema, dar una pista, corregir un error, acompañar después de varios errores, felicitar, celebrar una racha y esperar. Son 280 frases de situación, además de los diálogos generales y las presentaciones de etapa. Se conservaron las 140 anteriores y se añadieron 140 nuevas. Cambian según la etapa, el ejercicio y los intentos; incluyen gestos escritos, bromas tsundere más directas y guiños a vivir dentro de la pantalla. Las pistas también rotan entre ejercicios, además de al pedir ayuda otra vez.

Las nuevas referencias conectan a Kurisu con Okabe, Daru, el laboratorio y los D-mails; a Yuno con Yukiteru y el Diario del Futuro; a Kotoko con Takuya, Kei y Kiramon; y a Hakari y Karane con Rentarou y sus bromas entre compañeras. Son escenas educativas originales, no diálogos canónicos ni predicciones del rendimiento del estudiante. Se verificaron en los perfiles oficiales enlazados arriba y en la [colaboración oficial de STEINS;GATE y SCRAP](https://realdgame.jp/s/steinsgateonline/).

Kurisu celebra desde cinco aciertos seguidos y Yuno desde cuatro, respetando los nombres de sus imágenes especiales. Kotoko, Hakari y Karane celebran desde tres con poses de felicitación. Las frases muestran el número real de la racha. Después de más de tres errores en un mismo ejercicio cambia la reacción; a los 45 segundos sin interacción aparece una espera juguetona, sin penalizaciones ni presión de tiempo.

La tutora aparece entre el enunciado y las respuestas, con el botón de pista y su imagen en el propio globo. Las pistas y la explicación matemática se muestran junto al diálogo de personalidad. Al comprobar la respuesta, la pantalla vuelve a enfocar a la tutora para ver su reacción.

Los PNG transparentes nuevos sustituyen las poses anteriores en los ejercicios; sus rutas se actualizan explícitamente para respetar los nombres con guiones bajos. Las láminas exclusivas de Karane y Hakari aportan tres iconos circulares que cambian según la reacción. Se encuadran en Flutter sin editar la imagen original. Los personajes principales siguen superpuestos y sin marco.

Las 52 etapas tienen una presentación con objetivo, contexto y criterio de comprobación. Se añadieron logaritmos, potencias y ecuaciones de segundo grado, con 50 preguntas por curso. El saludo cambia según la personalidad y la etapa. Ajustes permite elegir tutora, regular música y volumen, reducir el movimiento de entrada y desactivar comentarios de espera; todo se guarda localmente.

## Poses adicionales y despedidas

`pose_catalog.dart` organiza 44 poses por su expresión, con dos frases originales para cada una. Los sufijos numéricos de archivos como `explicadonte5.png` o `felicitandote7.png` no determinan el orden ni una condición de aparición. Se conservaron las 280 frases generales y se añadieron comentarios asociados a las poses, veinte despedidas y diálogos de la invitada.

Las condiciones indicadas expresamente se evalúan con el estado de la práctica: Hakari cambia después de tres y siete errores; sus poses de racha se habilitan desde cuatro y veinte aciertos. Kurisu tiene una pose desde ocho aciertos y otra en los ejercicios 10/18 (la invitada tiene prioridad en el 10). Yuno celebra recuperaciones después de errores. Karane puede sorprenderse por una respuesta en menos de 30 segundos sin errores ni ayudas; no hay un cronómetro visible ni penalizaciones por tardar, y el tiempo se pausa al salir de la app.

Las despedidas de etapa y curso usan los PNG aportados para ese propósito; cuando no hay una imagen exclusiva de despedida, se usa una felicitación de la misma tutora. El curso se considera terminado cuando todos sus ejercicios están guardados como resueltos, aunque las etapas se hayan hecho en otro orden.

## Diálogos personalizados de cursos y etapas

Las ocho temporadas incorporan 70 plantillas situacionales en `advanced_dialogues.dart`: dos por tutora y por acción. Se combinan con 260 intervenciones escritas por personaje y etapa en `stage_dialogues.dart`, junto con errores frecuentes y maneras concretas de comprobar lo aprendido. Hay 40 textos propios de curso que se recuperan en introducciones y despedidas.

Por ejemplo, Kurisu comprueba `AA^(-1)=I` como un experimento de laboratorio, Yuno relaciona el orden de `B^(-1)A^(-1)` con deshacer páginas del diario y Karane insiste en ese orden antes de aceptar una inversa. En límites, las tutoras distinguen acercarse al punto de evaluar en él, y Karane recuerda que `0/0` no es cero. Son intervenciones originales de aprendizaje, no citas de sus series.

Los gestos de las frases y las imágenes anteriores permanecen. Los comentarios de etapa describen la idea matemática sin imponer otro gesto que contradiga la pose activa. Las situaciones de pista, error, errores repetidos, acierto, racha y espera mantienen su voz y referencias. Hahari añade comentarios sobre la etapa actual también en cursos básicos y sigue apareciendo solo cuando Hakari es la tutora elegida.

## Hahari, visita sorpresa

Hahari es la madre de Hakari y una figura maternal cariñosa de su grupo, según su [perfil oficial](https://hyakkano.com/character/hahari/). Se adapta como una invitada teatral de estudio con referencias a Hakari, Karane y Rentarou. Sus comentarios son originales.

Visita el ejercicio 10 de cualquier etapa únicamente cuando Hakari es la tutora seleccionada, y puede dar pistas y corregir errores. Se usa la pose de felicitación solo si el acierto mantiene una racha de al menos diez; en el ejercicio 11 aparece su despedida divertida si se mantiene una racha de al menos once. Son rachas consecutivas guardadas por la app, también entre etapas. Retomar el ejercicio 10 muestra la visita aunque sea la primera pregunta pendiente. Después vuelve Hakari, sin cambiar las preferencias. Con las demás tutoras no aparece Hahari.
