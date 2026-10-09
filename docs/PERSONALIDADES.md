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

Las 19 etapas de álgebra, geometría y trigonometría tienen una presentación con objetivo, contexto y criterio de comprobación. El saludo cambia según la personalidad y la etapa. Ajustes permite elegir tutora, regular música y volumen, reducir el movimiento de entrada y desactivar comentarios de espera; todo se guarda localmente.
