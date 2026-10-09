# Desarrollo de Lumar Academy

App Flutter de matemáticas en español para Android e iOS, con estética kawaii y anime, violetas y rosas, corazones decorativos, tarjetas con profundidad y menú redondeado. Incorpora exclusivamente las imágenes de personajes aportadas por el usuario; Codex no ha generado ilustraciones.

## Funciones

- Inicio con siguiente unidad y progreso real.
- Selector de temporada en inicio, recorrido y práctica, con preferencia guardada.
- Álgebra: siete unidades de operaciones básicas, variables, expresiones, ecuaciones, potencias, polinomios y factorización.
- Geometría: seis unidades de rectas y ángulos, triángulos, perímetro y área, círculos, Pitágoras y volúmenes.
- Trigonometría: seis unidades de lados del triángulo rectángulo, razones, grados y radianes, ángulos especiales, círculo unitario e identidades, alturas y distancias.
- Teoría y un ejemplo resuelto en pasos por unidad.
- Introducción propia para cada una de las 52 etapas: objetivo, conexión con lo aprendido y comprobación final, con un saludo adaptado a la tutora. En práctica puede abrirse desde «Introducción a esta etapa».
- 1130 ejercicios interactivos: se conservan los 380 de álgebra, geometría y trigonometría y los 150 de logaritmos, potencias y segundo grado. Precálculo añade 16 etapas y álgebra lineal 14, con 20 ejercicios progresivos por etapa (600 nuevos). Todos los ejercicios de los cinco cursos añadidos tienen pista, explicación de errores y solución en al menos tres pasos desplegable durante la práctica.
- Kit avanzado con requisitos, objetivos, fórmulas y errores frecuentes. Precálculo y álgebra lineal tienen cinco niveles por etapa, gráficas con tabla y punto móvil, vectores a escala uniforme y matrices legibles.
- 70 variantes de diálogo por acción combinadas con 260 comentarios escritos específicamente para las 52 etapas y las cinco tutoras, además de 40 textos de curso. La voz identifica el tema, la regla, la pista y cómo comprobar una respuesta; las introducciones y despedidas también se personalizan. Se mantienen poses, gestos, referencias y frases anteriores, incluidos los comentarios de Hahari.
- Esquemas dibujados en Flutter para los doce ejemplos de geometría y trigonometría, con etiquetas y descripción accesible.
- Práctica que retoma los ejercicios pendientes y permite repasar unidades terminadas.
- Perfil con nombre editable, logros, puntos y selección entre Kurisu Makise, Yuno Gasai, Kotoko Ijichi, Hakari Hanazono y Karane Inda. Cada una tiene diálogos propios basados en investigación de sus personalidades y adaptados al aprendizaje, sin sexualización.
- Retratos y expresiones en pistas y aciertos, club de tutoras en inicio y tipografía redondeada Nunito incluida localmente.
- Tutoras entre el enunciado y las respuestas, con poses de las carpetas por personaje, un globo de diálogo y botón de pista con imagen. Reaccionan a aciertos, errores, más de tres errores en el mismo ejercicio, rachas y 45 segundos de espera.
- Ocho variantes de diálogo por personaje y situación (280 frases), con guiños a la cuarta pared, gestos escritos, humor tsundere y referencias a sus animes. Se conservan las frases anteriores; las pistas rotan también entre ejercicios y etapas. Las explicaciones matemáticas se muestran junto a sus comentarios.
- Catálogo de 44 poses por expresión con dos comentarios propios por pose. Los números añadidos para evitar nombres repetidos no determinan el orden ni la prioridad. Las condiciones explícitas del título (racha, errores, ejercicio especial) se programan por separado.
- Hahari visita el ejercicio número 10 real de cada etapa únicamente cuando Hakari es la tutora seleccionada, incluso al retomar una práctica. Sus imágenes responden al error y a una racha de al menos diez; su escena extra aparece después del ejercicio 11 si la racha llega a once. La selección de tutora permanece guardada.
- Despedidas ilustradas para las cinco tutoras: al terminar una etapa y al completar todos los ejercicios de un curso. Incluyen gestos y referencias a los animes.
- Personajes superpuestos sobre la interfaz del ejercicio, sin marcos ni recortes, con entrada animada, sombra de apoyo y expresiones escritas en sus diálogos. La imagen mantiene sus proporciones y deja libres los botones.
- PNG transparentes nuevos enlazados con sus nombres actuales. Karane y Hakari tienen iconos circulares exclusivos, con tres expresiones de sus láminas, en el diálogo y el botón de pista.
- Menú de Ajustes desde el engranaje en inicio, lecciones y práctica, o desde el perfil: música, volumen, tutora, reducción del movimiento de entrada y reacciones de espera. Las preferencias se guardan localmente.
- Racha guardada entre unidades y sesiones: aciertos consecutivos; un error reinicia la racha, conservando los ejercicios completados. Kurisu celebra desde cinco, Yuno desde cuatro y las demás desde tres. Repetir el mismo botón de comprobación no suma aciertos.
- Música de piano incluida sin conexión, con encendido en la barra superior, controles de volumen en el perfil y pausa automática al salir de la app. Empieza desactivada y recuerda la preferencia.
- Guardado local versionado con `shared_preferences`: respuestas correctas únicas, nombre y tutora. Repetir ejercicios no duplica puntos. Los errores de almacenamiento se muestran con opción de reintento.
- Las ocho temporadas están disponibles sin bloqueos obligatorios. Precálculo es la temporada 3 y álgebra lineal la temporada 8. Porcentaje y logros separados por materia; el perfil también muestra el progreso global. Las partidas antiguas conservan sus aciertos.

El progreso es por dispositivo, sin cuenta ni sincronización. Borrar los datos de la app o desinstalarla elimina el progreso. Reiniciarlo desde el perfil requiere confirmación y conserva nombre y tutora.

## Ejecutar y comprobar

```sh
flutter pub get
flutter run
flutter analyze
flutter test
flutter build apk --debug
```

Para exportar capturas de las cuatro pantallas principales, los ejercicios con las cinco tutoras y las reacciones de espera, pista, error y racha a `build/previews/`, ejecutar `flutter test test/preview.dart`. Son capturas de la interfaz Flutter con las imágenes aportadas, no ilustraciones generadas. La utilidad utiliza las fuentes e iconos incluidos en la app.

Se necesita Flutter compatible con Dart 3.13.5 o superior. La compilación de iOS requiere macOS y Xcode. La configuración de firma para publicar en las tiendas queda pendiente; la APK de desarrollo utiliza la configuración original de depuración.

## Estructura

- `lib/main.dart`: arranque y carga del progreso.
- `lib/src/app.dart`: navegación, inicio, recorrido, lección, práctica y perfil.
- `lib/src/widgets.dart`: componentes kawaii, menú, corazones y encuadres de retratos.
- `lib/src/tutors.dart`: catálogo de personajes, recursos, expresiones y diálogos por situación.
- `lib/src/reactions.dart`: asignación explícita de poses según los nombres aportados y variantes de diálogo para ejercicios.
- `lib/src/more_dialogues.dart`: 140 diálogos adicionales para las siete reacciones de las cinco tutoras.
- `lib/src/exercise_tutor.dart`: personaje y diálogo dentro del problema, con pistas y explicación de errores.
- `lib/src/widgets/tutor_overlay.dart`: widget reutilizable de PNG sobre la interfaz, sin marco, con entrada animada, sombra y prioridad para PNG del mismo nombre. Las imágenes siguen en `assets/tutors/`.
- `lib/src/widgets/tutor_hint_avatar.dart`: encuadres de los iconos circulares exclusivos de Karane y Hakari.
- `lib/src/lesson_introduction.dart`: presentación y objetivos de las 52 etapas.
- `lib/src/pose_catalog.dart`: imágenes organizadas por expresión, condiciones especiales y aparición de Hahari.
- `lib/src/tutor_farewell.dart`: fotos y diálogos de despedida de etapa y curso.
- `lib/src/settings.dart`: menú de ajustes con preferencias persistentes.
- `lib/src/music.dart`: reproducción local, ajustes, manejo de errores y ciclo de vida del audio.
- `docs/PERSONALIDADES.md`: investigación, fuentes oficiales y adaptación educativa de los personajes.
- `lib/src/curriculum.dart`: temporadas, álgebra y navegación entre unidades.
- `lib/src/course_models.dart`: modelos compartidos de temporadas, unidades y ejercicios.
- `lib/src/geometry_curriculum.dart` y `lib/src/trigonometry_curriculum.dart`: contenido de las nuevas materias.
- `lib/src/practice_bank.dart`: 323 ejercicios adicionales, enlazados al final de cada etapa para conservar los identificadores originales.
- `lib/src/advanced_curriculum.dart`: cursos de logaritmos, potencias y ecuaciones de segundo grado, 50 ejercicios con pasos por curso.
- `tool/advanced_courses.py`: generador reproducible de los tres cursos nuevos.
- `lib/src/extended_curriculum.dart`: las 30 etapas de precálculo y álgebra lineal. Temario: [docs/CURSOS_AVANZADOS.md](CURSOS_AVANZADOS.md).
- `lib/src/widgets/advanced_study.dart`: gráficas interactivas, tablas, matrices, vectores, fórmulas y dificultad.
- `lib/src/advanced_dialogues.dart`: diálogos situacionales y saludos avanzados.
- `lib/src/stage_dialogues.dart`: comentarios propios de cada tutora por etapa, errores frecuentes, comprobaciones y textos de los ocho cursos. Es el lugar para editar esas intervenciones sin tocar ejercicios ni imágenes.
- `tool/extended_courses.py`: generador reproducible de los 600 retos; `tool/extended_course_audit.json` aporta 120 casos para comprobaciones matemáticas independientes.
- `tool/expand_practice.py`: generador reproducible del banco adicional. El resultado es contenido Dart constante que se puede editar directamente; no se generan ejercicios aleatorios durante el uso de la app.
- `lib/src/widgets/math_diagram.dart`: esquemas educativos del ejemplo resuelto.
- `lib/src/progress.dart`: estado observable, recuperación y cola de escrituras locales.
- `test/widget_test.dart`: persistencia, contenido, flujo educativo, reanudación, selección de tutora y diseño móvil.

## Añadir las ilustraciones del usuario

1. Copiar las nuevas imágenes a `assets/tutors/kurisu/`, `yuno/`, `kotoko/`, `hakari/` o `karane/`.
2. Las cinco subcarpetas ya están registradas en `flutter.assets` de `pubspec.yaml`.
3. Asignar las poses por situación en `lib/src/reactions.dart`. Los nombres de archivo se conservan, pero los diálogos que ve el estudiante son textos educativos propios. Los retratos generales siguen en `lib/src/tutors.dart`.

Los nuevos PNG transparentes están asignados explícitamente en `reactions.dart`, incluidos los nombres con guiones bajos, y se usan en los ejercicios. Para futuras poses, actualizar sus rutas ahí. También se da prioridad a un PNG con el mismo nombre base que un JPG si ambos están disponibles. Las láminas exclusivas se encuadran únicamente al mostrarlas: los archivos originales no se modifican.

Se integraron los 12 archivos aportados, conservando sus nombres y contenido original. Las hojas de expresiones se encuadran en la interfaz. Los fondos cuadriculados de los JPG están incorporados en esos archivos y no son transparencia real. Si una imagen falla al cargar, aparece un icono de reserva. Nunito y Noto Sans Math se incluyen localmente, con sus licencias OFL en `assets/fonts/OFL.txt` y `assets/fonts/OFL-NotoSansMath.txt`. Noto Sans Math permite mostrar correctamente los símbolos matemáticos.

Las selecciones antiguas Hikari y Rei migran a Yuno y Kurisu respectivamente, conservando nombre y ejercicios completados. Los corazones son decorativos: los errores no restan vidas ni progreso. La investigación y las decisiones de adaptación están en [PERSONALIDADES.md](docs/PERSONALIDADES.md).

Para ampliar el currículo, añadir unidades a la temporada correspondiente. El repositorio de progreso cuenta automáticamente las temporadas disponibles. Los indicadores del recorrido y los logros son por temporada, y el perfil muestra además el avance global. Al ampliar una unidad se conservan sus respuestas guardadas; para completarla también hay que resolver los ejercicios añadidos.

## Validación de esta implementación

La música es **Slow Piano Intermission**, de Julie Damsgaard / Spring Spring, publicada con licencia CC0 en [OpenGameArt](https://opengameart.org/content/slow-piano-intermission). Créditos y licencia: [assets/audio/CREDITS.md](../assets/audio/CREDITS.md). El OGG original se convirtió a MP3 para reproducción móvil. Para sustituirlo, actualizar `AssetSource` en `lib/src/music.dart`, el registro en `pubspec.yaml` y los créditos.

- `flutter analyze`: sin problemas.
- `flutter test`: 52 pruebas aprobadas. Verifica los 1130 ejercicios, progresión de dificultad, respuestas numéricas, 120 casos matemáticos independientes de los cursos nuevos, poses, cobertura de diálogos por personaje en las 52 etapas y ocho cursos, Hahari exclusiva con Hakari, despedidas, ajustes persistentes, música, conservación del progreso antiguo y pantallas de 320 px con texto ampliado.
- Exportación de capturas: archivos en `build/previews/`.
- APK Android: `flutter build apk --debug` aprobado tras completar las descargas de las dependencias de Android, Kotlin y el motor Flutter ARM64. APK de desarrollo en `build/app/outputs/flutter-apk/app-debug.apk`.
- iOS: compilación pendiente en macOS con Xcode.
- Reproducción audible de música: pendiente de comprobar en un dispositivo físico; las pruebas verifican el controlador con una salida de audio simulada.

## Si Gradle se detiene descargando dependencias

Comprobar el acceso a `dl.google.com`, `repo.maven.apache.org` y `storage.googleapis.com`, y repetir `flutter build apk --debug` con conexión. Las dependencias descargadas quedan en la caché de Gradle. El modo sin conexión solo funciona cuando todos los artefactos necesarios ya están descargados.

Para este proyecto, Flutter utiliza el JDK de Android Studio en `D:/android studio/jbr`. Si se ejecuta `android/gradlew.bat` directamente desde PowerShell, definir `$env:JAVA_HOME = 'D:/android studio/jbr'` en esa terminal antes de ejecutar Gradle, para evitar el Java 8 del sistema. Gradle necesita Java 17 o superior; la compilación fue comprobada con el JDK 21 de Android Studio.
