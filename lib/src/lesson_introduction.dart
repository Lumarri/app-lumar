import 'package:flutter/material.dart';

import 'curriculum.dart';
import 'advanced_dialogues.dart';
import 'tutors.dart';
import 'widgets.dart';
import 'widgets/tutor_overlay.dart';

class StageIntroduction {
  const StageIntroduction(this.goal, this.context, this.checkpoint);
  final String goal, context, checkpoint;
}

final stageIntroductions = {
  for (final lesson in [...precalculusLessons, ...linearAlgebraLessons])
    lesson.id: StageIntroduction(
      '${lesson.title}: ${lesson.guide!.objectives.join(', ').toLowerCase()}.',
      lesson.theory,
      'Resolverás 20 retos en cinco niveles: guiado, aplicación, conexión, razonamiento y desafío.',
    ),
  'logarithms': StageIntroduction(
    'Comprender y operar con logaritmos reales.',
    'Un logaritmo busca un exponente. Repasa las potencias del álgebra y comprueba siempre las condiciones de base y argumento.',
    'Resolverás 50 retos de evaluación, reglas, ecuaciones y dominio.',
  ),
  'advanced_powers': StageIntroduction(
    'Dominar las reglas de los exponentes.',
    'Amplía las potencias del álgebra con cocientes, exponentes negativos y raíces de bases positivas.',
    'Resolverás 50 retos justificando cada regla aplicada.',
  ),
  'quadratics': StageIntroduction(
    'Resolver ecuaciones de segundo grado y comprobar sus raíces.',
    'Conecta la factorización con las ecuaciones. El discriminante te dirá cuándo hay dos raíces reales, una doble o ninguna real.',
    'Resolverás 50 retos, incluyendo la fórmula general y problemas de medidas.',
  ),
  'operations': StageIntroduction(
    'Resolver operaciones en el orden correcto.',
    'Los paréntesis y la prioridad de las operaciones son la base para todo el álgebra. Primero construiremos esa base con números.',
    'Podrás explicar por qué multiplicar antes de sumar cambia el resultado.',
  ),
  'variables': StageIntroduction(
    'Entender qué representa una letra y sustituir su valor.',
    'Una variable guarda un valor que puede cambiar. Con lo que ya sabes de operaciones, podrás calcular expresiones con letras.',
    'Podrás reemplazar una variable por un número y comprobar tu cálculo.',
  ),
  'expressions': StageIntroduction(
    'Simplificar expresiones reuniendo términos semejantes.',
    'Ahora combinamos números y variables. Aprenderás qué términos se pueden juntar y cuáles deben mantenerse separados.',
    'Podrás simplificar una expresión sin cambiar su valor.',
  ),
  'equations': StageIntroduction(
    'Encontrar una incógnita manteniendo la igualdad.',
    'Una ecuación se comporta como una balanza: cada transformación debe conservar el equilibrio. Usaremos operaciones inversas.',
    'Podrás despejar una variable y verificarla en la ecuación original.',
  ),
  'powers': StageIntroduction(
    'Interpretar potencias y aplicar sus reglas básicas.',
    'Las potencias escriben multiplicaciones repetidas de forma breve. Distinguiremos la base del exponente antes de operar.',
    'Podrás calcular potencias y justificar cuándo se suman los exponentes.',
  ),
  'polynomials': StageIntroduction(
    'Operar con polinomios y aplicar la distributiva.',
    'Los polinomios reúnen varios términos. Usaremos términos semejantes y la distributiva para sumarlos y multiplicarlos.',
    'Podrás desarrollar productos y ordenar el resultado sin perder términos.',
  ),
  'factoring': StageIntroduction(
    'Escribir una expresión como producto de factores.',
    'Llegamos al camino inverso de desarrollar: buscar piezas que, multiplicadas, reconstruyan el polinomio. Empezaremos por el factor común.',
    'Podrás factorizar y comprobar multiplicando otra vez.',
  ),
  'geo_angles': StageIntroduction(
    'Medir y relacionar ángulos.',
    'Comienza con giros, rectas y ángulos rectos. Luego busca qué pares completan 90° o 180°.',
    'Distinguirás complementarios, suplementarios y opuestos por el vértice.',
  ),
  'geo_triangles': StageIntroduction(
    'Reconocer y comprobar triángulos.',
    'Usaremos los ángulos que ya conoces para cerrar una figura de tres lados.',
    'Hallarás un ángulo faltante y comprobarás si tres lados forman un triángulo.',
  ),
  'geo_perimeter': StageIntroduction(
    'Distinguir contorno y superficie.',
    'Ahora medimos figuras: rodearlas requiere longitudes; cubrirlas requiere áreas.',
    'Calcularás perímetros y áreas indicando sus unidades.',
  ),
  'geo_circle': StageIntroduction(
    'Usar radio, diámetro y π.',
    'Las figuras curvas necesitan nuevas fórmulas. Separa el borde de la superficie antes de elegir una.',
    'Calcularás circunferencias y áreas exactas o aproximadas.',
  ),
  'geo_pythagoras': StageIntroduction(
    'Hallar lados de triángulos rectángulos.',
    'Las potencias del álgebra nos permiten conectar las longitudes de tres lados. Primero comprueba el ángulo recto.',
    'Usarás cuadrados y raíces para hallar una hipotenusa o un cateto.',
  ),
  'geo_solids': StageIntroduction(
    'Medir el espacio en tres dimensiones.',
    'Pasamos de superficies a cuerpos. Multiplicar un área de base por una altura construye un volumen.',
    'Calcularás volúmenes de cajas, cubos y cilindros en unidades cúbicas.',
  ),
  'trig_sides': StageIntroduction(
    'Nombrar los lados respecto a un ángulo.',
    'Puedes repasar Pitágoras en geometría. Aquí importa desde qué ángulo miras el triángulo.',
    'Distinguirás hipotenusa, opuesto y adyacente sin confundir el ángulo de referencia.',
  ),
  'trig_ratios': StageIntroduction(
    'Construir seno, coseno y tangente.',
    'Las razones conectan un ángulo con proporciones entre lados. Aprende qué pareja usa cada una.',
    'Elegirás y calcularás la razón correcta para un triángulo rectángulo.',
  ),
  'trig_radians': StageIntroduction(
    'Convertir grados y radianes.',
    'Un mismo giro puede medirse con dos escalas. Media vuelta, 180° = π radianes, será nuestro puente.',
    'Convertirás medidas y reconocerás el modo adecuado de la calculadora.',
  ),
  'trig_special': StageIntroduction(
    'Obtener valores exactos de ángulos especiales.',
    'Dos triángulos conocidos nos evitan depender de la calculadora: 45°–45°–90° y 30°–60°–90°.',
    'Relacionarás 30°, 45° y 60° con sus razones exactas.',
  ),
  'trig_circle': StageIntroduction(
    'Extender las razones al círculo unitario.',
    'El triángulo nos llevó hasta los ángulos agudos. Las coordenadas del círculo nos dejan explorar una vuelta completa.',
    'Reconocerás signos por cuadrante y aplicarás sen² θ + cos² θ = 1.',
  ),
  'trig_applications': StageIntroduction(
    'Calcular alturas y distancias reales.',
    'Reúne todo lo aprendido: dibuja, elige el ángulo y decide qué razón usa los datos disponibles.',
    'Resolverás problemas de escaleras y elevación incluyendo la altura de observación.',
  ),
};

String stageTutorGreeting(TutorProfile tutor, Lesson lesson) =>
    '${_stageTutorGreeting(tutor, lesson)}\n\n${advancedStageGreeting(tutor, lesson)}';

String _stageTutorGreeting(
  TutorProfile tutor,
  Lesson lesson,
) => switch (tutor.id) {
  'kurisu' =>
    'Nuestro experimento de hoy: ${lesson.title.toLowerCase()}. En el laboratorio de Okabe sobran nombres dramáticos; aquí necesitamos pruebas. Y no me llames Christina… ¡soy Kurisu!',
  'karane' =>
    '¡Nueva etapa: ${lesson.title.toLowerCase()}! Hakari ya tiene un plan y Rentarou seguro nos animaría. ¡No es que preparara esta explicación especialmente para ti!… Bueno, sí.',
  'hakari' =>
    'Preparé un plan para ${lesson.title.toLowerCase()}. Rentarou siempre se esfuerza por todos; yo me esforzaré por que lo entiendas. Karane dirá que no le importa… mira cómo ya está ayudando. ♡',
  'kotoko' =>
    '¡Vamos con ${lesson.title.toLowerCase()}! A Takuya le escucho hablar de Kiramon; a ti te escucho explicar tus cálculos. Kei, ven también: ¡hoy estudiamos en equipo!',
  _ =>
    'Abramos mi Diario del Futuro para ${lesson.title.toLowerCase()}. ¿Qué haría Yukki? Pensar antes de actuar. Yo puedo anticipar el entusiasmo, pero la respuesta tendrás que construirla tú. ♡',
};

class LessonIntroduction extends StatelessWidget {
  const LessonIntroduction({
    super.key,
    required this.lesson,
    required this.tutor,
  });
  final Lesson lesson;
  final TutorProfile tutor;
  @override
  Widget build(BuildContext context) {
    final intro = stageIntroductions[lesson.id]!;
    final asset = switch (tutor.id) {
      'kurisu' => 'assets/tutors/kurisu/kurisu makise explicadonte la introduccion del curso .png',
      'karane' => 'assets/tutors/karane/te_explica.png',
      'hakari' => 'assets/tutors/hakari/te_explica.png',
      'kotoko' => 'assets/tutors/kotoko/presentacion de kotoko en la interfaz del menu.png',
      _ => 'assets/tutors/yuno/Yuno_Gasai_presentacion en el menupng.png',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 165,
          child: TutorOverlay(
            asset: asset,
            label: '${tutor.name} presenta ${lesson.title}',
            accent: tutor.accent,
            animationToken: '${tutor.id}:${lesson.id}',
          ),
        ),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Antes de empezar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                stageTutorGreeting(tutor, lesson),
                style: const TextStyle(color: violet),
              ),
              const SizedBox(height: 16),
              Text(
                'Tu objetivo',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(intro.goal),
              const SizedBox(height: 10),
              Text(intro.context),
              const SizedBox(height: 12),
              Text(
                'Al terminar: ${intro.checkpoint}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
