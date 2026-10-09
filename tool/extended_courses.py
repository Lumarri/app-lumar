"""Author original progressive precalculus and linear-algebra banks (20/stage).

No external packages. Exact fractions, semantic validation witnesses and matrix
identities make regeneration reviewable. Curriculum references are in README.
"""
from pathlib import Path
from fractions import Fraction as F
from math import comb
import json

ROOT = Path(__file__).resolve().parents[1]
lessons = []
audit = []

def s(x):
    return str(x)

def vec(*xs):
    return '(' + ', '.join(map(s, xs)) + ')'

def matrix(rows):
    return '[' + '; '.join(', '.join(map(s, row)) for row in rows) + ']'

def mat(rows):
    return dict(kind='matrix', caption='Filas separadas por punto y coma en el enunciado.', values=rows)

def graph(a=1, b=0, c=0, kind='poly'):
    pts = [[x/4, a*(x/4)**2+b*x/4+c] for x in range(-16,17)]
    return dict(kind='function', caption='La gráfica corresponde a la función del enunciado; x es horizontal e y vertical.', values=[], series=[pts])

def vectors(rows):
    return dict(kind='vectors', caption='Vectores del enunciado desde el origen, en el mismo orden.', values=rows)

def stage(id, title, symbol, theory, formulas, goals, pitfall):
    item = dict(id=id, title=title, symbol=symbol, theory=theory, formulas=formulas,
                goals=goals, pitfall=pitfall, exercises=[])
    lessons.append(item)
    return item

def add(L, level, skill, q, c, w1, w2, hint, steps, e1, e2, visual=None, check=None):
    assert len(steps)>=3, q
    answers=list(map(s,[c,w1,w2]))
    assert len(set(answers))==3, (q,answers)
    assert q not in [e['question'] for e in L['exercises']], q
    i=len(L['exercises']); shift=i%3
    errors=['',e1,e2]
    if shift:
        answers=answers[-shift:]+answers[:-shift]; errors=errors[-shift:]+errors[:-shift]
    L['exercises'].append(dict(question=q,options=answers,correct=shift,hint=hint,
        explanation=' '.join(steps), errors=errors, steps=steps, difficulty=level,skill=skill,visual=visual))
    if check:
        audit.append(dict(lesson=L['id'],index=i,**check))

def number(L, level, skill, q, c, hint, steps, visual=None, check=None, wrong=None):
    c=F(c); w1,w2=map(F,wrong or (c+1,c-1))
    if w1==c: w1=c+2
    if w2==c or w2==w1: w2=c-2
    add(L,level,skill,q,c,w1,w2,hint,steps,
        f'El valor {w1} no satisface el procedimiento: {hint}',
        f'Revisa signos y condiciones: {steps[-1]}',visual,check)

# PRECALCULUS: each of five groups has four distinct, increasingly connected tasks.
L=stage('pre_functions','Funciones y dominio','f',
 'Una función asigna una salida a cada entrada de su dominio. Evalúa sustituyendo la entrada. En números reales una raíz cuadrada exige radicando ≥ 0 y una fracción exige denominador ≠ 0. El dominio de una composición debe cumplir ambas condiciones.',
 ['f(a): sustituir x por a','√u real ⇒ u ≥ 0','p/q definida ⇒ q ≠ 0'],
 ['Evaluar funciones','Determinar restricciones reales','Combinar restricciones'], 'No confundas dominio (entradas) con rango (salidas).')
for k in range(1,5):
    number(L,1,'Evaluación',f'Si f(x) = {k+1}x + {k}, calcula f({k+2}).',(k+1)*(k+2)+k,'Sustituye x y multiplica antes de sumar.',[f'x = {k+2}.',f'f({k+2}) = {k+1}·{k+2} + {k}.',f'La salida es {(k+1)*(k+2)+k}.'],graph(0,k+1,k),dict(kind='poly',coeff=[k,k+1],x=k+2))
    add(L,2,'Dominio racional',f'¿Cuál es el dominio real de f(x) = 1/(x − {k})?',f'ℝ excepto {k}',f'x ≥ {k}', 'Todo ℝ','El denominador nunca puede ser cero.',[f'x − {k} ≠ 0.',f'x ≠ {k}.',f'El dominio es ℝ excepto {k}.'],'Una fracción no impone esa desigualdad.','La división por cero está excluida.')
    add(L,3,'Dominio de raíz',f'¿Cuál es el dominio real de f(x) = √(x − {k+4})?',f'x ≥ {k+4}',f'x > {k+4}',f'x ≤ {k+4}','El radicando debe ser no negativo.',[f'x − {k+4} ≥ 0.',f'x ≥ {k+4}.','El cero sí está permitido en una raíz cuadrada.'],'La raíz de cero existe.','La desigualdad tiene el sentido contrario.')
    add(L,4,'Raíz en denominador',f'Determina el dominio real de f(x) = 1/√(x − {k+8}).',f'x > {k+8}',f'x ≥ {k+8}',f'x < {k+8}','Combina raíz real y denominador distinto de cero.',[f'x − {k+8} ≥ 0 para la raíz.',f'x − {k+8} ≠ 0 porque está debajo.',f'Juntas dan x > {k+8}.'],'La igualdad anula el denominador.','Produciría un radicando negativo.')
    add(L,5,'Dominio combinado',f'Determina el dominio real de f(x) = √(x − {k})/(x − {k+2}).',f'x ≥ {k}, x ≠ {k+2}',f'x > {k+2}',f'x ≥ {k}','Intersecta ambas restricciones; no elimines otros valores válidos.',[f'La raíz exige x ≥ {k}.',f'El denominador excluye x = {k+2}.',f'Dominio: x ≥ {k}, x ≠ {k+2}.'],'También hay entradas válidas menores que el polo.','Falta excluir la división por cero.')

L=stage('pre_transformations','Transformaciones y gráficas','↗',
 'En y = a(x − h)² + v el vértice es (h,v). El signo de a decide si abre arriba o abajo y |a| cambia la escala vertical. Las traslaciones horizontales están dentro del argumento y las verticales fuera.',
 ['y = a(x − h)² + v','Vértice: (h,v)','a < 0: reflexión vertical'],
 ['Leer traslaciones','Interpretar escala y reflexión','Relacionar forma y gráfica'], 'El signo dentro de x − h es opuesto al desplazamiento horizontal.')
for k in range(1,5):
    add(L,1,'Traslación',f'¿Cuánto se desplaza y = (x − {k})² hacia la derecha?',k,-k,k+1,'Compara con (x − h)².',[f'h = {k}.','El desplazamiento es positivo hacia la derecha.',f'Son {k} unidades.'],'El signo dentro del paréntesis se interpreta al revés.','No sumes una unidad al desplazamiento.',graph(1,-2*k,k*k))
    add(L,2,'Vértice',f'Halla el vértice de y = (x − {k})² + {k+1}.',vec(k,k+1),vec(-k,k+1),vec(k,-k-1),'Lee h y v.',[f'h = {k}.',f'v = {k+1}.',f'Vértice = {vec(k,k+1)}.'],'El desplazamiento horizontal tiene signo opuesto al del argumento.','El término exterior conserva su signo.')
    number(L,3,'Escala',f'Para y = {k+1}(x − {k})², ¿cuál es y si x = {k+2}?',4*(k+1),'Calcula primero la distancia al vértice.',[f'x − {k} = 2.','2² = 4.',f'y = {k+1}·4 = {4*(k+1)}.'],check=dict(kind='poly',coeff=[(k+1)*k*k,-2*k*(k+1),k+1],x=k+2))
    add(L,4,'Rango y reflexión',f'Determina el rango de y = −(x − {k})² + {k+3}.',f'y ≤ {k+3}',f'y ≥ {k+3}', 'Todo ℝ','El cuadrado es no negativo y se resta.', ['−(x − h)² ≤ 0.',f'El máximo vale {k+3} en x = {k}.',f'Rango: y ≤ {k+3}.'],'La parábola abre hacia abajo.','Tiene un máximo, no todas las salidas posibles.')
    number(L,5,'Diferencia de alturas',f'f(x) = −{k+1}(x − {k})² + {k+5}. Calcula f({k}) − f({k+2}).',4*(k+1),'Evalúa ambas alturas, manteniendo el signo de la reflexión.',[f'f({k}) = {k+5}.',f'f({k+2}) = {k+5} − {4*(k+1)}.',f'La diferencia es {4*(k+1)}.'])

L=stage('pre_composition','Composición e inversas','∘',
 'Componer es introducir la salida de una función en otra: (f∘g)(x) = f(g(x)). No suele ser conmutativo. Una inversa deshace la función; debe existir correspondencia uno a uno en el dominio elegido. Para x² hay que restringir el dominio antes de invertir.',
 ['(f∘g)(x) = f(g(x))','f^(-1)(f(x)) = x en el dominio','f(x)=ax+b ⇒ f^(-1)(y)=(y−b)/a, a≠0'],
 ['Componer funciones','Despejar inversas','Comprobar restricciones'], 'f^(-1) significa inversa funcional, no 1/f.')
for k in range(1,5):
    number(L,1,'Composición lineal',f'f(x) = {k+1}x; g(x) = x + {k}. Calcula f(g(2)).',(k+1)*(2+k),'Evalúa g primero.',[f'g(2) = {k+2}.',f'f(g(2)) = {k+1}·{k+2}.',f'El resultado es {(k+1)*(k+2)}.'])
    number(L,2,'Orden de composición',f'f(x) = x²; g(x) = x + {k}. Calcula g(f({k+1})).',(k+1)**2+k,'Ahora la función interior es f.',[f'f({k+1}) = {(k+1)**2}.',f'g(f({k+1})) = {(k+1)**2} + {k}.',f'Resultado: {(k+1)**2+k}.'])
    number(L,3,'Inversa lineal',f'f(x) = {k+2}x − {k}. Calcula f^(-1)({(k+2)*3-k}).',3,'Despeja x de y = ax − b.',[f'y + {k} = {k+2}x.',f'x = (y + {k})/{k+2}.',f'Para y = {(k+2)*3-k}, x = 3.'])
    add(L,4,'Inversa restringida',f'f(x) = (x − {k})², con x ≥ {k}. ¿Cuál es f^(-1)(y), y ≥ 0?',f'{k} + √y',f'{k} − √y',f'1/(y − {k})²','La rama debe respetar x ≥ h.',[f'x − {k} ≥ 0.','Al extraer raíz se toma la rama positiva.',f'x = {k} + √y.'],'Esa rama pertenece al dominio opuesto.','Una inversa no es un recíproco.')
    add(L,5,'Dominio de composición',f'f(u)=√u; g(x)={k+1}−x. Dominio real de (f∘g)(x):',f'x ≤ {k+1}',f'x ≥ {k+1}', 'Todo ℝ','Exige g(x) ≥ 0.',[f'{k+1} − x ≥ 0.',f'−x ≥ −{k+1}; al cambiar signo invierte la desigualdad.',f'x ≤ {k+1}.'],'Se invierte el sentido al multiplicar por −1.','La raíz impone una restricción.')

L=stage('pre_polynomials','Polinomios y raíces','P',
 'Los ceros anulan un polinomio. El teorema del factor relaciona P(r)=0 con el factor x−r. El residuo al dividir por x−r es P(r). La multiplicidad par toca el eje y la impar lo cruza. El grado y coeficiente principal controlan el comportamiento lejano.',
 ['Residuo por x−r: P(r)','P(r)=0 ⇔ (x−r) es factor','Suma de raíces en x²+bx+c: −b'],
 ['Calcular residuos','Leer ceros y multiplicidad','Conectar raíces y coeficientes'], 'El residuo es un valor de la función, no necesariamente una raíz.')
for k in range(1,5):
    number(L,1,'Teorema del residuo',f'¿Qué residuo deja P(x)=x²+{k}x+1 al dividir por x−2?',5+2*k,'Evalúa P(2).',['El residuo es P(2).',f'P(2)=4+{2*k}+1.',f'Residuo: {5+2*k}.'],check=dict(kind='poly',coeff=[1,k,1],x=2))
    number(L,2,'Raíz conocida',f'P(x)=(x−{k})(x+{k+2}). ¿Cuál es su raíz positiva?',k,'Un producto cero tiene un factor cero.',[f'x−{k}=0 da x={k}.',f'x+{k+2}=0 da x=−{k+2}.',f'La raíz positiva es {k}.'])
    add(L,3,'Multiplicidad',f'P(x)=(x−{k})²(x+1). ¿Qué hace la gráfica en x={k}?','Toca el eje sin cruzarlo','Cruza el eje','Tiene una asíntota vertical','Mira la paridad de la multiplicidad.', ['El factor está al cuadrado.','La multiplicidad es par.',f'En x={k} toca el eje sin cambiar de signo.'],'Una raíz de multiplicidad impar cruza.','Los polinomios no tienen polos.')
    number(L,4,'Relación de raíces',f'El polinomio x²−{2*k+3}x+{k*(k+3)} tiene una raíz {k}. ¿Cuál es la otra?',k+3,'Usa la suma de raíces.',[f'La suma es {2*k+3}.',f'Resta la raíz conocida: {2*k+3}−{k}.',f'La otra raíz es {k+3}; su producto es {k*(k+3)}.'],check=dict(kind='roots',coeff=[k*(k+3),-2*k-3,1],roots=[k,k+3]))
    number(L,5,'Residuo conectado',f'P(x)=(x−{k})(x+{k+1})(x−1). Residuo al dividir por x−({k+2}):',2*(2*k+3)*(k+1),'Evalúa el producto en el divisor lineal.',[f'El residuo es P({k+2}).',f'Los factores valen 2, {2*k+3}, {k+1}.',f'El producto es {2*(2*k+3)*(k+1)}.'])

L=stage('pre_rational','Funciones racionales','÷',
 'Una función racional conserva las exclusiones del denominador original. Un factor cancelado produce un hueco; uno no cancelado puede producir una asíntota vertical. Si los grados coinciden, la asíntota horizontal es el cociente de coeficientes principales. Los signos se estudian entre ceros y polos.',
 ['Denominador ≠ 0','Grados iguales ⇒ y = a_principal/b_principal','Cancelar no restaura entradas excluidas'],
 ['Distinguir huecos y polos','Calcular asíntotas','Resolver desigualdades racionales'], 'No confundas un hueco con una asíntota vertical.')
for k in range(1,5):
    number(L,1,'Evaluación racional',f'f(x)=(x+{k})/(x−1). Calcula f(3).',F(k+3,2),'Sustituye en numerador y denominador.',[f'Numerador: {k+3}.','Denominador: 2.',f'Valor: {F(k+3,2)}.'])
    number(L,2,'Asíntota vertical',f'f(x)=1/(x−{k+2}). ¿En qué x está su asíntota vertical?',k+2,'Anula el denominador no cancelado.',[f'x−{k+2}=0.',f'x={k+2}.','El numerador permanece distinto de cero.'])
    number(L,3,'Asíntota horizontal',f'f(x)=({k+1}x²+1)/(2x²+3). ¿Cuál es la altura de su asíntota horizontal?',F(k+1,2),'Ambos grados son dos.', ['Divide numerador y denominador por x².','Los términos 1/x² desaparecen cuando |x| crece.',f'El cociente principal es {F(k+1,2)}.'])
    add(L,4,'Hueco',f'f(x)=(x²−{k*k})/(x−{k}). ¿Qué discontinuidad hay en x={k}?','Hueco removible','Asíntota vertical','Ninguna: está definida','Factoriza antes de comparar.',[f'x²−{k*k}=(x−{k})(x+{k}).',f'Para x≠{k}, f(x)=x+{k}.',f'En x={k} queda un hueco del dominio original.'],'El factor del denominador se cancela.','La expresión original divide por cero.')
    add(L,5,'Tabla de signos',f'Resuelve (x−{k})/(x−{k+2}) > 0.',f'x < {k} o x > {k+2}',f'{k} < x < {k+2}',f'x ≤ {k} o x ≥ {k+2}','Numerador y denominador deben tener el mismo signo.',[f'Los puntos críticos son {k} y {k+2}.','Fuera de ellos los dos factores tienen el mismo signo.',f'Solución: x<{k} o x>{k+2}; ambos extremos se excluyen.'],'Entre los puntos los signos son contrarios.','La desigualdad es estricta y el polo nunca se incluye.')

L=stage('pre_exp_log','Modelos exponenciales y logarítmicos','eˣ',
 'Un modelo C·b^t representa crecimiento para b>1 y decaimiento para 0<b<1. Los logaritmos despejan exponentes. Exige argumentos positivos. Los productos producen sumas de logaritmos; una suma dentro del argumento no se separa.',
 ['C·b^t','log_b(b^t)=t','log_b(uv)=log_b u+log_b v para u,v>0'],
 ['Interpretar crecimiento','Despejar tiempo','Comprobar dominio logarítmico'], 'Al aplicar leyes conserva las restricciones originales.')
for k in range(1,5):
    number(L,1,'Crecimiento',f'Una población sigue P(t)={k+2}·2^t. Calcula P(3).',8*(k+2),'Se triplica el exponente, no la población.', ['2³=8.',f'Multiplica por {k+2}.',f'P(3)={8*(k+2)}.'])
    number(L,2,'Decaimiento',f'Una cantidad sigue C(t)={16*(k+1)}·(1/2)^t. Calcula C(3).',2*(k+1),'Eleva la razón completa.', ['(1/2)³=1/8.',f'{16*(k+1)}/8={2*(k+1)}.',f'C(3)={2*(k+1)}.'])
    number(L,3,'Tiempo exponencial',f'{k+1}·3^t = {(k+1)*3**(k+1)}. Encuentra t.',k+1,'Divide por el valor inicial y compara potencias.',[f'3^t={3**(k+1)}.',f'El lado derecho es 3^{k+1}.',f't={k+1}.'])
    number(L,4,'Ecuación logarítmica',f'log_2(x−{k})={k+1}. Encuentra x.',k+2**(k+1),'Convierte a forma exponencial y verifica el argumento.',[f'x−{k}=2^{k+1}.',f'x={k+2**(k+1)}.',f'El argumento {2**(k+1)} es positivo.'])
    number(L,5,'Producto de logaritmos',f'Con x>0, resuelve log_2(x)+log_2({2**k})={2*k}.',2**k,'Une la suma como un producto, con x positivo.',[f'log_2({2**k}x)={2*k}.',f'{2**k}x={2**(2*k)}.',f'x={2**k}>0.'])

L=stage('pre_unit_circle','Círculo unitario y radianes','π',
 'Un punto del círculo unitario tiene coordenadas (cos θ,sin θ). Una vuelta mide 2π radianes. Las coordenadas cambian de signo según el cuadrante. Los ángulos coterminales difieren en vueltas completas.',
 ['180° = π rad','(x,y)=(cos θ,sin θ)','cos²θ+sin²θ=1'],
 ['Convertir unidades','Leer ángulos notables','Usar signos y periodicidad'], 'El ángulo en radianes no lleva el símbolo de grados.')
for k in range(1,5):
    add(L,1,'Grados a radianes',f'Convierte {90*k}° a radianes.',f'{F(k,2)}π',f'{k}π',f'{2*k}π','Multiplica grados por π/180.',[f'{90*k}·π/180.',f'El coeficiente se reduce a {F(k,2)}.',f'Ángulo = {F(k,2)}π rad.'],'Una vuelta es 2π, no 4π.','Dividiste por una medida incorrecta.')
    number(L,2,'Periodicidad',f'Calcula sin({2*k}π+π/2).',1,'Quita k vueltas completas.',[f'{2*k}π equivale a {k} vueltas.','Queda sin(π/2).','Su valor es 1.'])
    number(L,3,'Cuadrante',f'Calcula cos({2*k}π+π).',-1,'El punto de π está a la izquierda del origen.', ['Quita las vueltas completas.','El punto es (−1,0).','El coseno es −1.'])
    number(L,4,'Identidad',f'En un ángulo agudo θ, cos θ={F(k, k+1)}. ¿Cuánto vale sin²θ?',1-F(k,k+1)**2,'Usa la identidad pitagórica.', ['sin²θ=1−cos²θ.',f'cos²θ={F(k,k+1)**2}.',f'sin²θ={1-F(k,k+1)**2}.'])
    add(L,5,'Valores notables',f'Calcula sin({2*k}π+5π/6).','1/2','−1/2','√3/2','Reduce vueltas y usa el ángulo de referencia.', ['Tras quitar vueltas queda 5π/6.','Está en el segundo cuadrante y su referencia es π/6.','El seno es positivo: 1/2.'],'En el segundo cuadrante el seno es positivo.','Ese es el seno de π/3, no de π/6.')

L=stage('pre_trig_analysis','Identidades y ecuaciones trigonométricas','sin',
 'Las funciones trigonométricas repiten sus valores. Para A sin(Bx), amplitud |A| y período 2π/|B|, con B≠0. Resolver una ecuación exige listar todas las soluciones del intervalo. tan θ=sin θ/cos θ solo donde cos θ≠0.',
 ['A sin(Bx): amplitud |A|, período 2π/|B|','sin²θ+cos²θ=1','tan θ=sin θ/cos θ'],
 ['Interpretar ondas','Resolver en intervalos','Aplicar identidades sin perder dominio'], 'Una ecuación periódica puede tener más de una respuesta.')
for k in range(1,5):
    number(L,1,'Amplitud',f'¿Cuál es la amplitud de y=−{k+1}sin(x)?',k+1,'La amplitud es un valor absoluto.', [f'A=−{k+1}.',f'|A|={k+1}.','La reflexión no cambia la amplitud.'])
    add(L,2,'Período',f'¿Cuál es el período de y=sin({k+1}x)?',f'{F(2,k+1)}π',f'{2*(k+1)}π',f'{F(1,k+1)}π','Divide 2π entre |B|.',[f'B={k+1}.',f'T=2π/{k+1}.',f'Período: {F(2,k+1)}π.'],'Aumentar B comprime el período.','El seno completa una vuelta en 2π, no π.')
    add(L,3,'Soluciones completas',f'Resuelve sin(x)=0 en [0,{k}π], incluidos los extremos.', ', '.join(f'{j}π' for j in range(k+1)), ', '.join(f'{j}π' for j in range(k)), 'Solo π/2','Los ceros son múltiplos enteros de π.', ['Escribe x=nπ.',f'Exige 0≤n≤{k}.',f'Incluye n=0 y n={k}.'],'Falta el extremo superior.','En π/2 el seno vale 1.')
    number(L,4,'Identidad racional',f'Si cos θ≠0 y tan θ={k}, calcula 1/cos²θ.',1+k*k,'Usa sec²θ=1+tan²θ.', ['Divide la identidad pitagórica por cos²θ.',f'1/cos²θ=1+{k}².',f'Resultado: {1+k*k}.'])
    add(L,5,'Raíces e intervalo',f'Resuelve 2cos²x−1=0 en [0,2π), después de trasladar la ecuación {k} vueltas completas.', 'π/4, 3π/4, 5π/4, 7π/4','π/4, 7π/4','π/2, 3π/2','Las vueltas completas no cambian la ecuación; considera ambos signos.', ['cos²x=1/2 implica cos x=±√2/2.','Busca los cuatro cuadrantes.','Son π/4, 3π/4, 5π/4 y 7π/4.'],'También existe el coseno negativo.','Esos ángulos hacen cos x=0, no cos²x=1/2.')

L=stage('pre_conics','Secciones cónicas','◯',
 'Una circunferencia cumple (x−h)²+(y−v)²=r². Una elipse usa dos denominadores positivos; sus semiejes son sus raíces. En una hipérbola horizontal x²/a²−y²/b²=1, c²=a²+b². En y²=4px la parábola tiene foco (p,0).',
 ['Circunferencia: (x−h)²+(y−v)²=r²','Elipse: c²=a²−b²','Hipérbola: c²=a²+b²','y²=4px: foco (p,0)'],
 ['Leer centros y medidas','Distinguir tipos de cónica','Calcular focos y vértices'], 'Los denominadores son cuadrados de semiejes, no los semiejes mismos.')
for k in range(1,5):
    number(L,1,'Radio',f'(x−{k})²+y²={(k+2)**2}. ¿Cuál es su radio?',k+2,'Toma la raíz de r².',[f'r²={(k+2)**2}.','El radio es no negativo.',f'r={k+2}.'])
    add(L,2,'Centro',f'(x−{k})²+(y+{k+1})²=25. ¿Cuál es el centro?',vec(k,-k-1),vec(-k,k+1),vec(k,k+1),'Compara con (x−h)²+(y−v)².',[f'h={k}.',f'v=−{k+1}.',f'Centro {vec(k,-k-1)}.'],'Los signos internos se invierten.','y+v equivale a y−(−v).')
    number(L,3,'Semieje mayor',f'x²/{(k+3)**2}+y²/{(k+1)**2}=1. Halla el semieje mayor.',k+3,'Compara las raíces de ambos denominadores.',[f'Los semiejes son {k+3} y {k+1}.',f'{k+3}>{k+1}.',f'El mayor es {k+3}.'])
    add(L,4,'Foco parabólico',f'y²={4*(k+1)}x. ¿Cuál es el foco?',vec(k+1,0),vec(0,k+1),vec(4*(k+1),0),'Compara con y²=4px.',[f'4p={4*(k+1)}.',f'p={k+1}.',f'Foco={vec(k+1,0)}.'],'La parábola abre sobre el eje x.','El coeficiente es 4p, no p.')
    number(L,5,'Distancia focal',f'x²/{(k+1)**2}−y²/{(k+2)**2}=1. Calcula c², donde los focos son (±c,0).',(k+1)**2+(k+2)**2,'En una hipérbola se suman los cuadrados.',[f'a²={(k+1)**2}, b²={(k+2)**2}.','c²=a²+b².',f'c²={(k+1)**2+(k+2)**2}.'])

L=stage('pre_parametric','Paramétricas y coordenadas polares','rθ',
 'Una curva paramétrica expresa x e y en términos de t. En coordenadas polares x=r cos θ, y=r sin θ. El radio negativo invierte la dirección; las coordenadas polares no son únicas. Para eliminar t, conserva las restricciones del parámetro.',
 ['x=r cos θ, y=r sin θ','r²=x²+y²','x=t, y=t² ⇒ y=x²'],
 ['Evaluar curvas paramétricas','Convertir coordenadas','Eliminar parámetros con restricciones'], 'No olvides el dominio de t al eliminar el parámetro.')
for k in range(1,5):
    add(L,1,'Evaluación paramétrica',f'x=2t, y=t+1. ¿Qué punto corresponde a t={k}?',vec(2*k,k+1),vec(k,k+1),vec(2*k,-k-1),'Sustituye el mismo t en las dos ecuaciones.',[f'x=2·{k}={2*k}.',f'y={k}+1={k+1}.',f'Punto {vec(2*k,k+1)}.'],'Falta multiplicar t por dos.','Se invirtieron las coordenadas.')
    add(L,2,'Polar a cartesiano',f'Convierte (r,θ)=({k+2},π) a coordenadas cartesianas.',vec(-k-2,0),vec(k+2,0),vec(0,k+2),'cos π=−1 y sin π=0.',[f'x=({k+2})(−1).',f'y=({k+2})·0.',f'Punto={vec(-k-2,0)}.'],'π apunta hacia x negativo.','El eje vertical corresponde a π/2.')
    number(L,3,'Radio cartesiano',f'Un punto tiene coordenadas ({3*k},{4*k}). ¿Cuál es su radio polar no negativo?',5*k,'Usa r²=x²+y².',[f'r²={9*k*k}+{16*k*k}.',f'r²={25*k*k}.',f'r={5*k}.'])
    add(L,4,'Eliminar parámetro',f'x=t+{k}, y=t², con t≥0. ¿Qué descripción cartesiana es correcta?',f'y=(x−{k})², x≥{k}',f'y=(x+{k})², x≥0',f'y=(x−{k})², todo x real','Despeja t y traslada su restricción.',[f't=x−{k}.',f'y=(x−{k})².',f't≥0 implica x≥{k}.'],'El despeje tiene signo negativo.','La parametrización solo cubre media parábola.')
    add(L,5,'Radio negativo',f'Convierte (r,θ)=(−{k+3},π/2) a coordenadas cartesianas.',vec(0,-k-3),vec(0,k+3),vec(-k-3,0),'Usa las fórmulas incluso si r es negativo.', ['cos(π/2)=0; sin(π/2)=1.',f'x=0; y=−{k+3}.',f'Punto={vec(0,-k-3)}.'],'El radio negativo invierte el sentido.','π/2 corresponde al eje y.')

L=stage('pre_sequences','Sucesiones y series','Σ',
 'Una sucesión aritmética tiene diferencia constante d; una geométrica tiene razón constante r. Las sumas finitas requieren contar bien los términos. La serie geométrica infinita converge únicamente cuando |r|<1.',
 ['a_n=a_1+(n−1)d','a_n=a_1·r^(n−1)','S_n=n(a_1+a_n)/2','S_∞=a_1/(1−r), |r|<1'],
 ['Hallar términos','Sumar series finitas','Comprobar convergencia'], 'El primer término corresponde a n=1, por eso aparece n−1.')
for k in range(1,5):
    number(L,1,'Término aritmético',f'a₁={k}, d=3. Halla a₅.',k+12,'Hay cuatro saltos entre a₁ y a₅.',[f'a₅={k}+(5−1)·3.',f'Los saltos suman 12.',f'a₅={k+12}.'])
    number(L,2,'Término geométrico',f'a₁={k+1}, r=2. Halla a₄.',8*(k+1),'Usa tres multiplicaciones por la razón.',[f'a₄={k+1}·2³.','2³=8.',f'a₄={8*(k+1)}.'])
    number(L,3,'Suma aritmética',f'Suma los primeros {k+3} términos de 1, 2, 3, …',F((k+3)*(k+4),2),'Empareja primero y último.',[f'n={k+3}.',f'S_n=n(n+1)/2={k+3}·{k+4}/2.',f'Suma={F((k+3)*(k+4),2)}.'])
    number(L,4,'Suma geométrica finita',f'Suma 1+2+4+…+2^{k+2}.',2**(k+3)-1,'Son k+3 términos, incluyendo 2⁰.', [f'n={k+3}, r=2.',f'S_n=(2^{k+3}−1)/(2−1).',f'Suma={2**(k+3)-1}.'])
    number(L,5,'Serie infinita',f'Suma la serie infinita {k+1}+{F(k+1,2)}+{F(k+1,4)}+…',2*(k+1),'La razón 1/2 tiene valor absoluto menor que uno.', ['La serie converge porque |r|=1/2<1.',f'S_∞=({k+1})/(1−1/2).',f'Suma={2*(k+1)}.'])

L=stage('pre_counting','Conteo y probabilidad','n!',
 'Si decisiones independientes tienen m y n opciones, hay mn posibilidades. En permutaciones importa el orden; en combinaciones no. Una probabilidad equiprobable es casos favorables/casos totales. Sin reemplazo los eventos cambian de probabilidad.',
 ['P(n,r)=n!/(n−r)!','C(n,r)=n!/[r!(n−r)!]','P(A)=favorables/totales'],
 ['Distinguir orden y selección','Contar sin duplicar','Calcular probabilidades condicionadas'], 'Sin reemplazo no repitas el denominador original en el segundo paso.')
for k in range(1,5):
    number(L,1,'Producto de opciones',f'Hay {k+2} camisetas y {k+3} chaquetas. ¿Cuántos conjuntos de una de cada hay?',(k+2)*(k+3),'Cada camiseta combina con todas las chaquetas.',[f'{k+2} opciones del primer tipo.',f'{k+3} por cada una.',f'Total={(k+2)*(k+3)}.'])
    number(L,2,'Permutaciones',f'Elige presidente y secretario distintos entre {k+3} personas. ¿Cuántas asignaciones hay?',(k+3)*(k+2),'Los cargos distintos hacen que el orden importe.',[f'{k+3} opciones de presidente.',f'{k+2} opciones restantes de secretario.',f'Total={(k+3)*(k+2)}.'])
    number(L,3,'Combinaciones',f'Elige un equipo de dos personas entre {k+4}, sin cargos. ¿Cuántos equipos hay?',comb(k+4,2),'Cada pareja aparece dos veces si cuentas por orden.',[f'C({k+4},2)=({k+4}·{k+3})/2.', 'Divide entre 2 porque el orden no importa.',f'Hay {comb(k+4,2)} equipos.'])
    number(L,4,'Equiprobabilidad',f'Una bolsa tiene {k} fichas violetas y {k+2} rosas. Probabilidad de sacar una violeta:',F(k,2*k+2),'Divide favorables entre el total.',[f'Favorables={k}.',f'Total={2*k+2}.',f'P={F(k,2*k+2)}.'])
    number(L,5,'Sin reemplazo',f'Hay {k+2} fichas violetas y 2 rosas. Probabilidad de sacar dos violetas sin reemplazo:',F((k+2)*(k+1),(k+4)*(k+3)),'En el segundo paso queda una ficha menos de cada total.',[f'Primera: {k+2}/{k+4}.',f'Segunda dada la primera: {k+1}/{k+3}.',f'Producto={F((k+2)*(k+1),(k+4)*(k+3))}.'])

L=stage('pre_complex','Números complejos','i',
 'Un complejo z=a+bi tiene parte real a e imaginaria b; i²=−1. Su conjugado es a−bi y |z|²=a²+b². Multiplicar distribuye los términos y reemplaza i² por −1. Dividir usa el conjugado para obtener denominador real.',
 ['i²=−1','z̅=a−bi','|z|²=a²+b²','z·z̅=|z|²'],
 ['Operar con i','Usar conjugados','Resolver cuadrados negativos'], 'La parte imaginaria es el coeficiente b, no el término bi.')
for k in range(1,5):
    number(L,1,'Potencias de i',f'Calcula i^{4*k+2}.',-1,'Las potencias de i se repiten cada cuatro.',[f'{4*k+2} deja residuo 2 al dividir por cuatro.','i²=−1.','El resultado es −1.'])
    add(L,2,'Conjugado',f'Conjugado de z={k}+{k+2}i:',f'{k}−{k+2}i',f'−{k}+{k+2}i',f'−{k}−{k+2}i','Cambia solo el signo de la parte imaginaria.',[f'La parte real sigue siendo {k}.',f'La imaginaria cambia de {k+2} a −{k+2}.',f'z̅={k}−{k+2}i.'],'La parte real no se cambia.','No se cambia todo el número de signo.')
    number(L,3,'Módulo al cuadrado',f'z={k}+{k+1}i. Calcula |z|².',k*k+(k+1)**2,'Suma cuadrados reales, no cuadrados complejos.',[f'a²={k*k}.',f'b²={(k+1)**2}.',f'|z|²={k*k+(k+1)**2}.'])
    add(L,4,'Producto complejo',f'Calcula ({k}+i)({k}−i).',k*k+1,k*k-1,f'{k*k}+2i','Usa diferencia de cuadrados y i²=−1.',[f'{k}²−i².',f'{k*k}−(−1).',f'Resultado real: {k*k+1}.'],'i² es −1.','Los términos imaginarios cruzados se cancelan.')
    add(L,5,'Raíces complejas',f'Resuelve x²+{(k+2)**2}=0 en los complejos.',f'x=±{k+2}i',f'x=±{k+2}', 'Sin soluciones complejas','El cuadrado debe ser negativo, usa i.',[f'x²=−{(k+2)**2}.',f'(±{k+2}i)²=−{(k+2)**2}.',f'Ambas raíces son ±{k+2}i.'],'Las raíces reales tendrían cuadrado positivo.','En los complejos sí existen ambas raíces.')

L=stage('pre_limits','Límites introductorios','lim',
 'Un límite describe valores cercanos, no necesariamente el valor exacto de la función. Los polinomios son continuos y permiten sustitución. En un cociente 0/0 factoriza antes de simplificar para x distinto del punto. Un límite bilateral existe si coinciden ambos laterales.',
 ['Continuidad ⇒ lim f(x)=f(a)','(x²−a²)/(x−a)=x+a para x≠a','Bilateral: límite izquierdo = derecho'],
 ['Calcular límites por continuidad','Resolver indeterminaciones removibles','Comparar límites laterales'], '0/0 es una indeterminación, no un resultado numérico.')
for k in range(1,5):
    number(L,1,'Continuidad',f'Calcula lim cuando x→{k} de (x²+2).',k*k+2,'Los polinomios permiten sustituir.',[f'x={k}.',f'{k}²+2={k*k}+2.',f'Límite={k*k+2}.'],graph(1,0,2),dict(kind='poly',coeff=[2,0,1],x=k))
    number(L,2,'Hueco removible',f'Calcula lim cuando x→{k+1} de (x²−{(k+1)**2})/(x−{k+1}).',2*(k+1),'Factoriza diferencia de cuadrados.',[f'Numerador=(x−{k+1})(x+{k+1}).',f'Para x≠{k+1}, queda x+{k+1}.',f'Límite={2*(k+1)}.'])
    number(L,3,'Límite en infinito',f'Calcula lim cuando x→+∞ de ({k+1}x²+3)/(2x²+1).',F(k+1,2),'Divide entre x².', ['Queda [(k+1)+3/x²]/[2+1/x²].','Los términos inversos tienden a cero.',f'Límite={F(k+1,2)}.'])
    add(L,4,'Límites laterales',f'f(x)=−1 si x<{k}, y f(x)=1 si x≥{k}. Límite bilateral en x={k}:','No existe','1','0','Compara ambos lados, no promedies.', ['Izquierda: −1.','Derecha: 1.','Son distintos; el límite bilateral no existe.'],'Ese es el valor y el límite derecho únicamente.','Los límites laterales no se promedian.')
    number(L,5,'Continuidad por partes',f'f(x)=(x²−{k*k})/(x−{k}) si x≠{k}; f({k})=C. ¿Qué C hace continua a f?',2*k,'El valor debe igualar el límite.',[f'Para x≠{k}, f(x)=x+{k}.',f'El límite en x={k} es {2*k}.',f'Exige C={2*k}.'])

L=stage('pre_modeling','Modelización y desafío final','★',
 'Modelizar consiste en definir variables, expresar restricciones y comprobar que una solución matemática tiene sentido. Usa vértices para extremos cuadráticos, funciones inversas para recuperar entradas, exponenciales para cambios relativos y sucesiones para etapas discretas.',
 ['Mínimo de (x−h)²+v: v','Costo total = fijo + variable·cantidad','Restricciones físicas: cantidades ≥ 0'],
 ['Elegir un modelo','Combinar funciones y restricciones','Comprobar respuestas en contexto'], 'Una solución algebraica puede quedar fuera del dominio físico.')
for k in range(1,5):
    number(L,1,'Costo lineal',f'Un cuaderno cuesta {k+2} y el envío {k+1}. Costo de 4 cuadernos:',4*(k+2)+k+1,'El envío se paga una vez.',[f'Cuadernos: 4·{k+2}.',f'Envío: {k+1}.',f'Total={4*(k+2)+k+1}.'])
    number(L,2,'Mínimo cuadrático',f'Un costo es C(x)=(x−{k+2})²+{k+4}, con x≥0. ¿Cuál es su mínimo?',k+4,'El cuadrado nunca es negativo.',[f'El vértice está en x={k+2}≥0.','Allí el cuadrado vale cero.',f'Costo mínimo={k+4}.'],graph(1,-2*(k+2),(k+2)**2+k+4))
    number(L,3,'Escala exponencial',f'Un cultivo inicia con {k+1} células y se duplica cada hora. ¿Cuántas hay a las 4 horas?',16*(k+1),'Modela con C(t)=C₀·2^t.', ['2⁴=16.',f'Inicial={k+1}.',f'Final={16*(k+1)}.'])
    number(L,4,'Ahorro progresivo',f'Ahorras {k} el día 1 y aumentas 2 cada día. Total ahorrado en 5 días:',5*k+20,'Suma una progresión aritmética.',[f'El quinto aporte es {k+8}.',f'S=5·({k}+{k+8})/2.',f'Total={5*k+20}.'])
    number(L,5,'Modelo y raíz válida',f'Un rectángulo tiene ancho x≥0 y largo x+{k}. Su área es {2*(k+2)*(k+4)}. ¿Cuál es el ancho?',k+4,'Forma x(x+k)=A y descarta la raíz negativa.',[f'x²+{k}x−{2*(k+2)*(k+4)}=0.',f'Factoriza: (x−{k+4})(x+{2*k+4})=0.',f'La raíz no negativa es x={k+4}.'],check=dict(kind='roots',coeff=[-2*(k+2)*(k+4),k,1],roots=[k+4,-2*k-4]))

L=stage('pre_inequalities','Desigualdades y valor absoluto','|x|',
 'Las desigualdades cambian de sentido al multiplicar o dividir por un número negativo. |x−h| mide distancia a h. Un valor absoluto menor que r describe un intervalo interior; mayor que r describe dos regiones exteriores. En desigualdades cuadráticas analiza los signos entre raíces.',
 ['|x−h|<r ⇔ h−r<x<h+r, r>0','|x−h|>r ⇔ x<h−r o x>h+r','Multiplicar por negativo invierte < y >'],
 ['Despejar desigualdades','Interpretar distancia','Construir intervalos de signos'], 'La unión de dos intervalos no es lo mismo que su intersección.')
for k in range(1,5):
    add(L,1,'Despeje',f'Resuelve x+{k}<{2*k+3}.',f'x<{k+3}',f'x>{k+3}',f'x<{3*k+3}','Resta k a ambos lados.',[f'x<{2*k+3}−{k}.',f'x<{k+3}.','Restar no cambia el sentido.'],'No dividiste por un negativo.','Debes restar, no sumar.')
    add(L,2,'Coeficiente negativo',f'Resuelve −2x>{2*k}.',f'x<−{k}',f'x>−{k}',f'x<{k}','Divide por −2 e invierte el sentido.',[f'x<{2*k}/(−2).',f'x<−{k}.','El cambio de sentido es obligatorio.'],'Falta invertir la desigualdad.','La división tiene resultado negativo.')
    add(L,3,'Intervalo interior',f'Resuelve |x−{k}|<2.',f'{k-2}<x<{k+2}',f'x<{k-2} o x>{k+2}',f'{k-2}≤x≤{k+2}','La distancia al centro es menor que dos.',[f'−2<x−{k}<2.',f'Suma {k} en ambos extremos.',f'{k-2}<x<{k+2}.'],'Esa es la región exterior.','La desigualdad no incluye los extremos.')
    add(L,4,'Intervalo exterior',f'Resuelve |x−{k}|≥3.',f'x≤{k-3} o x≥{k+3}',f'{k-3}≤x≤{k+3}',f'x<{k-3} o x>{k+3}','Distancia al menos tres: dos lados con frontera incluida.',[f'x−{k}≤−3 o x−{k}≥3.',f'Suma {k}.',f'x≤{k-3} o x≥{k+3}.'],'Se pide estar fuera del intervalo central.','Se incluyen las distancias exactamente tres.')
    add(L,5,'Signos cuadráticos',f'Resuelve (x−{k})(x−{k+3})≤0.',f'{k}≤x≤{k+3}',f'x≤{k} o x≥{k+3}',f'{k}<x<{k+3}','El producto es no positivo entre las raíces.',[f'Las raíces son {k} y {k+3}.','Entre ellas los factores tienen signos opuestos.',f'Incluye las raíces: {k}≤x≤{k+3}.'],'Fuera de las raíces el producto es positivo.','El símbolo ≤ incluye las raíces.')

# LINEAR ALGEBRA
L=stage('lin_vectors','Vectores y geometría','v',
 'Los vectores se suman componente a componente. El producto escalar u·v suma productos correspondientes; detecta ortogonalidad si vale cero. La norma cumple ‖v‖²=v·v. En tres dimensiones el producto vectorial es perpendicular a ambos vectores y su signo depende del orden.',
 ['u·v=Σuᵢvᵢ','‖v‖²=Σvᵢ²','u·v=0 ⇒ ortogonales','u×v=−v×u'],
 ['Operar con componentes','Medir y comparar direcciones','Calcular productos escalar y vectorial'], 'No confundas producto escalar, escalar por vector y producto vectorial.')
for k in range(1,5):
    add(L,1,'Suma de vectores',f'Suma u={vec(k,2)} y v={vec(1,k)}.',vec(k+1,k+2),vec(k,k+2),vec(k+1,-k-2),'Suma coordenadas del mismo eje.',[f'x: {k}+1={k+1}.',f'y: 2+{k}={k+2}.',f'u+v={vec(k+1,k+2)}.'],'Falta sumar la primera coordenada.','Las dos segundas componentes son positivas.',vectors([[k,2],[1,k]]),dict(kind='vsum',u=[k,2],v=[1,k],answer=[k+1,k+2]))
    number(L,2,'Producto escalar',f'u={vec(k,2)}, v={vec(3,k+1)}. Calcula u·v.',5*k+2,'Multiplica las parejas y suma.',[f'Primer producto={3*k}.',f'Segundo producto={2*k+2}.',f'u·v={5*k+2}.'],check=dict(kind='dot',u=[k,2],v=[3,k+1]))
    number(L,3,'Norma al cuadrado',f'v={vec(k,k+2,1)}. Calcula ‖v‖².',k*k+(k+2)**2+1,'Suma los cuadrados de las tres coordenadas.',[f'Cuadrados: {k*k}, {(k+2)**2}, 1.','La norma al cuadrado no lleva raíz.',f'‖v‖²={k*k+(k+2)**2+1}.'],check=dict(kind='dot',u=[k,k+2,1],v=[k,k+2,1]))
    add(L,4,'Vector ortogonal',f'¿Qué vector es ortogonal a u={vec(k,1)}?',vec(1,-k),vec(1,k+1),vec(k,1),'El producto escalar debe anularse.',[f'{k}·1+1·(−{k})=0.','El candidato no es el vector cero.',f'{vec(1,-k)} es perpendicular.'],'El producto es positivo.','Un vector no nulo no es ortogonal a sí mismo.',vectors([[k,1],[1,-k]]),dict(kind='orthogonal',u=[k,1],v=[1,-k]))
    add(L,5,'Producto vectorial',f'u={vec(k,0,0)}, v={vec(0,k+1,0)}. Calcula u×v.',vec(0,0,k*(k+1)),vec(0,0,-k*(k+1)),vec(k,k+1,0),'El eje x cruzado con y apunta a z positivo.', ['Las dos primeras componentes son cero.',f'La tercera es {k}·{k+1}.',f'u×v={vec(0,0,k*(k+1))}.'],'Ese signo corresponde al orden v×u.','Ese es parecido a sumar vectores, no cruzarlos.',check=dict(kind='cross',u=[k,0,0],v=[0,k+1,0],answer=[0,0,k*(k+1)]))

L=stage('lin_matrices','Matrices y operaciones','A',
 'Una matriz m×n tiene m filas y n columnas. Se suman solo matrices del mismo tamaño. Para AB el número de columnas de A debe coincidir con las filas de B; cada entrada es un producto fila por columna. La transpuesta intercambia filas y columnas.',
 ['(AB)ᵢⱼ=ΣAᵢₖBₖⱼ','A:m×n, B:n×p ⇒ AB:m×p','(Aᵀ)ᵢⱼ=Aⱼᵢ'],
 ['Leer dimensiones','Sumar y transponer','Multiplicar respetando el orden'], 'En general AB no es igual a BA.')
for k in range(1,5):
    add(L,1,'Dimensiones',f'Una matriz tiene {k+1} filas y {k+3} columnas. ¿Cuál es su tamaño?',f'{k+1}×{k+3}',f'{k+3}×{k+1}',f'{k+1}×{k+1}','Las filas se escriben primero.',[f'Filas={k+1}.',f'Columnas={k+3}.',f'Tamaño={k+1}×{k+3}.'],'El orden es filas por columnas.','No es necesariamente cuadrada.')
    A=[[k,2],[1,k+1]]; B=[[2,1],[k,3]]
    number(L,2,'Suma de entradas',f'A={matrix(A)}, B={matrix(B)}. Entrada (2,1) de A+B:',k+1,'Los índices empiezan en uno; suma la misma posición.',[f'A₂₁=1; B₂₁={k}.',f'1+{k}.',f'Entrada={k+1}.'],mat(A))
    number(L,3,'Transpuesta',f'A={matrix(A)}. Entrada (1,2) de Aᵀ:',1,'Intercambia los índices.', ['(Aᵀ)₁₂=A₂₁.','A₂₁=1.','Resultado=1.'],mat(A))
    number(L,4,'Producto matricial',f'A={matrix(A)}, B={matrix(B)}. Entrada (1,1) de AB:',4*k,'Multiplica primera fila por primera columna.',[f'Fila: ({k},2); columna: (2,{k}).',f'{k}·2+2·{k}.',f'Entrada={4*k}.'],mat(A),dict(kind='matentry',a=A,b=B,row=0,col=0))
    number(L,5,'No conmutatividad',f'A={matrix(A)}, B={matrix(B)}. Calcula (AB)₁₂−(BA)₁₂.',1,'Calcula ambas entradas en su propio orden.',[f'(AB)₁₂={k}+6.',f'(BA)₁₂=4+{k+1}={k+5}.', 'La diferencia es 1.'],check=dict(kind='matdiff',a=A,b=B,row=0,col=1))

L=stage('lin_systems','Sistemas lineales','x,y',
 'Un sistema Ax=b busca un vector que cumpla todas las ecuaciones. Dos rectas pueden cruzarse, ser paralelas distintas o coincidir. Sustitución y eliminación conservan el conjunto de soluciones. Un sistema triangular se resuelve de la última variable hacia la primera.',
 ['Ax=b','Única: rectas no paralelas','0=c≠0 ⇒ incompatible'],
 ['Resolver por sustitución','Clasificar soluciones','Comprobar un sistema de tres variables'], 'Una solución tiene que cumplir cada ecuación, no solo una.')
for k in range(1,5):
    number(L,1,'Sustitución',f'x+y={k+4}, y=2. Encuentra x.',k+2,'Sustituye el valor de y.',[f'x+2={k+4}.','Resta dos.',f'x={k+2}.'])
    add(L,2,'Eliminación',f'Resuelve x+y={2*k+3}, x−y=1.',vec(k+2,k+1),vec(k+1,k+2),vec(k+2,k+2),'Suma las ecuaciones para eliminar y.',[f'2x={2*k+4}; x={k+2}.',f'y={2*k+3}−{k+2}={k+1}.',f'(x,y)={vec(k+2,k+1)}.'],'El intercambio no satisface x−y=1.','La segunda ecuación exige diferencia uno.',check=dict(kind='system',a=[[1,1],[1,-1]],b=[2*k+3,1],answer=[k+2,k+1]))
    add(L,3,'Incompatibilidad',f'x+y={k}, 2x+2y={2*k+1}. Clasifica el sistema.','Sin solución','Una única solución','Infinitas soluciones','Duplica la primera ecuación y compara.',[f'Duplicar da 2x+2y={2*k}.',f'La segunda exige {2*k+1}.','La contradicción 0=1 implica sin solución.'],'Los lados izquierdos son dependientes.','Los términos independientes no coinciden.')
    add(L,4,'Dependencia',f'x+y={k+1}, 3x+3y={3*(k+1)}. Clasifica el sistema.','Infinitas soluciones','Sin solución','Una única solución','La segunda es múltiplo completo de la primera.', ['La segunda ecuación se obtiene multiplicando por tres.','Solo hay una condición independiente.',f'Queda una variable libre: y={k+1}−x.'],'No hay contradicción.','Falta una ecuación independiente.')
    add(L,5,'Sistema triangular',f'x+y+z={k+6}, y+z=5, z=2. Halla (x,y,z).',vec(k+1,3,2),vec(k+6,5,2),vec(k+1,2,3),'Haz sustitución hacia atrás.', ['z=2.','y=5−2=3.',f'x={k+6}−5={k+1}; solución {vec(k+1,3,2)}.'],'Esos son los términos independientes, no las variables.','La última ecuación exige z=2.',check=dict(kind='system',a=[[1,1,1],[0,1,1],[0,0,1]],b=[k+6,5,2],answer=[k+1,3,2]))

L=stage('lin_gauss','Eliminación de Gauss','R₂',
 'Las operaciones elementales intercambian filas, multiplican una fila por un escalar no nulo o suman un múltiplo de otra fila. En una matriz aumentada se transforma también la columna de b. Los pivotes identifican variables básicas; las columnas sin pivote representan variables libres.',
 ['Rᵢ←Rᵢ+cRⱼ','Pivote: primera entrada no nula','[0 … 0 | c], c≠0 ⇒ sin solución'],
 ['Aplicar operaciones elementales','Leer forma escalonada','Contar variables libres'], 'Al eliminar, también cambia la última columna de la matriz aumentada.')
for k in range(1,5):
    A=[[1,2,k],[2,5,2*k+1]]
    number(L,1,'Operación elemental',f'En {matrix(A)}, aplica R₂←R₂−2R₁. ¿Cuál es la primera entrada de R₂?',0,'Resta dos veces cada entrada de R₁.', ['Primera entrada: 2−2·1.','Se anula el primer coeficiente.','Resultado=0.'],mat(A))
    number(L,2,'Columna aumentada',f'Matriz aumentada {matrix(A)}. Tras R₂←R₂−2R₁, ¿qué queda en la última columna de R₂?',1,'Transforma también el término independiente.',[f'Última entrada: {2*k+1}−2·{k}.','La resta conserva la ecuación equivalente.','Resultado=1.'],mat(A))
    add(L,3,'Sustitución escalonada',f'Forma escalonada [1,2 | {k+2}; 0,1 | 1]. Halla (x,y).',vec(k,1),vec(k+2,1),vec(k,2),'La segunda fila da y directamente.', ['y=1.',f'x+2={k+2}.',f'x={k}; solución {vec(k,1)}.'],'Falta restar 2y.','El pivote de la segunda fila da y=1.')
    number(L,4,'Variables libres',f'Una matriz escalonada con {k+3} columnas de variables tiene 2 pivotes. ¿Cuántas variables libres hay?',k+1,'Resta pivotes de columnas de variables.',[f'n={k+3}, rango=2.','Variables libres=n−rango.',f'Son {k+1}.'])
    add(L,5,'Rangos aumentados',f'Un sistema de {k+2} variables tiene rango(A)=2 y rango([A|b])=3. ¿Qué ocurre?','No hay solución',f'Hay {k} variables libres','Hay solución única','Compara ambos rangos antes de contar libertad.', ['La columna b introduce un pivote adicional.','El rango aumentado excede al de coeficientes.','Existe una fila contradictoria; el sistema es incompatible.'],'Las variables libres solo describen soluciones si el sistema es compatible.','Los rangos distintos impiden cualquier solución.')

L=stage('lin_determinants','Determinantes','det',
 'El determinante de una matriz cuadrada detecta invertibilidad y mide cambio de volumen con signo. Para 2×2 es ad−bc. En una triangular se multiplican entradas diagonales. Intercambiar filas cambia el signo; multiplicar una fila por c multiplica el determinante por c.',
 ['det([[a,b],[c,d]])=ad−bc','Triangular: producto diagonal','det(AB)=det(A)det(B)'],
 ['Calcular determinantes','Usar operaciones de filas','Relacionar área e invertibilidad'], 'det(cA)=cⁿdet(A) en n×n: no es lo mismo que escalar una sola fila.')
for k in range(1,5):
    A=[[k+1,1],[2,3]]
    number(L,1,'Determinante 2×2',f'Calcula det {matrix(A)}.',3*k+1,'Resta los productos de diagonales.',[f'ad={3*(k+1)}.', 'bc=2.',f'det={3*k+1}.'],mat(A),dict(kind='det',a=A))
    number(L,2,'Triangular 3×3',f'Calcula det [1,{k},2; 0,2,1; 0,0,{k+1}].',2*(k+1),'Los elementos bajo la diagonal son cero.', ['La matriz es triangular.',f'det=1·2·{k+1}.',f'det={2*(k+1)}.'],check=dict(kind='det',a=[[1,k,2],[0,2,1],[0,0,k+1]]))
    number(L,3,'Intercambio de filas',f'det(A)={k+3}. B se obtiene intercambiando dos filas de A. Calcula det(B).',-k-3,'Un intercambio invierte la orientación.', ['El intercambio multiplica el determinante por −1.',f'det(B)=−({k+3}).',f'Resultado={-k-3}.'])
    number(L,4,'Escala de matriz',f'A es 2×2 y det(A)={k+1}. Calcula det(3A).',9*(k+1),'Cada una de las dos filas se multiplica por tres.', ['El factor es 3²=9.',f'det(3A)=9·{k+1}.',f'Resultado={9*(k+1)}.'])
    number(L,5,'Producto e inversa',f'det(A)={k+1}, det(B)=2. Calcula det(A^(-1)B).',F(2,k+1),'El determinante de la inversa es el recíproco.',[f'det(A^(-1))=1/{k+1}.','Multiplica por det(B)=2.',f'Resultado={F(2,k+1)}.'])

L=stage('lin_inverse','Inversas y sistemas matriciales','A^(-1)',
 'Una inversa satisface AA^(-1)=A^(-1)A=I y existe solo para matrices cuadradas de rango completo. Para 2×2 intercambia a,d, cambia signos de b,c y divide por ad−bc. Si A es invertible, Ax=b tiene x=A^(-1)b. La inversa de un producto invierte el orden.',
 ['A^(-1)=(1/det A)[d,−b;−c,a]','Ax=b ⇒ x=A^(-1)b','(AB)^(-1)=B^(-1)A^(-1)'],
 ['Reconocer invertibilidad','Construir una inversa','Resolver y comprobar Ax=b'], 'No inviertas entradas individualmente salvo el caso diagonal.')
for k in range(1,5):
    number(L,1,'Inversa diagonal',f'A=[{k+1},0;0,2]. Entrada (1,1) de A^(-1):',F(1,k+1),'Las entradas diagonales no nulas se invierten.',[f'A₁₁={k+1}.',f'(A^(-1))₁₁=1/{k+1}.','El producto de esas entradas es uno.'],mat([[k+1,0],[0,2]]))
    A=[[1,k],[0,1]]; B=[[1,-k],[0,1]]
    add(L,2,'Inversa triangular',f'¿Cuál es la inversa de {matrix(A)}?',matrix(B),matrix(A),matrix([[1,0],[-k,1]]),'Busca una matriz que anule el término fuera de diagonal.', ['El determinante es 1.',f'Cambia {k} por −{k} en la posición (1,2).',f'AA^(-1)=I con {matrix(B)}.'],'Multiplicarlas duplicaría el término superior.','Eso es una transpuesta con signo, no su inversa.',mat(A),dict(kind='inverse',a=A,answer=B))
    add(L,3,'Matriz singular',f'A=[1,{k};2,{2*k}]. ¿Tiene inversa?','No, su determinante es cero','Sí, det(A)=1','Sí, toda matriz cuadrada tiene inversa','La segunda fila es dos veces la primera.', [f'det(A)=1·{2*k}−{k}·2=0.','Las filas son dependientes.','No existe inversa.'],'Los productos diagonales se cancelan.','Ser cuadrada es necesario pero no suficiente.')
    add(L,4,'Sistema con inversa',f'A=[1,{k};0,1], b={vec(k+3,1)}. Encuentra A^(-1)b.',vec(3,1),vec(k+3,1),vec(3,-1),'Multiplica la inversa por el vector columna.',[f'A^(-1)=[1,−{k};0,1].',f'x₁={k+3}−{k}=3; x₂=1.',f'x={vec(3,1)}.'],'Falta restar el múltiplo de la segunda entrada.','La segunda entrada conserva el signo.',check=dict(kind='system',a=A,b=[k+3,1],answer=[3,1]))
    add(L,5,'Orden de inversas',f'A y B son invertibles {k+1}×{k+1}. ¿Cuál es (AB)^(-1)?','B^(-1)A^(-1)','A^(-1)B^(-1)','AB','Verifica cancelando factores contiguos.', ['AB·B^(-1)A^(-1)=A·I·A^(-1).','El producto es I.', 'La inversa es B^(-1)A^(-1).'],'En general las matrices no conmutan.','Un producto no coincide en general con su propia inversa.')

L=stage('lin_spaces','Espacios y subespacios','V',
 'Un subespacio contiene el vector cero y es cerrado para suma y multiplicación escalar. El núcleo de un mapa lineal y el espacio generado por vectores son subespacios. Las restricciones homogéneas definen subespacios; una traslación generalmente deja de serlo.',
 ['0∈V','u,v∈V ⇒ u+v∈V','c∈ℝ,u∈V ⇒ cu∈V','ker A={x:Ax=0}'],
 ['Comprobar cierre','Distinguir conjuntos afines','Leer espacios generados'], 'Contener cero es necesario, pero por sí solo no prueba que sea subespacio.')
for k in range(1,5):
    add(L,1,'Vector cero',f'¿Es x+y={k} un subespacio de ℝ²?','No: no contiene cero','Sí: es una recta','Sí: contiene muchos vectores','Prueba el origen.',[f'En (0,0), x+y=0≠{k}.','El cero queda fuera.','No es subespacio.'],'Una recta debe pasar por el origen para ser subespacio.','El número de puntos no basta.')
    add(L,2,'Restricción homogénea',f'V={{(x,y): y={k}x}}. ¿Es subespacio de ℝ²?','Sí: ecuación homogénea','No: contiene cero','No: falta una dimensión','Comprueba suma y escala.', ['El cero satisface y=kx.','Suma y escala preservan la relación.', 'Sí es una recta vectorial y un subespacio.'],'Contener cero favorece, no impide, ser subespacio.','Un subespacio puede tener dimensión menor.')
    add(L,3,'Cierre por escala',f'V={{(x,y): x≥{k}}}. ¿Qué impide que sea subespacio?','No es cerrado bajo todos los escalares','Tiene dimensión dos','Tiene demasiados puntos','Prueba el escalar cero o uno negativo.',[f'El vector ({k},0) pertenece a V.','Multiplicarlo por cero da (0,0), fuera de V.','Falla el cierre por escala.'],'La dimensión no es la causa.','Un subespacio suele tener infinitos puntos.')
    number(L,4,'Dimensión del núcleo',f'A=[1,{k};0,0]. ¿Qué dimensión tiene ker(A)?',1,'Hay una ecuación independiente en dos variables.',[f'x+{k}y=0.',f'x=−{k}y; y es libre.','El núcleo tiene dimensión 1.'],check=dict(kind='nullity',a=[[1,k],[0,0]]))
    number(L,5,'Espacio generado',f'¿Cuál es la dimensión de span{{{vec(k,1,0)}, {vec(2*k,2,0)}, {vec(0,0,1)}}}?',2,'El segundo vector es múltiplo del primero.', ['Descarta el duplicado de dirección.','El tercer vector añade una dirección independiente.','La dimensión es 2.'],check=dict(kind='rank',a=[[k,2*k,0],[1,2,0],[0,0,1]]))

L=stage('lin_basis','Independencia y bases','B',
 'Vectores independientes no admiten una combinación cero con coeficientes no todos nulos. Una base es independiente y genera el espacio; todas las bases tienen igual cantidad de vectores. Las coordenadas dependen de la base y se encuentran resolviendo Bc=v.',
 ['Bc=v: coordenadas c','Independencia: Σcᵢvᵢ=0 ⇒ todos cᵢ=0','Base de ℝⁿ: n vectores independientes'],
 ['Detectar dependencia','Reconocer bases','Calcular coordenadas en otra base'], 'Las coordenadas en una base nueva no son necesariamente las coordenadas estándar.')
for k in range(1,5):
    add(L,1,'Dependencia',f'u={vec(1,k)}, v={vec(2,2*k)}. ¿Son independientes?','No: v=2u','Sí: tienen distinto tamaño','Sí: ninguno es cero','Busca un múltiplo común.', ['La primera componente se duplica.','La segunda también.', 'v=2u: son dependientes.'],'Un cambio de magnitud no crea una dirección nueva.','Dos vectores no nulos aún pueden ser dependientes.')
    add(L,2,'Base en el plano',f'¿Forman base de ℝ² los vectores {vec(1,k)} y {vec(0,1)}?','Sí: el determinante es 1','No: el determinante es 0','No: hay solo dos vectores','Colócalos como columnas.',[f'B=[1,0;{k},1].','det(B)=1.','Dos vectores independientes forman base de ℝ².'],'La matriz es triangular con diagonal uno.','Dos es exactamente la dimensión.')
    number(L,3,'Tamaño de base',f'¿Cuántos vectores tiene cualquier base de ℝ^{k+2}?',k+2,'La cantidad coincide con la dimensión.',[f'La dimensión es {k+2}.','Una base genera sin redundancia.',f'Tiene {k+2} vectores.'])
    add(L,4,'Coordenadas',f'B=({vec(1,0)}, {vec(1,1)}). Coordenadas de v={vec(k+3,2)} en B:',vec(k+1,2),vec(k+3,2),vec(k+1,-2),'Escribe c₁(1,0)+c₂(1,1)=v.', ['La segunda componente da c₂=2.',f'c₁+2={k+3}; c₁={k+1}.',f'Coordenadas={vec(k+1,2)}.'],'Esas son las coordenadas estándar.','El orden de las coordenadas sigue el de la base.',check=dict(kind='system',a=[[1,1],[0,1]],b=[k+3,2],answer=[k+1,2]))
    number(L,5,'Dependencia con tres vectores',f'En ℝ², u={vec(1,k)}, v={vec(0,1)}, w={vec(1,k+2)}. Si w=u+cv, halla c.',2,'Compara la segunda componente.',[f'{k}+c={k+2}.','Resta k.', 'c=2; w no añade una dirección nueva.'])

L=stage('lin_rank','Rango, núcleo y dimensión','rank',
 'El rango es la dimensión del espacio columna o fila. La nulidad es la dimensión del núcleo. Para una matriz m×n, rango+nulidad=n. La imagen tiene dimensión igual al rango. Ax=b es compatible exactamente cuando b pertenece a la imagen.',
 ['rango(A)+nulidad(A)=n','dim(im A)=rango(A)','rango(A)≤min(m,n)'],
 ['Contar pivotes','Aplicar rango-nulidad','Relacionar imagen y compatibilidad'], 'En rango-nulidad usa el número de columnas, no el de filas.')
for k in range(1,5):
    number(L,1,'Rango diagonal',f'A=diag({k},2,0). Halla su rango.',2,'Cuenta entradas diagonales no nulas.',[f'{k} y 2 son no nulos.','El tercer pivote falta.','Rango=2.'],check=dict(kind='rank',a=[[k,0,0],[0,2,0],[0,0,0]]))
    number(L,2,'Rango-nulidad',f'A tiene {k+4} columnas y rango 3. Halla su nulidad.',k+1,'Resta el rango de la cantidad de entradas del dominio.',[f'n={k+4}.','Nulidad=n−rango.',f'Nulidad={k+1}.'])
    number(L,3,'Dimensión de imagen',f'T:ℝ^{k+4}→ℝ^{k+3} tiene nulidad 2. Dimensión de su imagen:',k+2,'La imagen tiene dimensión igual al rango.',[f'Rango={k+4}−2.',f'Rango={k+2}.',f'dim(im T)={k+2}.'])
    add(L,4,'Vector del núcleo',f'A=[1,{k};0,0]. ¿Qué vector no nulo está en ker(A)?',vec(-k,1),vec(k,1),vec(1,0),'Comprueba Ax=0.',[f'−{k}+{k}·1=0.','La segunda fila da cero.',f'{vec(-k,1)} pertenece al núcleo.'],'La primera fila daría 2k, no cero.','La primera fila daría 1.',mat([[1,k],[0,0]]),dict(kind='system',a=[[1,k],[0,0]],b=[0,0],answer=[-k,1]))
    add(L,5,'Sobreyectividad',f'A es {k+1}×{k+3} y tiene rango {k+1}. ¿Ax=b es compatible para todo b∈ℝ^{k+1}?','Sí: la imagen es todo el codominio','No: sobran columnas','Solo si b=0','El rango coincide con la dimensión del codominio.',[f'dim(im A)={k+1}.',f'El codominio también tiene dimensión {k+1}.','La imagen lo cubre, así que todo b tiene preimagen.'],'Las columnas extra generan libertad, no incompatibilidad.','También admite cualquier b del codominio.')

L=stage('lin_transformations','Transformaciones lineales','T',
 'Un mapa es lineal si preserva suma y escala; por ello T(0)=0. Su matriz estándar tiene por columnas T(e₁),T(e₂),… . La composición S∘T se representa ST en ese orden. Rotaciones, reflexiones y proyecciones por el origen son lineales; traslaciones no nulas no lo son.',
 ['T(u+v)=T(u)+T(v)','T(cu)=cT(u)','Matriz: [T(e₁) … T(eₙ)]'],
 ['Reconocer linealidad','Construir matrices','Componer transformaciones'], 'La transformación que actúa primero aparece a la derecha en el producto.')
for k in range(1,5):
    add(L,1,'Linealidad',f'T(x,y)=(x+{k},y). ¿Es lineal?','No: T(0)≠0','Sí: tiene x e y','Sí: es una traslación','Todo mapa lineal envía cero a cero.',[f'T(0,0)=({k},0).','Ese vector no es cero.','La traslación no es lineal.'],'La expresión debe preservar también el origen.','Una traslación no nula falla la linealidad.')
    add(L,2,'Imagen de vector',f'T(x,y)=({k}x,2y). Calcula T(2,3).',vec(2*k,6),vec(k,2),vec(2,3),'Aplica cada regla a su coordenada.',[f'Primera salida={k}·2={2*k}.','Segunda salida=2·3=6.',f'T(2,3)={vec(2*k,6)}.'],'Esos son coeficientes, no la salida.','No aplicaste la transformación.')
    add(L,3,'Matriz estándar',f'T(e₁)={vec(1,k)} y T(e₂)={vec(k+3,0)}. Matriz de T:',matrix([[1,k+3],[k,0]]),matrix([[1,k],[k+3,0]]),matrix([[k+3,1],[0,k]]),'Coloca las imágenes como columnas.', [f'Primera columna: (1,{k}).',f'Segunda columna: ({k+3},0).',f'A={matrix([[1,k+3],[k,0]])}.'],'Escribiste las imágenes como filas.','Cambiaste el orden de la base.')
    add(L,4,'Rotación',f'R es rotación antihoraria de π/2. Halla R({k},2).',vec(-2,k),vec(2,-k),vec(k,2),'La regla es (x,y)→(−y,x).', ['La primera salida es −2.',f'La segunda es {k}.',f'R(v)={vec(-2,k)}.'],'Esa es la rotación horaria.','Ese es el vector original, sin rotación.',vectors([[k,2],[-2,k]]))
    add(L,5,'Composición',f'T(x,y)=(x+{k}y,y); S(x,y)=(2x,y). Calcula (S∘T)(1,2).',vec(2+4*k,2),vec(2+2*k,2),vec(1+2*k,2),'T actúa primero y S después.',[f'T(1,2)=({1+2*k},2).',f'S duplica la primera coordenada: {2+4*k}.',f'Salida={vec(2+4*k,2)}.'],'Ese resultado corresponde al orden opuesto.','Falta aplicar S.')

L=stage('lin_orthogonality','Ortogonalidad y Gram–Schmidt','⊥',
 'Vectores ortogonales tienen producto escalar cero. Una base ortonormal añade norma uno. La proyección sobre u no nulo es [(v·u)/(u·u)]u. Gram–Schmidt resta proyecciones para construir direcciones ortogonales; después se normalizan.',
 ['proj_u(v)=[(v·u)/(u·u)]u','q=u/‖u‖','Gram–Schmidt: v₂−proj_v₁(v₂)'],
 ['Comprobar ortogonalidad','Proyectar y normalizar','Construir una base ortonormal'], 'No dividas solo por ‖u‖ en la fórmula de proyección sobre un vector no unitario.')
for k in range(1,5):
    number(L,1,'Ortogonalidad',f'u={vec(k,1)}, v={vec(1,-k)}. Calcula u·v.',0,'Suma ambos productos con su signo.',[f'{k}·1={k}.',f'1·(−{k})=−{k}.','La suma es cero.'],check=dict(kind='dot',u=[k,1],v=[1,-k]))
    add(L,2,'Normalización',f'Normaliza v={vec(3*k,4*k)} con k={k}>0.',vec('3/5','4/5'),vec('4/5','3/5'),vec(3,4),'Divide por la norma 5k.',[f'‖v‖={5*k}.',f'Cada coordenada se divide por {5*k}.',f'q={vec("3/5","4/5")}.'],'No intercambies componentes.','Ese vector tiene norma 5, no uno.')
    add(L,3,'Proyección',f'Proyecta v={vec(k+2,3)} sobre u={vec(2,0)}.',vec(k+2,0),vec(2*(k+2),0),vec(0,3),'Divide v·u por u·u y multiplica u.',[f'v·u={2*(k+2)}; u·u=4.',f'Coeficiente={F(k+2,2)}.',f'Proyección={vec(k+2,0)}.'],'Falta dividir correctamente por u·u.','Ese es el componente perpendicular.',vectors([[k+2,3],[2,0]]))
    add(L,4,'Residuo perpendicular',f'v={vec(k,4)}, u={vec(1,0)}. Halla v−proj_u(v).',vec(0,4),vec(k,0),vec(k,4),'Resta el componente horizontal.',[f'proj_u(v)=({k},0).',f'v−proj=(0,4).','El residuo es ortogonal a u.'],'Ese es el componente proyectado.','Falta restar la proyección.')
    add(L,5,'Gram–Schmidt',f'v₁={vec(1,0)}, v₂={vec(k,2)}. Segundo vector unitario de Gram–Schmidt:',vec(0,1),vec(k,2),vec(0,2),'Resta primero la proyección y después normaliza.',[f'proj_v₁(v₂)=({k},0).','u₂=(0,2), de norma 2.','q₂=(0,1).'],'No quitaste la proyección.','Es ortogonal, pero aún no unitario.')

L=stage('lin_least_squares','Mínimos cuadrados','≈',
 'Un sistema incompatible puede aproximarse minimizando ‖Ax−b‖². Las ecuaciones normales son AᵀAx=Aᵀb; cuando las columnas de A son independientes, AᵀA es invertible. El residuo b−Ax es ortogonal a cada columna de A. Para ajustar una constante se usa la media.',
 ['AᵀAx=Aᵀb','Aᵀ(b−Ax)=0','Constante óptima: media de datos'],
 ['Minimizar un error','Resolver ecuaciones normales','Interpretar residuos y ajustes'], 'La aproximación no hace exacta cada observación: equilibra el error total.')
for k in range(1,5):
    number(L,1,'Ajuste constante',f'Ajusta una constante c a los datos {k}, {k+2}, {k+4} por mínimos cuadrados.',k+2,'El mejor valor constante es la media.',[f'Suma={3*k+6}.','Hay tres observaciones.',f'c={k+2}.'])
    number(L,2,'Suma de residuos',f'Para los datos {k}, {k+2}, {k+4} y su media {k+2}, suma los residuos bᵢ−c.',0,'Los residuos respecto a la media se compensan.', ['Residuos: −2,0,2.','Suma=−2+0+2.','El total es cero.'])
    number(L,3,'Error mínimo',f'Ajusta una constante a {k}, {k+2}, {k+4}. Suma mínima de errores cuadrados:',8,'Evalúa errores en la media.',[f'La media es {k+2}.','Los cuadrados son 4,0,4.','Error total mínimo=8.'])
    number(L,4,'Ecuación normal',f'A es columna (1,2), b=({k}, {2*k+1}). Halla x de mínimos cuadrados.',F(5*k+2,5),'Calcula AᵀA y Aᵀb.', ['AᵀA=1+4=5.',f'Aᵀb={k}+2·{2*k+1}={5*k+2}.',f'x={F(5*k+2,5)}.'],check=dict(kind='leastsquares',a=[[1],[2]],b=[k,2*k+1],answer=[str(F(5*k+2,5))]))
    add(L,5,'Ajuste de recta',f'Ajusta y=mx+c a (0,{k}), (1,{k+1}), (2,{k+4}). Halla (m,c).',vec(2,F(3*k-1,3)),vec(1,k),vec(2,k),'Resuelve las dos ecuaciones normales con columnas x y 1.',[f'5m+3c={3*k+9}; 3m+3c={3*k+5}.','Restar da 2m=4; m=2.',f'c={F(3*k-1,3)}; el residuo es ortogonal a ambas columnas.'],'Esa recta no minimiza el error de los tres puntos.','Ese intercepto no cumple las ecuaciones normales.',check=dict(kind='leastsquares',a=[[0,1],[1,1],[2,1]],b=[k,k+1,k+4],answer=['2',str(F(3*k-1,3))]))

L=stage('lin_eigen','Autovalores y autovectores','λ',
 'Un autovector v≠0 cumple Av=λv: la transformación conserva su dirección. Los autovalores son las raíces de det(A−λI)=0. Para una triangular son las entradas diagonales. La suma de autovalores es la traza y su producto el determinante, contando multiplicidades.',
 ['Av=λv, v≠0','det(A−λI)=0','Σλᵢ=tr(A), Πλᵢ=det(A)'],
 ['Reconocer pares propios','Calcular espectro','Relacionar traza y determinante'], 'El vector cero cumple la igualdad pero nunca se considera autovector.')
for k in range(1,5):
    number(L,1,'Autovalor diagonal',f'A=diag({k+1}, {k+3}). Autovalor asociado a v=(1,0):',k+1,'Multiplica A por v.',[f'Av=({k+1},0).',f'Av=({k+1})v.',f'λ={k+1}.'],mat([[k+1,0],[0,k+3]]),dict(kind='eigen',a=[[k+1,0],[0,k+3]],v=[1,0],value=k+1))
    add(L,2,'Espectro triangular',f'A=[{k},{k+5};0,{k+2}]. ¿Cuáles son sus autovalores?',vec(k,k+2),vec(k+5,k+2),vec(k,k+5),'La ecuación característica de una triangular usa su diagonal.',[f'det(A−λI)=({k}−λ)({k+2}−λ).','Iguala cada factor a cero.',f'Autovalores: {vec(k,k+2)}.'],'La entrada fuera de la diagonal no es un autovalor aquí.','Debes leer ambas entradas diagonales.')
    add(L,3,'Autovector',f'A=[{k},1;0,{k+1}]. ¿Qué vector es autovector para λ={k+1}?',vec(1,1),vec(1,0),vec(0,1),'Resuelve (A−λI)v=0.', ['La primera ecuación es −v₁+v₂=0.','Elige v₁=v₂=1.',f'A(1,1)=({k+1})·(1,1).'],'Ese vector corresponde al otro autovalor.','La primera componente de Av no sería cero.',check=dict(kind='eigen',a=[[k,1],[0,k+1]],v=[1,1],value=k+1))
    number(L,4,'Traza',f'Una matriz 2×2 tiene traza {2*k+5} y un autovalor {k+1}. Halla el otro.',k+4,'La suma de ambos autovalores es la traza.',[f'λ₁+λ₂={2*k+5}.',f'λ₂={2*k+5}−{k+1}.',f'λ₂={k+4}.'])
    number(L,5,'Determinante y potencia',f'A tiene autovalores {k+1} y 2. Calcula det(A³).',(2*(k+1))**3,'Primero calcula det(A), luego usa det(A³)=det(A)³.',[f'det(A)=2·{k+1}={2*(k+1)}.',f'det(A³)=({2*(k+1)})³.',f'Resultado={(2*(k+1))**3}.'])

L=stage('lin_diagonalization','Diagonalización y aplicaciones','PDP',
 'A=PDP^(-1) si las columnas de P forman una base de autovectores. Tener n autovalores distintos garantiza diagonalización en el cuerpo que los contiene; repetir uno no la garantiza. Las potencias se calculan como A^m=PD^mP^(-1). Toda matriz simétrica real posee una base ortonormal de autovectores.',
 ['A=PDP^(-1)','A^m=PD^mP^(-1)','Simétrica real ⇒ diagonalización ortogonal'],
 ['Comprobar una base propia','Detectar matrices defectivas','Usar potencias en modelos discretos'], 'Multiplicidad algebraica repetida requiere suficientes autovectores independientes.')
for k in range(1,5):
    number(L,1,'Potencia diagonal',f'A=diag({k+1},2). Entrada (1,1) de A³:',(k+1)**3,'Eleva cada entrada diagonal.',[f'A₁₁={k+1}.','La matriz es diagonal.',f'(A³)₁₁={(k+1)**3}.'])
    add(L,2,'Autovalores distintos',f'A real 2×2 tiene autovalores {k} y {k+1}. ¿Es diagonalizable sobre ℝ?','Sí: hay dos autovalores reales distintos','No: falta una tercera raíz','No: siempre necesita ser simétrica','Los autovectores de autovalores distintos son independientes.', ['Existen dos autovectores reales.','Son linealmente independientes.', 'Forman base de ℝ² y diagonalizan A.'],'La dimensión es dos.','La simetría es suficiente, pero no necesaria.')
    add(L,3,'Matriz defectiva',f'A=[{k},1;0,{k}]. ¿Es diagonalizable?','No: el espacio propio tiene dimensión 1','Sí: ya es triangular','Sí: el autovalor se repite dos veces','Calcula ker(A−kI).', ['A−kI=[0,1;0,0].','Impone v₂=0 y deja solo una dirección.', 'Faltan dos autovectores independientes.'],'Triangular no equivale a diagonalizable.','La multiplicidad algebraica no asegura una base propia.')
    number(L,4,'Dinámica propia',f'Av={k+1}v, v≠0. ¿Qué escalar cumple A⁴v=cv?',(k+1)**4,'Aplica la misma transformación cuatro veces.',[f'A²v=({k+1})²v.',f'A⁴v=({k+1})⁴v.',f'c={(k+1)**4}.'])
    number(L,5,'Potencia de matriz no diagonal',f'A=[{k+1},1;0,{k+2}]. Calcula la entrada (1,2) de A³.',(k+2)**3-(k+1)**3,'La suma geométrica da (b³−a³)/(b−a) y aquí b−a=1.',[f'a={k+1}, b={k+2}.','La entrada es a²+ab+b².',f'Equivale a b³−a³={(k+2)**3-(k+1)**3}.'],mat([[k+1,1],[0,k+2]]),dict(kind='matpower',a=[[k+1,1],[0,k+2]],power=3,row=0,col=1))

def J(v): return json.dumps(v,ensure_ascii=False)
def visual_code(v):
    if not v:return 'null'
    values=[[float(x) for x in r] for r in v['values']]
    return f'StudyVisual({J(v["kind"])}, {J(v["caption"])}, {J(values)}, series: {J(v.get("series",[]))})'

order=['pre_functions','pre_inequalities','pre_transformations','pre_composition','pre_polynomials','pre_rational','pre_exp_log','pre_unit_circle','pre_trig_analysis','pre_conics','pre_parametric','pre_sequences','pre_counting','pre_complex','pre_limits','pre_modeling']
order += [l['id'] for l in lessons if l['id'].startswith('lin_')]
lessons.sort(key=lambda l:order.index(l['id']))
lines=["import 'course_models.dart';",'', '// Original lessons generated by tool/extended_courses.py.']
for prefix,var in [('pre_','precalculusLessons'),('lin_','linearAlgebraLessons')]:
    lines.append(f'const {var} = <Lesson>[')
    for L in [l for l in lessons if l['id'].startswith(prefix)]:
        assert len(L['exercises'])==20,L['id']
        indexed=list(enumerate(L['exercises']));indexed.sort(key=lambda e:e[1]['difficulty'])
        remap={old:new for new,(old,e) in enumerate(indexed)}
        for a in audit:
            if a['lesson']==L['id']:a['index']=remap[a['index']]
        exercises=[e for old,e in indexed]; L['exercises']=exercises
        prerequisite=['Álgebra, potencias y ecuaciones'] if prefix=='pre_' else ['Álgebra y sistemas de ecuaciones']
        if prefix=='pre_' and L['id']!='pre_functions':prerequisite.append('Etapas anteriores de precálculo')
        if prefix=='lin_' and L['id']!='lin_vectors':prerequisite.append('Etapas anteriores de álgebra lineal')
        lines.append(f'Lesson({J(L["id"])}, {J(L["title"])}, "De guiado a desafío", {J(L["symbol"])}, {J(L["theory"])}, {J(exercises[0]["question"])}, {J(exercises[0]["steps"])}, [')
        for e in exercises:
            fields=[e[k] for k in ['question','options','correct','hint','explanation','errors']]
            lines.append('Exercise('+', '.join(J(v) for v in fields)+f', steps: {J(e["steps"])}, difficulty: {e["difficulty"]}, skill: {J(e["skill"])}, visual: {visual_code(e["visual"])}),')
        lines.append(f'], guide: StudyGuide({J(prerequisite)}, {J(L["goals"])}, {J(L["formulas"])}, {J(L["pitfall"])})),')
    lines.append('];')
(ROOT/'lib/src/extended_curriculum.dart').write_text('\n'.join(lines)+'\n',encoding='utf-8')
(ROOT/'tool/extended_course_audit.json').write_text(J(audit)+'\n',encoding='utf-8')
(ROOT/'tool/extended_course_metadata.json').write_text(J([{k:v for k,v in l.items() if k!='exercises'} for l in lessons])+'\n',encoding='utf-8')
print(f'{len(lessons)} stages, {sum(len(l["exercises"]) for l in lessons)} exercises, {len(audit)} independent witnesses')
