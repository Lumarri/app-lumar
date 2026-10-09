# Precálculo y álgebra lineal

La selección del temario toma como referencias educativas [OpenStax Precálculo 2e](https://openstax.org/books/precalculus-2e/pages/preface) y el [índice de recursos de Álgebra Lineal de MIT](https://ocw.mit.edu/courses/18-06sc-linear-algebra-fall-2011/pages/resource-index/). Las explicaciones, ejemplos, preguntas y diálogos son originales; no se incorporan páginas, ejercicios ni imágenes de esos cursos.

Son cursos introductorios completos del temario indicado, con 20 retos por etapa. Los límites son una introducción a cálculo; no incluyen un curso de derivadas o integrales. El recorrido de álgebra lineal llega a diagonalización y sus aplicaciones, sin tratar descomposición en valores singulares ni formas de Jordan.

## Recorrido

| Precálculo · temporada 3 | Álgebra lineal · temporada 8 |
| --- | --- |
| 1. Funciones y dominio | 1. Vectores y geometría |
| 2. Desigualdades y valor absoluto | 2. Matrices y operaciones |
| 3. Transformaciones y gráficas | 3. Sistemas lineales |
| 4. Composición e inversas | 4. Eliminación de Gauss |
| 5. Polinomios y raíces | 5. Determinantes |
| 6. Funciones racionales | 6. Inversas y sistemas matriciales |
| 7. Modelos exponenciales y logarítmicos | 7. Espacios y subespacios |
| 8. Círculo unitario y radianes | 8. Independencia y bases |
| 9. Identidades y ecuaciones trigonométricas | 9. Rango, núcleo y dimensión |
| 10. Secciones cónicas | 10. Transformaciones lineales |
| 11. Paramétricas y coordenadas polares | 11. Ortogonalidad y Gram–Schmidt |
| 12. Sucesiones y series | 12. Mínimos cuadrados |
| 13. Conteo y probabilidad | 13. Autovalores y autovectores |
| 14. Números complejos | 14. Diagonalización y aplicaciones |
| 15. Límites introductorios | |
| 16. Modelización y desafío final | |

## Progresión y herramientas

En cada etapa, los retos 1–4 son guiados, 5–8 de aplicación, 9–12 de conexión, 13–16 de razonamiento y 17–20 de desafío. Las cinco familias usan conceptos distintos, con parámetros propios en cada pregunta. Es una progresión editorial fija, no un ajuste automático a las respuestas del estudiante. Se puede consultar cualquier etapa sin bloquearla por fallos.

Cada reto tiene pista, explicación de las dos opciones incorrectas y al menos tres pasos de solución. Ver fórmulas, explorar valores o abrir pasos no marca un ejercicio como resuelto ni resta puntos. Estas ayudas sí evitan activar la pose de resolución rápida, igual que el botón de pista.

Las herramientas aparecen cuando el ejercicio incluye datos visuales: gráficas de funciones con punto móvil y tabla del muestreo, vectores con la misma escala en ambos ejes y matrices con filas y columnas separadas. Las curvas se trazan uniendo muestras; no sustituyen una prueba analítica. Las fórmulas y el ejemplo están disponibles también en la lección. Las matrices del enunciado usan punto y coma para separar filas y los índices empiezan en uno.

## Tutoras y progreso

`advanced_dialogues.dart` añade dos variantes por tutora y acción (70 plantillas), adaptadas a la habilidad, etapa y pista actual. `stage_dialogues.dart` las combina con 260 comentarios específicos de personaje y etapa y 40 textos de curso; la cobertura incluye las 52 etapas de toda la app. Las introducciones incluyen el primer objetivo y la progresión; las despedidas recuperan una comprobación concreta del tema aprendido. Se conservan diálogos, gestos, poses, referencias e imágenes anteriores.

Hahari mantiene su visita exclusiva al reto 10 cuando Hakari es la tutora seleccionada; sus comentarios ahora también se adaptan al tema avanzado. La racha y la escena del reto 11 conservan sus condiciones.

Los identificadores anteriores se conservan. Las nuevas etapas añaden identificadores con prefijos `pre_` y `lin_`; el mismo almacenamiento local guarda los aciertos y la temporada seleccionada. El total global pasa a 1130 ejercicios, por lo que el porcentaje global se recalcula sobre el nuevo total sin borrar ningún acierto.

## Editar y comprobar

- Contenido: `tool/extended_courses.py` genera `lib/src/extended_curriculum.dart`. Para cambios permanentes, edita el generador y ejecútalo antes de dar formato con Dart. Editar el Dart directamente funciona, pero regenerarlo reemplaza esos cambios.
- Metadatos de autoría: `tool/extended_course_metadata.json` recoge teoría, objetivos y fórmulas de cada etapa.
- Visuales: `StudyVisual` en `course_models.dart` y `widgets/advanced_study.dart`.
- Comprobaciones: `test/extended_courses_test.dart` valida los 600 retos, sus niveles, ayudas, diálogos, guardado y pantallas. Sus 120 casos independientes comprueban identidades polinómicas, productos vectoriales, productos e inversas matriciales, sistemas, rangos, residuos de mínimos cuadrados y pares propios mediante cálculo independiente.
