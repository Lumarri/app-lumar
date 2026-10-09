"""Build three fixed, progressive 50-question courses with worked solutions."""
from pathlib import Path
from fractions import Fraction
import json

courses = {}
def add(course,q,c,w1,w2,hint,steps,e1,e2):
    items=courses.setdefault(course,[])
    options=list(map(str,[c,w1,w2]));errors=['',e1,e2]
    assert len(set(options))==3,(q,options)
    assert q not in [e[0] for e in items],q
    shift=len(items)%3
    if shift:
        options=options[-shift:]+options[:-shift];errors=errors[-shift:]+errors[:-shift]
    items.append((q,options,shift,hint,' '.join(steps),errors,steps))
def poly(a,b,c):
    out='x²' if a==1 else f'{a}x²'
    if b: out+=(' + ' if b>0 else ' − ')+(str(abs(b)) if abs(b)!=1 else '')+'x'
    if c: out+=(' + ' if c>0 else ' − ')+str(abs(c))
    return out+' = 0'
def roots(a,b):
    lo,hi=sorted([a,b])
    return f'x = {lo}' if lo==hi else f'x = {lo} o x = {hi}'

for i in range(10):
    b=[2,3,5,10,4][i%5];n=i//5+2;value=b**n
    add('logarithms',f'Calcula log_{b}({value}).',n,value,n+1,
        'Busca el exponente al que debes elevar la base para obtener el argumento.',
        [f'Por definición, log_{b}({value}) = y significa {b}^y = {value}.',f'{b}^{n} = {value}.',f'Por tanto, y = {n}.'],
        'El logaritmo devuelve un exponente, no su argumento.','Ese exponente produce la base multiplicada una vez de más; comprueba la potencia.')
for i in range(10):
    b=[2,3,5,10,4][i%5];n=i//5+3
    add('logarithms',f'Resuelve log_{b}(x) = {n}.',b**n,b*n,b+n,
        'Convierte la ecuación logarítmica en una potencia.',
        [f'La definición transforma log_{b}(x) = {n} en x = {b}^{n}.',f'Calcula la potencia: {b}^{n} = {b**n}.',f'x = {b**n} es positivo y cumple la ecuación.'],
        'La forma exponencial eleva la base; no multiplica base por exponente.','No se suman la base y el exponente.')
for i in range(10):
    b=i+2;p=i+4;q=i%3+2
    add('logarithms',f'Si log_{b}(A) = {p} y log_{b}(B) = {q}, con A y B positivos, calcula log_{b}(AB).',p+q,p*q,p-q,
        'El logaritmo de un producto es la suma de los logaritmos, para argumentos positivos.',
        [f'Aplica log_{b}(AB) = log_{b}(A) + log_{b}(B).',f'Sustituye los valores: {p} + {q}.',f'El resultado es {p+q}.'],
        'Los logaritmos se suman para un producto; no se multiplican.','Restar logaritmos corresponde a un cociente, no a un producto.')
for i in range(10):
    b=i+2;p=i+4;q=i%3+1
    add('logarithms',f'Si log_{b}(A) = {p} y log_{b}(B) = {q}, con A y B positivos, calcula log_{b}(A/B).',p-q,p+q,Fraction(p,q),
        'El logaritmo de un cociente resta los logaritmos.',
        [f'Aplica log_{b}(A/B) = log_{b}(A) − log_{b}(B).',f'Sustituye: {p} − {q}.',f'El resultado es {p-q}.'],
        'Sumar logaritmos corresponde a un producto.','El logaritmo de un cociente no es el cociente de los logaritmos.')
for i in range(10):
    if i<5:
        b=i+2;p=i+2;n=i+3
        add('logarithms',f'Si log_{b}(A) = {p} y A > 0, calcula log_{b}(A^{n}).',p*n,p+n,p,
            'El exponente del argumento pasa a multiplicar el logaritmo.',
            [f'log_{b}(A^{n}) = {n} × log_{b}(A).',f'Sustituye: {n} × {p}.',f'El resultado es {n*p}.'],
            'La regla de la potencia multiplica, no suma.','Falta aplicar el exponente al valor del logaritmo.')
    elif i<8:
        b=i-3
        add('logarithms',f'¿Cuál es el dominio real de log_{b}(x − {i})?',f'x > {i}',f'x ≥ {i}',f'x < {i}',
            'El argumento debe ser estrictamente positivo.',
            [f'Exige x − {i} > 0.',f'Suma {i} a ambos lados: x > {i}.','El argumento cero o negativo no tiene logaritmo real.'],
            'La igualdad permitiría un argumento cero, que no está definido.','Ese intervalo haría el argumento negativo.')
    else:
        b=i-5
        add('logarithms',f'Calcula log_{b}(1/{b}).',-1,1,b,
            'Un exponente negativo produce el recíproco de la base.',
            [f'{b}^(-1) = 1/{b}.',f'log_{b}(1/{b}) pregunta por ese exponente.','El resultado es −1.'],
            'El exponente 1 produce la base, no su recíproco.','El resultado debe ser un exponente; la base no es la respuesta.')

for i in range(10):
    b=i+2;n=2+i%2;negative=i%3==0;base=-b if negative else b;value=base**n
    wrongSign = abs(value) if value<0 else -value
    wrongProduct = base*n if base*n != wrongSign else base*(n+1)
    add('advanced_powers',f'Calcula ({base})^{n}.',value,wrongProduct,wrongSign,
        'El exponente cuenta factores iguales. Con base negativa, revisa la paridad.',
        [f'Escribe {n} factores iguales a {base}.',f'Multiplica: ({base})^{n} = {value}.',f'El exponente es {"par: el signo final es positivo" if negative and n%2==0 else "impar: el signo final es negativo" if negative else "aplicado a una base positiva"}.'],
        'Elevar a una potencia no significa multiplicar la base por el exponente.','Revisa los signos de los factores y si el exponente es par o impar.')
for i in range(10):
    p=i+2;q=i%4+1
    add('advanced_powers',f'Simplifica a^{p} × a^{q}.',f'a^{p+q}',f'a^{p*q}',f'a^{p-q}',
        'En el producto de potencias de la misma base se suman exponentes.',
        [f'La base sigue siendo a.',f'Suma los exponentes: {p} + {q} = {p+q}.',f'Resultado: a^{p+q}.'],
        'Multiplicar exponentes corresponde a una potencia de potencia.','Restar exponentes corresponde a un cociente, no a este producto.')
for i in range(10):
    p=i+5;q=i%3+2
    add('advanced_powers',f'Simplifica a^{p} / a^{q}, con a ≠ 0.',f'a^{p-q}',f'a^{p+q}',f'a^{p*q}',
        'En el cociente de potencias de la misma base se restan exponentes.',
        ['La condición a ≠ 0 permite dividir.',f'Resta los exponentes: {p} − {q} = {p-q}.',f'Resultado: a^{p-q}.'],
        'Sumar exponentes corresponde a un producto.','El cociente no multiplica los exponentes.')
for i in range(10):
    if i<5:
        b=i+2;n=i%3+1
        add('advanced_powers',f'Calcula {b}^(-{n}).',f'1/{b**n}',-b**n,b**n,
            'El exponente negativo indica el recíproco, no un signo negativo delante.',
            [f'{b}^(-{n}) = 1/{b}^{n}.',f'{b}^{n} = {b**n}.',f'Resultado: 1/{b**n}.'],
            'Un exponente negativo no convierte en negativa una base positiva.','Falta tomar el recíproco de la potencia.')
    else:
        p=i+2;q=i-3
        add('advanced_powers',f'Simplifica (a^{p})^{q}.',f'a^{p*q}',f'a^{p+q}',f'a^{p}',
            'Una potencia de potencia multiplica los exponentes.',
            [f'Aplica (a^m)^n = a^(mn).',f'{p} × {q} = {p*q}.',f'Resultado: a^{p*q}.'],
            'Sumar exponentes corresponde a otro tipo de operación.','Falta aplicar el exponente exterior.')
for i in range(10):
    k=i+2;degree=2 if i%2==0 else 3;power=3 if degree==2 else 2
    base=k**degree;value=k**power
    add('advanced_powers',f'Calcula {base}^({power}/{degree}), usando la raíz real positiva.',value,k,base*power,
        'El denominador indica la raíz y el numerador la potencia.',
        [f'La raíz de índice {degree} de {base} es {k}.',f'Eleva esa raíz a {power}: {k}^{power} = {value}.',f'Así, {base}^({power}/{degree}) = {value}.'],
        'Has tomado la raíz, pero falta elevarla al numerador.','El numerador no multiplica directamente a la base.')

for i in range(10):
    n=i+2
    add('quadratics',f'Resuelve x² = {n*n} en los números reales.',roots(-n,n),f'x = {n}',f'x = {n*n}',
        'Toma la raíz cuadrada incluyendo los dos signos.',
        [f'x² = {n*n} implica x = ±√{n*n}.',f'√{n*n} = {n}.',f'Soluciones: x = −{n} y x = {n}; ambos cuadrados valen {n*n}.'],
        'Falta la solución negativa, cuyo cuadrado da el mismo resultado.','El dato es x², no x; falta tomar la raíz.')
for i in range(10):
    r=i+1;s=i+3
    add('quadratics',f'Resuelve {poly(1,-r-s,r*s)}.',roots(r,s),roots(-r,-s),roots(r,s+1),
        'Busca dos números con suma igual al coeficiente cambiado de signo y producto igual a la constante.',
        [f'Factoriza: (x − {r})(x − {s}) = 0.',f'Un producto nulo implica x − {r} = 0 o x − {s} = 0.',f'Soluciones: {roots(r,s)}.'],
        'Los factores x − r se anulan en x = r, no en x = −r.','Una de esas raíces no anula el polinomio; comprueba por sustitución.')
for i in range(10):
    r=i-4;s=i+2;a=i%3+2;b=-a*(r+s);c=a*r*s;delta=b*b-4*a*c
    add('quadratics',f'Usa la fórmula general para resolver {poly(a,b,c)}.',roots(r,s),roots(r+1,s+1),roots(r-1,s-1),
        'Identifica a, b y c con sus signos. Usa x = (−b ± √(b² − 4ac))/(2a).',
        [f'a = {a}, b = {b}, c = {c}.',f'Δ = ({b})² − 4 × {a} × ({c}) = {delta}.',f'√Δ = {int(delta**0.5)}; x = ({-b} ± {int(delta**0.5)})/{2*a}.',f'Soluciones: {roots(r,s)}.'],
        'Vuelve a calcular −b y el denominador 2a; esas raíces no anulan la ecuación.','Revisa los signos y conserva ambos resultados de ±.')
for i in range(10):
    n=i+2;offset=[-1,0,1][i%3];c=n*n+offset;delta=-4*offset
    kind= 'Dos soluciones reales distintas' if delta>0 else 'Una solución real doble' if delta==0 else 'Sin soluciones reales'
    choices=['Dos soluciones reales distintas','Una solución real doble','Sin soluciones reales'];wrong=[v for v in choices if v!=kind]
    add('quadratics',f'¿Qué tipo de soluciones tiene {poly(1,-2*n,c)}?',kind,*wrong,
        'El signo del discriminante indica cuántas raíces reales distintas existen.',
        [f'Δ = (−{2*n})² − 4 × 1 × {c} = {delta}.', 'Δ > 0: dos raíces; Δ = 0: raíz doble; Δ < 0: ninguna raíz real.',f'Conclusión: {kind.lower()}.'],
        'Compara el signo de Δ con el caso propuesto; no coinciden.','Una raíz doble y dos raíces distintas no son el mismo caso; revisa el signo de Δ.')
for i in range(10):
    r=i+2;k=i%4+1;area=r*(r+k)
    add('quadratics',f'Un rectángulo tiene ancho x y largo x + {k} metros. Su área es {area} m². ¿Cuál es el ancho positivo?',f'{r} m',f'{-(r+k)} m',f'{r+k} m',
        'Plantea x(x + k) = área y descarta una longitud negativa.',
        [f'x(x + {k}) = {area}; por tanto x² + {k}x − {area} = 0.',f'Factoriza: (x − {r})(x + {r+k}) = 0.',f'Raíces: {r} y −{r+k}. Una longitud no puede ser negativa.',f'El ancho es {r} m; comprueba {r} × {r+k} = {area} m².'],
        'La raíz negativa resuelve la ecuación, pero no representa una longitud física.','Ese valor es el largo, no el ancho pedido.')

def d(value):return json.dumps(value,ensure_ascii=False).replace('$',r'\$')
for name,items in courses.items():assert len(items)==50
header="import 'course_models.dart';\n\n"
metadata={
 'logarithms': ('Logaritmos','El exponente escondido','log','Un logaritmo responde qué exponente necesita una base: log_b(A) = y equivale a b^y = A. En los reales, b > 0, b ≠ 1 y A > 0. Para argumentos positivos: log_b(AB) = log_b(A) + log_b(B); log_b(A/B) = log_b(A) − log_b(B); log_b(A^n) = n log_b(A). Un logaritmo no se distribuye sobre una suma. Las 50 preguntas avanzan desde la definición hasta ecuaciones, reglas y dominio.','log_2(32) = ?', ['Busca y tal que 2^y = 32.','2⁵ = 32.','Por definición, log_2(32) = 5.']),
 'advanced_powers': ('Potencias y exponentes','Reglas, recíprocos y raíces','aⁿ','Una potencia repite factores; el signo de una base negativa depende de la paridad del exponente. Con la misma base: a^m × a^n = a^(m+n); a^m/a^n = a^(m−n) si a ≠ 0; (a^m)^n = a^(mn). Para a ≠ 0, a^0 = 1 y a^(−n) = 1/a^n. Para base positiva, a^(p/q) significa tomar la raíz de índice q y elevarla a p. No confundas −a² con (−a)². Hay 50 ejercicios de cálculo, reglas y exponentes racionales.','16^(3/2) = ?', ['El denominador 2 pide la raíz cuadrada: √16 = 4.','El numerador 3 pide elevar esa raíz: 4³ = 64.','Así, 16^(3/2) = 64.']),
 'quadratics': ('Ecuaciones de segundo grado','Encuentra todas las raíces','x²','Una ecuación de segundo grado tiene forma ax² + bx + c = 0, con a ≠ 0. Puedes resolverla mediante raíces, factorización o x = (−b ± √Δ)/(2a), donde Δ = b² − 4ac. Si Δ > 0 hay dos raíces reales distintas; si Δ = 0 hay una raíz doble; si Δ < 0 no hay raíces reales (este curso trabaja en los reales). Comprueba las soluciones en la ecuación y descarta valores físicamente imposibles en problemas de medidas.','x² − 5x + 6 = 0', ['Busca dos números que sumen 5 y cuyo producto sea 6: 2 y 3.','Factoriza: (x − 2)(x − 3) = 0.','Iguala cada factor a cero: x = 2 o x = 3.','Comprueba ambas raíces en la ecuación original.'])
}
for name,items in courses.items():
    title,subtitle,symbol,theory,example,steps=metadata[name]
    header+=f'const {name}Lessons = <Lesson>[\n  Lesson('+', '.join(map(d,[name,title,subtitle,symbol,theory,example,steps]))+', [\n'
    for q,options,index,hint,explanation,errors,solution in items:
        header+='    Exercise('+', '.join([d(q),d(options),str(index),d(hint),d(explanation),d(errors)])+', steps: '+d(solution)+'),\n'
    header+='  ]),\n];\n\n'
header=header.replace('advanced_powersLessons','advancedPowersLessons')
Path('lib/src/advanced_curriculum.dart').write_text(header,encoding='utf-8')
print('Three courses; 150 distinct exercises, each with worked steps.')
