"""Author deterministic practice sets; preserve the three original exercise IDs.

Run from the project root: python tool/expand_practice.py.
The output is ordinary const Dart content, editable without this tool.
"""
import json
import re
from fractions import Fraction
from pathlib import Path

bank = {}

def add(stage, question, correct, wrong1, wrong2, hint, explanation, error1, error2):
    items = bank.setdefault(stage, [])
    values = [str(correct), str(wrong1), str(wrong2)]
    assert len(set(values)) == 3, (stage, question, values)
    assert question not in [e[0] for e in items], (stage, question)
    shift = len(items) % 3
    options = values[-shift:] + values[:-shift] if shift else values
    errors = ['', error1, error2]
    errors = errors[-shift:] + errors[:-shift] if shift else errors
    items.append((question, options, shift, hint, explanation, errors))

def frac(n, d):
    f = Fraction(n, d)
    return str(f.numerator) if f.denominator == 1 else f'{f.numerator}/{f.denominator}'

for i in range(17):
    a, b, c = i + 4, i % 4 + 2, i % 5 + 3
    if i % 3 == 0:
        add('operations', f'{a} + {b} × {c} = ?', a+b*c, (a+b)*c, a+b+c,
            'Multiplica antes de sumar.', f'{b} × {c} = {b*c}; después {a} + {b*c} = {a+b*c}.',
            'Sumaste antes de multiplicar. La multiplicación tiene prioridad.', 'El signo × pide multiplicar, no sumar esos dos números.')
    elif i % 3 == 1:
        add('operations', f'({a} + {b}) × {c} = ?', (a+b)*c, a+b*c, a+b+c,
            'Resuelve primero el paréntesis.', f'{a} + {b} = {a+b}; luego {a+b} × {c} = {(a+b)*c}.',
            'El paréntesis obliga a sumar antes de multiplicar.', 'Después del paréntesis debes multiplicar por el último número.')
    else:
        add('operations', f'−{a} + {a+c} = ?', c, -(2*a+c), 2*a+c,
            'Compara los valores absolutos. El positivo es mayor.', f'{a+c} − {a} = {c}; el resultado es positivo.',
            'Sumar un positivo mueve el resultado hacia la derecha.', 'Los signos son distintos: resta los valores absolutos, no los sumes.')

    if i % 3 == 0:
        add('variables', f'Si x = {c}, ¿cuánto vale {b}x + {a}?', b*c+a, b+c+a, b*(c+a),
            'Sustituye x y multiplica antes de sumar.', f'{b} × {c} + {a} = {b*c} + {a} = {b*c+a}.',
            'El coeficiente multiplica a x; no se suma a ella.', 'La suma final queda fuera de la multiplicación.')
    elif i % 3 == 1:
        add('variables', f'Si y = −{c}, ¿cuánto vale y + {a}?', a-c, a+c, -(a+c),
            'Reemplaza y por el número negativo completo.', f'y + {a} = −{c} + {a} = {a-c}.',
            'Has perdido el signo negativo de y.', 'La suma de un positivo y un negativo no es la suma negativa de sus magnitudes.')
    else:
        add('variables', f'¿Cuál es el coeficiente de {a}z?', a, 'z', 1,
            'El coeficiente es el número que multiplica a la letra.', f'{a}z = {a} × z; el coeficiente es {a}.',
            'z es la variable; el coeficiente es el número.', 'El coeficiente implícito es 1 solo cuando no hay otro número escrito.')

    if i % 3 == 0:
        add('expressions', f'Simplifica {a}x + {b}x.', f'{a+b}x', f'{a*b}x', f'{a+b}x²',
            'Los términos tienen la misma variable y exponente; suma sus coeficientes.', f'({a} + {b})x = {a+b}x.',
            'Sumar términos no multiplica sus coeficientes.', 'Sumar x con x no cambia su exponente.')
    elif i % 3 == 1:
        add('expressions', f'Desarrolla {b}(x + {a}).', f'{b}x + {b*a}', f'{b}x + {a}', f'x + {b*a}',
            'Distribuye el factor a los dos términos del paréntesis.', f'{b} × x + {b} × {a} = {b}x + {b*a}.',
            'Falta multiplicar el término constante por el factor.', 'Falta multiplicar x por el factor.')
    else:
        add('expressions', f'Simplifica {a}x + {b}y + {c}x.', f'{a+c}x + {b}y', f'{a+b+c}x', f'{a-c}x + {b}y',
            'Agrupa solo los términos con x; el término con y se mantiene.', f'{a}x + {c}x = {a+c}x; queda {a+c}x + {b}y.',
            'x e y no son términos semejantes y no pueden juntarse.', 'Los coeficientes de x se suman; no hay resta en el enunciado.')

    if i % 3 == 0:
        add('equations', f'Resuelve x + {a} = {a+c}.', c, 2*a+c, -c,
            'Resta la misma cantidad a ambos lados.', f'x = {a+c} − {a} = {c}. Comprobación: {c} + {a} = {a+c}.',
            'Para deshacer la suma debes restar, no sumar.', 'La diferencia es positiva; comprueba sustituyendo el signo.')
    elif i % 3 == 1:
        add('equations', f'Resuelve {b}x = {b*a}.', a, b*b*a, b*a-b,
            'Divide ambos lados entre el coeficiente de x.', f'x = {b*a} ÷ {b} = {a}. Comprobación: {b} × {a} = {b*a}.',
            'La operación inversa de multiplicar es dividir.', 'El coeficiente está multiplicando a x; restarlo no lo despeja.')
    else:
        add('equations', f'Resuelve {b}x + {c} = {b*a+c}.', a, Fraction(b*a+2*c,b), b*a,
            'Primero resta el término constante; después divide entre el coeficiente.', f'{b}x = {b*a+c} − {c} = {b*a}; x = {b*a} ÷ {b} = {a}.',
            'La constante se resta de ambos lados antes de dividir.', 'Has quitado la constante, pero aún falta dividir entre el coeficiente.')

    if i % 3 == 0:
        add('powers', f'Calcula {a}².', a*a, 2*a, a+2,
            'El cuadrado multiplica la base por sí misma.', f'{a}² = {a} × {a} = {a*a}.',
            'El exponente no es un factor que se multiplica por la base.', 'El exponente indica multiplicaciones repetidas, no una suma.')
    elif i % 3 == 1:
        add('powers', f'Simplifica x^{b} × x^{c}.', f'x^{b+c}', f'x^{b*c}', f'2x^{b+c}',
            'Para multiplicar potencias con la misma base, suma los exponentes.', f'x^{b} × x^{c} = x^({b} + {c}) = x^{b+c}.',
            'En un producto de potencias se suman exponentes; se multiplican en una potencia de potencia.', 'Las bases no se suman: el coeficiente sigue siendo 1.')
    else:
        add('powers', f'Simplifica (x^{b})^{c}.', f'x^{b*c}', f'x^{b+c}', f'x^{c}',
            'En una potencia de potencia se multiplican los exponentes.', f'(x^{b})^{c} = x^({b} × {c}) = x^{b*c}.',
            'Sumar exponentes corresponde a un producto de potencias, no a este caso.', 'Debes conservar el efecto del exponente interior.')

    if i % 3 == 0:
        add('polynomials', f'Suma ({a}x + {b}) + ({c}x + 1).', f'{a+c}x + {b+1}', f'{a*c}x + {b+1}', f'{a+c}x + {b-1}',
            'Suma los coeficientes de x y luego las constantes.', f'({a} + {c})x + ({b} + 1) = {a+c}x + {b+1}.',
            'Los polinomios se suman; no se multiplican los coeficientes de x.', 'La constante 1 se suma, no se resta.')
    elif i % 3 == 1:
        add('polynomials', f'Desarrolla x(x + {a}).', f'x² + {a}x', f'x² + {a}', f'{a+1}x²',
            'Multiplica x por cada término del paréntesis.', f'x × x + x × {a} = x² + {a}x.',
            'El término constante también debe multiplicarse por x.', 'x² y x no son términos semejantes.')
    else:
        add('polynomials', f'Desarrolla (x + {a})(x + 1).', f'x² + {a+1}x + {a}', f'x² + {a}', f'x² + {a}x + {a+1}',
            'Multiplica los cuatro pares de términos y reúne los términos con x.', f'x² + x + {a}x + {a} = x² + {a+1}x + {a}.',
            'Faltan los dos productos cruzados, que producen términos con x.', 'El coeficiente de x es la suma de las constantes; el término independiente es su producto.')

    if i % 3 == 0:
        add('factoring', f'Factoriza {b}x + {b*a}.', f'{b}(x + {a})', f'{b}(x + {b*a})', f'x({b} + {b*a})',
            'Saca el factor numérico común y divide ambos términos por él.', f'{b}x ÷ {b} = x y {b*a} ÷ {b} = {a}; queda {b}(x + {a}).',
            'Después de sacar el factor común debes dividir también la constante.', 'El término constante no tiene x; x no es factor común de ambos términos.')
    elif i % 3 == 1:
        add('factoring', f'Factoriza x² − {a*a}.', f'(x − {a})(x + {a})', f'(x − {a})²', f'(x − {a*a})(x + {a*a})',
            'Reconoce una diferencia de cuadrados.', f'x² − {a}² = (x − {a})(x + {a}); los términos cruzados se cancelan.',
            'Un binomio al cuadrado añadiría un término con x.', 'La constante dentro de los factores es la raíz del cuadrado original.')
    else:
        add('factoring', f'Factoriza x² + {a+1}x + {a}.', f'(x + {a})(x + 1)', f'(x − {a})(x − 1)', f'(x + {a+1})(x + 1)',
            'Busca dos números cuyo producto sea la constante y cuya suma sea el coeficiente de x.', f'{a} × 1 = {a} y {a} + 1 = {a+1}; queda (x + {a})(x + 1).',
            'Dos signos negativos darían un coeficiente de x negativo.', 'Comprueba el producto de constantes: no coincide con el enunciado.')

    angle = 21 + 5*i
    if i % 3 == 0:
        add('geo_angles', f'¿Cuál es el suplemento de {angle}°?', f'{180-angle}°', f'{360-angle}°', f'{angle}°',
            'Los suplementarios suman 180°.', f'180° − {angle}° = {180-angle}°.',
            'Has completado una vuelta de 360°, no un ángulo llano.', 'El ángulo buscado debe sumar 180° con el dado, no repetirlo.')
    elif i % 3 == 1:
        small = 10 + 3*i
        add('geo_angles', f'¿Cuál es el complemento de {small}°?', f'{90-small}°', f'{180-small}°', f'{small}°',
            'Los complementarios completan 90°.', f'90° − {small}° = {90-small}°.',
            '180° se usa para suplementarios.', 'Repetir el ángulo no completa los 90° en este caso.')
    else:
        add('geo_angles', f'Dos rectas se cruzan y un ángulo mide {angle}°. ¿Cuánto mide su opuesto por el vértice?', f'{angle}°', f'{180-angle}°', f'{360-angle}°',
            'Los ángulos enfrentados en el cruce son iguales.', f'El opuesto por el vértice también mide {angle}°.',
            'Ese es el suplementario adyacente, no el opuesto.', 'Completar una vuelta no da el opuesto por el vértice.')

    first, second = 25+i, 40+i
    if i % 3 != 2:
        add('geo_triangles', f'Un triángulo tiene ángulos de {first}° y {second}°. ¿Cuánto mide el tercero?', f'{180-first-second}°', f'{first+second}°', f'{360-first-second}°',
            'Los tres ángulos interiores suman 180°.', f'180° − ({first}° + {second}°) = {180-first-second}°.',
            'Esa es la suma de los ángulos conocidos, no el faltante.', 'Un triángulo suma 180°, no 360°. ')
    else:
        leg = i+3
        add('geo_triangles', f'Un triángulo isósceles tiene dos ángulos iguales de {leg*5}°. ¿Cuánto mide el tercer ángulo?', f'{180-leg*10}°', f'{180-leg*5}°', f'{leg*5}°',
            'Resta a 180° los dos ángulos iguales.', f'180° − 2 × {leg*5}° = {180-leg*10}°.',
            'Falta restar el segundo ángulo igual.', 'Isósceles no implica que los tres ángulos sean iguales.')

    base, height = i+5, i%4+3
    if i % 3 == 0:
        add('geo_perimeter', f'Un rectángulo mide {base} cm por {height} cm. ¿Cuál es su perímetro?', f'{2*(base+height)} cm', f'{base+height} cm', f'{base*height} cm',
            'Suma dos bases y dos alturas.', f'P = 2 × ({base} + {height}) = {2*(base+height)} cm.',
            'Has contado solo dos lados; hay cuatro.', 'Multiplicar base por altura calcula el área, no el borde.')
    elif i % 3 == 1:
        add('geo_perimeter', f'Un triángulo tiene base {base} cm y altura perpendicular {height} cm. ¿Cuál es su área?', f'{frac(base*height,2)} cm²', f'{base*height} cm²', f'{base+height} cm²',
            'Multiplica base por altura y divide entre dos.', f'A = {base} × {height} ÷ 2 = {frac(base*height,2)} cm².',
            'Falta dividir entre dos para obtener el área del triángulo.', 'Sumar longitudes no calcula una superficie.')
    else:
        add('geo_perimeter', f'Un paralelogramo tiene base {base} cm y altura perpendicular {height} cm. ¿Cuál es su área?', f'{base*height} cm²', f'{frac(base*height,2)} cm²', f'{base+height} cm²',
            'Multiplica la base por la altura perpendicular.', f'A = {base} × {height} = {base*height} cm².',
            'Dividir entre dos corresponde al área de un triángulo.', 'La suma de medidas no da un área.')

    r = i+7
    if i % 3 == 0:
        add('geo_circle', f'Un círculo tiene radio de {r} cm. ¿Cuál es su diámetro?', f'{2*r} cm', f'{frac(r,2)} cm', f'{r} cm',
            'El diámetro mide dos radios.', f'd = 2 × {r} = {2*r} cm.',
            'Has dividido el radio; debe duplicarse.', 'El radio solo va del centro al borde, no atraviesa todo el círculo.')
    elif i % 3 == 1:
        add('geo_circle', f'Un círculo tiene radio de {r} cm. ¿Cuál es su área exacta?', f'{r*r}π cm²', f'{2*r}π cm²', f'{r}π cm²',
            'Usa A = πr².', f'A = π × {r}² = {r*r}π cm².',
            '2πr corresponde a la longitud de la circunferencia, no al área.', 'Falta elevar el radio al cuadrado.')
    else:
        add('geo_circle', f'Un círculo tiene diámetro de {r*2} cm. ¿Cuál es su circunferencia exacta?', f'{r*2}π cm', f'{r*4}π cm', f'{r}π cm',
            'Si conoces el diámetro, usa C = πd.', f'C = π × {r*2} = {r*2}π cm.',
            'El dato ya es el diámetro; no lo dupliques otra vez.', 'Has usado solo el radio con π; la fórmula requiere el diámetro.')

    scale = i+2
    p,q,h = 3*scale,4*scale,5*scale
    if i % 2 == 0:
        add('geo_pythagoras', f'Los catetos miden {p} y {q} cm. ¿Cuánto mide la hipotenusa?', f'{h} cm', f'{p+q} cm', f'{h*h} cm',
            'Suma los cuadrados de los catetos y toma la raíz positiva.', f'c² = {p}² + {q}² = {p*p} + {q*q} = {h*h}; c = {h} cm.',
            'La hipotenusa no es la suma directa de los catetos.', 'Ese resultado es el cuadrado de la hipotenusa; falta la raíz.')
    else:
        add('geo_pythagoras', f'La hipotenusa mide {h} cm y un cateto {p} cm. ¿Cuánto mide el otro?', f'{q} cm', f'{h-p} cm', f'{q*q} cm',
            'Resta los cuadrados y toma la raíz.', f'b² = {h}² − {p}² = {q*q}; b = {q} cm.',
            'Debes restar cuadrados, no longitudes directamente.', 'Falta tomar la raíz del cuadrado del cateto.')

    side = i+2
    if i % 3 == 0:
        add('geo_solids', f'Un cubo tiene lado {side} cm. ¿Cuál es su volumen?', f'{side**3} cm³', f'{side**2} cm³', f'{6*side**2} cm³',
            'Multiplica el lado tres veces.', f'V = {side}³ = {side**3} cm³.',
            'El cuadrado mide una cara; falta la tercera dimensión.', '6 × lado² es el área total, con unidades cuadradas, no el volumen.')
    elif i % 3 == 1:
        add('geo_solids', f'Una caja mide {side} × 3 × 4 cm. ¿Cuál es su volumen?', f'{side*12} cm³', f'{side+7} cm³', f'{side*3} cm³',
            'Multiplica largo, ancho y alto.', f'V = {side} × 3 × 4 = {side*12} cm³.',
            'Sumar las dimensiones no calcula espacio ocupado.', 'Falta multiplicar por la tercera dimensión.')
    else:
        add('geo_solids', f'Un cilindro tiene radio {side} cm y altura 2 cm. ¿Cuál es su volumen?', f'{side*side*2}π cm³', f'{side*2}π cm³', f'{side*side}π cm³',
            'Multiplica el área de la base πr² por la altura.', f'V = π × {side}² × 2 = {side*side*2}π cm³.',
            'Falta elevar el radio al cuadrado.', 'Falta multiplicar el área de la base por la altura.')

    left,right,top = [('A','B','C'),('D','E','F'),('P','Q','R')][i%3]
    vertex = left if i%2 else top
    horizontal,vertical,hypotenuse = left+right,right+top,left+top
    sides = [vertical,horizontal] if vertex == left else [horizontal,vertical]
    target = 'opuesto' if i%3 else 'adyacente'
    answer = sides[0 if target == 'opuesto' else 1]
    other = sides[1 if target == 'opuesto' else 0]
    if i%5==0:
        add('trig_sides', f'El triángulo {left+right+top} es rectángulo en {right}, con lados {p}, {q} y {h}. ¿Qué lado es la hipotenusa?', hypotenuse, horizontal, vertical,
            'La hipotenusa está frente al ángulo recto y no toca su vértice.', f'El lado {hypotenuse} está frente a {right}, donde está el ángulo de 90°.',
            f'{horizontal} toca el ángulo recto: es un cateto.', f'{vertical} toca el ángulo recto: es un cateto.')
    else:
      add('trig_sides', f'{left+right+top} es rectángulo en {right}, con {horizontal} = {p}, {vertical} = {q}, {hypotenuse} = {h}. Respecto a {vertex}, ¿cuál es el cateto {target}?', answer, other, hypotenuse,
        'Marca el ángulo de referencia: el opuesto está enfrente y el adyacente lo toca sin ser hipotenusa.',
        f'Respecto a {vertex}, el opuesto es {sides[0]} y el adyacente {sides[1]}. Se pide {target}: {answer}.',
        f'{other} es el otro cateto respecto a ese ángulo.', f'{hypotenuse} es la hipotenusa, frente al ángulo recto {right}.')

    # Different Pythagorean triples keep all rational answers exact.
    triples = [(5,12,13),(8,15,17),(7,24,25),(9,40,41),(20,21,29),(12,35,37)]
    o,adj,hyp = triples[i%6]
    multiplier = i//6+1
    o,adj,hyp = o*multiplier,adj*multiplier,hyp*multiplier
    ratio = ['sen','cos','tan'][i%3]
    numer,denom = {'sen':(o,hyp),'cos':(adj,hyp),'tan':(o,adj)}[ratio]
    good = frac(numer,denom)
    wrong = frac(denom,numer)
    third = frac(adj,hyp) if ratio=='sen' else frac(o,hyp) if ratio=='cos' else frac(o,hyp)
    add('trig_ratios', f'Opuesto = {o}, adyacente = {adj}, hipotenusa = {hyp}. Calcula {ratio} θ.', good, wrong, third,
        {'sen':'Seno = opuesto/hipotenusa.','cos':'Coseno = adyacente/hipotenusa.','tan':'Tangente = opuesto/adyacente.'}[ratio],
        f'{ratio} θ = {numer}/{denom} = {good}. La razón no lleva unidades.',
        'Has invertido el numerador y el denominador.', 'Esa razón usa una pareja de lados distinta a la que pide el enunciado.')

    degrees = [15,30,45,60,75,90,120,135,150,180,210,225,240,270,300,315,330][i]
    f=Fraction(degrees,180)
    rad = ('π' if f.numerator==1 else f'{f.numerator}π') + (f'/{f.denominator}' if f.denominator!=1 else '')
    if i%2==0:
        add('trig_radians', f'Convierte {degrees}° a radianes.', rad, f'{degrees}π', f'{degrees} rad',
            'Multiplica los grados por π/180 y simplifica.', f'{degrees} × π/180 = {rad} radianes.',
            'Falta dividir entre 180.', 'Cambiar la etiqueta no convierte la medida; usa la relación 180° = π radianes.')
    else:
        add('trig_radians', f'Convierte {rad} radianes a grados.', f'{degrees}°', f'{degrees*2}°', f'{degrees//2}°',
            'Multiplica los radianes por 180/π.', f'({rad}) × 180/π = {degrees}°; π se cancela.',
            'Has usado una vuelta de 360° donde la conversión usa 180°/π.', 'Has reducido la medida a la mitad; π radianes equivalen a 180°.')

    specials = [('sen',30,'1/2','√3/2','√2/2'),('cos',30,'√3/2','1/2','√2/2'),('tan',30,'√3/3','√3','1'),
                ('sen',45,'√2/2','1/2','√3/2'),('cos',45,'√2/2','1/2','1'),('tan',45,'1','√2/2','√3'),
                ('sen',60,'√3/2','1/2','√2/2'),('cos',60,'1/2','√3/2','√2/2'),('tan',60,'√3','√3/3','1')]
    if i<9:
        name,deg,correct,w1,w2=specials[i]
        add('trig_special', f'Calcula {name} {deg}° exactamente.', correct,w1,w2,
            'Usa los lados 1, 1, √2 para 45°; o 1, √3, 2 para 30° y 60°. Aplica la razón pedida.',
            f'{name} {deg}° = {correct}, obtenido con el triángulo especial y la razón correspondiente.',
            'Ese valor usa otro ángulo o intercambia seno y coseno.', 'Compara el ángulo y la pareja de lados; este valor no coincide con la razón pedida.')
    else:
        length=(i-8)*4
        deg = 30 if i%2 else 60
        add('trig_special', f'Un triángulo rectángulo tiene hipotenusa {length} cm. ¿Cuánto mide el cateto opuesto a {deg}°?', f'{length//2} cm' if deg==30 else f'{length//2}√3 cm',
            f'{length} cm', f'{length//2}√3 cm' if deg==30 else f'{length//2} cm',
            'Multiplica la hipotenusa por el seno del ángulo.',
            f'Opuesto = {length} × sen {deg}° = {length//2}'+(' cm.' if deg==30 else '√3 cm.'),
            'La hipotenusa es mayor que cualquiera de los catetos.', 'Ese es el cateto adyacente; aquí se pide el opuesto.')

    circle_cases = [
      ('¿Qué punto corresponde a 0° en el círculo unitario?', '(1, 0)', '(0, 1)', '(−1, 0)', 'Empieza en el eje x positivo.', 'cos 0° = 1 y sen 0° = 0.', 'Ese punto corresponde a 90°.', 'Ese punto corresponde a 180°.'),
      ('¿Qué punto corresponde a 180° en el círculo unitario?', '(−1, 0)', '(1, 0)', '(0, −1)', 'Media vuelta desde el eje x positivo llega a la izquierda.', 'cos 180° = −1 y sen 180° = 0.', 'Ese punto corresponde a 0°.', 'Ese punto corresponde a 270°.'),
      ('¿Qué punto corresponde a 270° en el círculo unitario?', '(0, −1)', '(0, 1)', '(−1, 0)', 'Tres cuartos de vuelta llegan abajo.', 'cos 270° = 0 y sen 270° = −1.', 'Ese punto corresponde a 90°.', 'Ese punto corresponde a 180°.'),
      ('¿Qué signos tienen seno y coseno en el tercer cuadrante?', 'Ambos negativos', 'Ambos positivos', 'Seno positivo y coseno negativo', 'Seno es y; coseno es x.', 'En el tercer cuadrante x < 0 e y < 0: ambos son negativos.', 'Ambos positivos corresponde al primer cuadrante.', 'Ese patrón corresponde al segundo cuadrante.'),
      ('¿Qué signos tienen seno y coseno en el cuarto cuadrante?', 'Seno negativo y coseno positivo', 'Ambos negativos', 'Seno positivo y coseno negativo', 'El cuarto cuadrante está a la derecha y abajo.', 'Allí x > 0 e y < 0: coseno positivo, seno negativo.', 'Ambos negativos corresponde al tercer cuadrante.', 'Ese patrón corresponde al segundo cuadrante.'),
      ('¿Está definida tan 90°?', 'No, porque cos 90° = 0', 'Sí, vale 0', 'Sí, vale 1', 'Tangente = seno/coseno, y no se puede dividir entre cero.', 'tan 90° no está definida: sen 90°/cos 90° = 1/0.', 'La división entre cero no produce cero.', 'Seno y coseno no son iguales a 90°; el denominador es cero.'),
      ('¿Cuánto vale sen² θ + cos² θ?', '1', '0', '2', 'Aplica la identidad del círculo unitario.', 'El radio es 1: x² + y² = 1², luego cos² θ + sen² θ = 1.', 'Una suma de ambos cuadrados en el círculo unitario no es cero.', 'No sumes dos valores máximos que no se alcanzan simultáneamente.'),
    ]
    if i<len(circle_cases):
        add('trig_circle', *circle_cases[i])
    else:
        o,adj,hyp=triples[(i-7)%6]
        known = 'sen' if i<12 else 'cos'
        unknown = 'cos' if known=='sen' else 'sen'
        n=o if known=='sen' else adj
        result=adj if known=='sen' else o
        add('trig_circle', f'θ es agudo y {known} θ = {n}/{hyp}. Halla {unknown} θ.', frac(result,hyp), frac(hyp-n,hyp), frac(result,n),
            'Usa sen² θ + cos² θ = 1 y toma la raíz positiva porque el ángulo es agudo.',
            f'{unknown}² θ = 1 − {n*n}/{hyp*hyp} = {result*result}/{hyp*hyp}; {unknown} θ = {frac(result,hyp)}.',
            'La identidad resta cuadrados, no las longitudes directamente.', 'La razón pedida usa la hipotenusa; dividir entre el otro cateto produce otra razón.')

    distance=i+7
    if i%3==0:
        add('trig_applications', f'Desde el suelo, a {distance} m horizontales de una torre, ves la cima a 45°. ¿Cuál es la altura?', f'{distance} m', f'{distance*2} m', f'{frac(distance,2)} m',
            'Altura = distancia horizontal × tan 45°; la tangente vale 1.', f'h = {distance} × 1 = {distance} m. La observación parte del suelo.',
            'No hay un factor dos: tan 45° vale 1.', 'La tangente de 45° no vale 1/2.')
    elif i%3==1:
        length=distance*2
        add('trig_applications', f'Una escalera de {length} m forma 30° con el suelo. ¿Qué altura alcanza?', f'{distance} m', f'{length} m', f'{distance}√3 m',
            'La escalera es la hipotenusa; la altura es el opuesto. Usa seno.', f'h = {length} × sen 30° = {length} × 1/2 = {distance} m.',
            'La longitud de la escalera es inclinada, no vertical.', 'Ese valor usa el coseno y calcula la distancia horizontal.')
    else:
        total=Fraction(distance*2+3,2)
        add('trig_applications', f'Tus ojos están a 1,5 m del suelo. A {distance} m horizontales de una torre, ves la cima a 45°. ¿Cuál es su altura total?', f'{str(float(total)).replace(".",",")} m', f'{distance} m', f'{str(float(total-3)).replace(".",",")} m',
            'Calcula la altura sobre tus ojos con la tangente y añade 1,5 m.', f'Sobre tus ojos: {distance} × tan 45° = {distance} m. Total: {distance} + 1,5 = {str(float(total)).replace(".",",")} m.',
            'Falta añadir la altura de los ojos.', 'La altura de los ojos se suma, no se resta.')

def dart(value):
    return json.dumps(value, ensure_ascii=False).replace('$', r'\$')

def symbol(stage):
    return 'extra' + ''.join(word.title() for word in stage.split('_'))

assert len(bank)==19
assert all(len(items)==17 for items in bank.values())
for filename in ['curriculum.dart','geometry_curriculum.dart','trigonometry_curriculum.dart']:
    source = (Path('lib/src')/filename).read_text(encoding='utf-8')
    matches = list(re.finditer(r"\bLesson\(\s*'([^']+)'", source))
    for index, match in enumerate(matches):
        end = matches[index+1].start() if index+1 < len(matches) else len(source)
        original = set(re.findall(r"Exercise\(\s*'([^']+)'", source[match.start():end]))
        assert not original.intersection(e[0] for e in bank[match.group(1)]), match.group(1)
out = ["import 'course_models.dart';", '', '// Append-only: original exercise indices 0–2 remain unchanged.', '']
for stage, items in bank.items():
    out.append(f'const {symbol(stage)} = <Exercise>[')
    for q,options,correct,hint,explanation,errors in items:
        out.append('  Exercise('+', '.join([dart(q), dart(options), str(correct), dart(hint), dart(explanation), dart(errors)])+'),')
    out.extend(['];',''])
Path('lib/src/practice_bank.dart').write_text('\n'.join(out), encoding='utf-8')

for filename in ['curriculum.dart','geometry_curriculum.dart','trigonometry_curriculum.dart']:
    path=Path('lib/src')/filename
    source=path.read_text(encoding='utf-8')
    for stage in bank:
        source=source.replace(f'...extra_{stage},',f'...{symbol(stage)},')
    insertions=[]
    for match in re.finditer(r"\bLesson\(\s*'([^']+)'",source):
        stage=match.group(1)
        if f'...{symbol(stage)},' in source: continue
        pos=source.index('(',match.start())+1
        paren,square=1,0
        closes=[]
        while paren:
            ch=source[pos]
            if ch in "'\"":
                quote=ch;pos+=1
                while source[pos]!=quote:
                    pos+=2 if source[pos]=='\\' else 1
            elif ch=='(': paren+=1
            elif ch==')': paren-=1
            elif ch=='[': square+=1
            elif ch==']':
                square-=1
                if square==0 and paren==1: closes.append(pos)
            pos+=1
        insertions.append((closes[-1],f'      ...{symbol(stage)},\n    '))
    for position,addition in reversed(insertions):
        source=source[:position]+addition+source[position:]
    if "import 'practice_bank.dart';" not in source:
        source="import 'practice_bank.dart';\n"+source
    path.write_text(source,encoding='utf-8')
print('Added 323 exercises across 19 stages. Original exercise IDs preserved.')
