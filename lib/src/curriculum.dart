import 'practice_bank.dart';
import 'geometry_curriculum.dart';
import 'trigonometry_curriculum.dart';

export 'geometry_curriculum.dart';
export 'trigonometry_curriculum.dart';

import 'course_models.dart';
export 'course_models.dart';

const seasons = [
  Season(
    1,
    'Álgebra',
    'De tus primeros pasos a la factorización.',
    algebraLessons,
  ),
  Season(
    2,
    'Geometría',
    'Figuras, medidas y nuevas perspectivas.',
    geometryLessons,
  ),
  Season(3, 'Precálculo', 'Funciones para ir un paso más allá.', []),
  Season(
    4,
    'Trigonometría',
    'Ángulos, triángulos y conexiones.',
    trigonometryLessons,
  ),
];

final allLessons = seasons
    .expand((season) => season.lessons)
    .toList(growable: false);
Season seasonForLesson(Lesson lesson) => seasons.firstWhere(
  (season) => season.lessons.any((item) => item.id == lesson.id),
);
Lesson? followingLesson(Lesson lesson) {
  final lessons = seasonForLesson(lesson).lessons;
  final index = lessons.indexWhere((item) => item.id == lesson.id);
  return index + 1 < lessons.length ? lessons[index + 1] : null;
}

const algebraLessons = [
  Lesson(
    'operations',
    'Operaciones básicas',
    'El orden cambia todo',
    '+',
    'Primero resuelve paréntesis, luego potencias, después multiplicación y división, y al final suma y resta. Las operaciones del mismo nivel se hacen de izquierda a derecha. Sumar un negativo equivale a restar.',
    '8 + 3 × (6 − 4)',
    [
      'Paréntesis: 6 − 4 = 2.',
      'Multiplicación: 3 × 2 = 6.',
      'Suma: 8 + 6 = 14.',
    ],
    [
      Exercise(
        '6 + 2 × 5 = ?',
        ['40', '16', '30'],
        1,
        'Haz la multiplicación antes de sumar.',
        '2 × 5 = 10; luego 6 + 10 = 16.',
        [
          '40 resulta de sumar primero. La multiplicación tiene prioridad.',
          '',
          'Multiplica solo 2 por 5, no la suma completa.',
        ],
      ),
      Exercise(
        '(12 − 4) ÷ 2 = ?',
        ['10', '6', '4'],
        2,
        'Empieza dentro del paréntesis.',
        '12 − 4 = 8; luego 8 ÷ 2 = 4.',
        [
          'Has dividido antes de resolver el paréntesis.',
          'Debes restar 4 antes de dividir.',
          '',
        ],
      ),
      Exercise(
        '−3 + 7 = ?',
        ['4', '−10', '10'],
        0,
        'Desde −3, avanza 7 lugares hacia la derecha.',
        '7 − 3 = 4. El positivo tiene mayor valor absoluto.',
        [
          '',
          'Sumar 7 mueve el resultado hacia los positivos.',
          'Los signos son distintos: resta sus valores absolutos.',
        ],
      ),
      ...extraOperations,
    ],
  ),
  Lesson(
    'variables',
    'Variables',
    'Un nombre para lo desconocido',
    'x',
    'Una variable representa un número. Para evaluar una expresión, sustituye la letra por su valor. 3x significa 3 × x; el número que multiplica a la variable es su coeficiente.',
    '3x + 2 cuando x = 4',
    [
      'Sustituye x: 3 × 4 + 2.',
      'Multiplica: 12 + 2.',
      'Suma: el resultado es 14.',
    ],
    [
      Exercise(
        'Si x = 5, ¿cuánto es 2x + 1?',
        ['11', '8', '12'],
        0,
        '2x es 2 multiplicado por x.',
        '2 × 5 + 1 = 10 + 1 = 11.',
        ['', '2x no significa 2 + x.', 'El 1 se suma después de multiplicar.'],
      ),
      Exercise(
        'Si a = 3, ¿cuánto es a²?',
        ['6', '9', '5'],
        1,
        'a² significa a × a.',
        '3² = 3 × 3 = 9.',
        [
          'Elevar al cuadrado no es multiplicar por 2.',
          '',
          'El exponente indica multiplicaciones, no una suma.',
        ],
      ),
      Exercise(
        '¿Cuál es el coeficiente de 7y?',
        ['y', '1', '7'],
        2,
        'Busca el número que multiplica a la letra.',
        'En 7y, el número 7 multiplica a la variable y.',
        [
          'y es la variable, no el coeficiente.',
          'El coeficiente es 1 solo cuando no aparece otro número.',
          '',
        ],
      ),
      ...extraVariables,
    ],
  ),
  Lesson(
    'expressions',
    'Expresiones',
    'Combina lo que tiene en común',
    '≡',
    'Los términos semejantes tienen las mismas variables con los mismos exponentes. Puedes sumar sus coeficientes. La distributiva dice a(b + c) = ab + ac. Una expresión no lleva necesariamente signo igual.',
    '2(x + 3) + 4x',
    [
      'Distribuye el 2: 2x + 6 + 4x.',
      'Agrupa: (2 + 4)x + 6.',
      'Simplifica: 6x + 6.',
    ],
    [
      Exercise(
        'Simplifica 3x + 2x.',
        ['5x²', '6x', '5x'],
        2,
        'Suma los coeficientes y conserva la variable.',
        '3x + 2x = (3 + 2)x = 5x.',
        [
          'Al sumar no cambias el exponente de x.',
          'Has multiplicado los coeficientes; aquí se suman.',
          '',
        ],
      ),
      Exercise(
        'Desarrolla 3(x + 2).',
        ['3x + 2', '3x + 6', '5x'],
        1,
        'Multiplica 3 por cada término.',
        '3 × x + 3 × 2 = 3x + 6.',
        [
          'El 3 debe multiplicar también al 2.',
          '',
          'x y 2 no son términos semejantes.',
        ],
      ),
      Exercise(
        'Simplifica 4a + 3 − a.',
        ['3a + 3', '6a', '4a + 2'],
        0,
        '−a tiene coeficiente −1; el 3 es una constante.',
        '4a − a = 3a; la constante 3 permanece.',
        [
          '',
          'No puedes sumar una constante a un término con a.',
          'Resta el coeficiente de a, no la constante.',
        ],
      ),
      ...extraExpressions,
    ],
  ),
  Lesson(
    'equations',
    'Ecuaciones',
    'Encuentra el equilibrio',
    '=',
    'Una ecuación afirma que dos expresiones son iguales. Para despejar una variable, realiza la misma operación en ambos lados. Usa operaciones inversas y comprueba el valor en la ecuación original.',
    '2x + 3 = 11',
    [
      'Resta 3 a ambos lados: 2x = 8.',
      'Divide ambos lados entre 2: x = 4.',
      'Comprueba: 2 × 4 + 3 = 11.',
    ],
    [
      Exercise(
        'x + 5 = 12. ¿Cuánto vale x?',
        ['17', '7', '60'],
        1,
        'Deshaz la suma restando 5 en ambos lados.',
        'x = 12 − 5 = 7. Comprueba: 7 + 5 = 12.',
        [
          'Necesitas restar 5, no sumarlo.',
          '',
          'La operación inversa de sumar es restar.',
        ],
      ),
      Exercise(
        '3x = 18. ¿Cuánto vale x?',
        ['15', '54', '6'],
        2,
        '3 multiplica a x. Usa la operación inversa.',
        'Divide entre 3: x = 18 ÷ 3 = 6.',
        [
          'Restar 3 no deshace una multiplicación.',
          'Multiplicar por 3 no aísla la variable.',
          '',
        ],
      ),
      Exercise(
        '2x − 4 = 10. ¿Cuánto vale x?',
        ['7', '3', '14'],
        0,
        'Suma 4 a ambos lados, luego divide entre 2.',
        '2x = 14; por tanto x = 7.',
        [
          '',
          'Para deshacer −4, suma 4, no lo restes.',
          '14 es el valor de 2x; aún debes dividir entre 2.',
        ],
      ),
      ...extraEquations,
    ],
  ),
  Lesson(
    'powers',
    'Potencias',
    'Pequeños exponentes, grandes ideas',
    '²',
    'Una potencia representa multiplicación repetida. Para multiplicar potencias de igual base, suma exponentes: xᵃ × xᵇ = xᵃ⁺ᵇ. Al dividirlas, resta exponentes si la base no es cero. Toda base no nula elevada a 0 vale 1.',
    'x² × x³',
    [
      'Expande: (x × x) × (x × x × x).',
      'Cuenta cinco factores x.',
      'Suma exponentes: x²⁺³ = x⁵.',
    ],
    [
      Exercise(
        '2³ = ?',
        ['6', '8', '9'],
        1,
        'Multiplica tres factores iguales a 2.',
        '2 × 2 × 2 = 8.',
        [
          'El exponente no multiplica a la base.',
          '',
          'La base es 2: cada factor debe ser 2.',
        ],
      ),
      Exercise(
        'x³ × x² = ?',
        ['x⁶', '2x⁵', 'x⁵'],
        2,
        'Con la misma base, suma los exponentes.',
        'x³ × x² = x³⁺² = x⁵.',
        [
          'Los exponentes se suman al multiplicar potencias de igual base.',
          'Los coeficientes son 1 × 1 = 1, no 2.',
          '',
        ],
      ),
      Exercise(
        '5⁰ = ?',
        ['1', '0', '5'],
        0,
        'La base no es cero.',
        'Toda base distinta de cero elevada a 0 vale 1.',
        [
          '',
          'El exponente cero no hace que la potencia sea cero.',
          '5¹ vale 5; 5⁰ vale 1.',
        ],
      ),
      ...extraPowers,
    ],
  ),
  Lesson(
    'polynomials',
    'Polinomios',
    'Ordena, suma y multiplica',
    'Σ',
    'Un polinomio es una suma de términos con exponentes enteros no negativos. Su grado es el mayor exponente con coeficiente no nulo. Suma términos semejantes y usa la distributiva para multiplicar.',
    '(x + 2)(x + 3)',
    [
      'Multiplica cada término: x² + 3x + 2x + 6.',
      'Agrupa: x² + (3 + 2)x + 6.',
      'Resultado: x² + 5x + 6.',
    ],
    [
      Exercise(
        '(2x² + x) + (x² + 3x) = ?',
        ['3x² + 4x', '7x³', '3x² + 3x'],
        0,
        'Agrupa por separado los términos x² y x.',
        '2x² + x² = 3x²; x + 3x = 4x.',
        [
          '',
          'Los términos de diferente grado no se pueden combinar.',
          'También debes sumar el x del primer polinomio.',
        ],
      ),
      Exercise(
        '¿Cuál es el grado de 4x³ + 2x + 1?',
        ['4', '3', '1'],
        1,
        'Busca el mayor exponente de x.',
        'El mayor exponente es 3, así que su grado es 3.',
        [
          '4 es un coeficiente, no un exponente.',
          '',
          '1 es la constante; hay un exponente mayor.',
        ],
      ),
      Exercise(
        '(x + 1)(x + 2) = ?',
        ['x² + 2', 'x² + 2x + 2', 'x² + 3x + 2'],
        2,
        'Distribuye los cuatro productos antes de agrupar.',
        'x² + 2x + x + 2 = x² + 3x + 2.',
        [
          'Faltan los productos cruzados 2x y x.',
          'Falta el x que resulta de 1 × x.',
          '',
        ],
      ),
      ...extraPolynomials,
    ],
  ),
  Lesson(
    'factoring',
    'Factorización',
    'Descubre las piezas de la expresión',
    '∏',
    'Factorizar transforma una suma en un producto. Empieza buscando un factor común. Para x² + bx + c, busca dos números que sumen b y cuyo producto sea c. La diferencia de cuadrados cumple a² − b² = (a − b)(a + b).',
    'x² + 5x + 6',
    [
      'Busca dos números cuyo producto sea 6.',
      '2 y 3 también suman 5.',
      'Factoriza: (x + 2)(x + 3). Comprueba expandiendo.',
    ],
    [
      Exercise(
        'Factoriza 6x + 9.',
        ['3(2x + 3)', '6(x + 9)', '3(2x + 9)'],
        0,
        'El factor común de 6 y 9 es 3.',
        '6x ÷ 3 = 2x; 9 ÷ 3 = 3. Resultado: 3(2x + 3).',
        [
          '',
          'Divide todos los términos entre el factor que extraes.',
          'También debes dividir el 9 entre 3.',
        ],
      ),
      Exercise(
        'Factoriza x² + 7x + 12.',
        ['(x + 2)(x + 6)', '(x + 3)(x + 4)', '(x − 3)(x − 4)'],
        1,
        'Busca dos números que sumen 7 y multipliquen 12.',
        '3 + 4 = 7 y 3 × 4 = 12.',
        [
          '2 + 6 = 8, no 7.',
          '',
          'Con ambos signos negativos, el término central sería −7x.',
        ],
      ),
      Exercise(
        'Factoriza x² − 9.',
        ['(x − 9)(x + 9)', '(x − 3)²', '(x − 3)(x + 3)'],
        2,
        '9 es 3². Usa la diferencia de cuadrados.',
        'x² − 3² = (x − 3)(x + 3).',
        [
          'Debes usar la raíz de 9, que es 3.',
          'Ese cuadrado produce x² − 6x + 9.',
          '',
        ],
      ),
      ...extraFactoring,
    ],
  ),
];
