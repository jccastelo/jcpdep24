/* PUNTO 1
dodain atiende lunes, miércoles y viernes de 9 a 15.
lucas atiende los martes de 10 a 20
juanC atiende los sábados y domingos de 18 a 22.
juanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
leoC atiende los lunes y los miércoles de 14 a 18.
martu atiende los miércoles de 23 a 24. 
*/

atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).

atiende(vale, Dia, HoraInicio, HoraFinal):-
    atiende(dodain, Dia, HoraInicio, HoraFinal).
atiende(vale, Dia, HoraInicio, HoraFinal):-
    atiende(juanC, Dia, HoraInicio, HoraFinal).

% - nadie hace el mismo horario que leoC
% por principio de universo cerrado, no agregamos a la base de conocimiento aquello que no tiene sentido agregar
% - maiu está pensando si hace el horario de 0 a 8 los martes y miércoles
% por principio de universo cerrado, lo desconocido se presume falso




/* PUNTO 2
Definir un predicado que permita relacionar un día y hora con una persona, en la que dicha persona atiende el kiosko. Algunos ejemplos:
si preguntamos quién atiende los lunes a las 14, son dodain, leoC y vale
si preguntamos quién atiende los sábados a las 18, son juanC y vale
si preguntamos si juanFdS atiende los jueves a las 11, nos debe decir que sí.
si preguntamos qué días a las 10 atiende vale, nos debe decir los lunes, miércoles y viernes.

El predicado debe ser inversible para relacionar personas y días.

*/
quienAtiende(Dia, Hora, Persona):-
    atiende(Persona, Dia, HoraInicio, HoraFinal),
    between(HoraInicio, HoraFinal, Hora).



/* PUNTO 3
Definir un predicado que permita saber si una persona en un día y horario determinado está atendiendo ella sola. En este predicado debe utilizar not/1, y debe ser inversible para relacionar personas. Ejemplos:
si preguntamos quiénes están forever alone el martes a las 19, lucas es un individuo que satisface esa relación.
si preguntamos quiénes están forever alone el jueves a las 10, juanFdS es una respuesta posible.
si preguntamos si martu está forever alone el miércoles a las 22, nos debe decir que no (martu hace un turno diferente)
martu sí está forever alone el miércoles a las 23
el lunes a las 10 dodain no está forever alone, porque vale también está
*/

foreverAlone(Persona, Dia, Horario):-
    quienAtiende(Dia, Horario, Persona),
    not((quienAtiende(Dia, Horario, OtraPersona), Persona \= OtraPersona)).
    



/* PUNTO 4
Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día. Por ejemplo, si preguntamos por el miércoles, tiene que darnos esta combinatoria:
nadie
dodain solo
dodain y leoC
dodain, vale, martu y leoC
vale y martu
etc.

Queremos saber todas las posibilidades de atención de ese día. La única restricción es que la persona atienda ese día (no puede aparecer lucas, por ejemplo, porque no atiende el miércoles).
*/

posibilidadDeAtencion(Dia, PersonasPosibles):-
    findall(Persona, distinct(Persona, quienAtiende(Dia, _, Persona)), PersonasPosibles).

%no terminado.



/* PUNTO 5
En el kiosko tenemos por el momento tres ventas posibles:
golosinas, en cuyo caso registramos el valor en plata
cigarrillos, de los cuales registramos todas las marcas de cigarrillos que se vendieron (ej: Marlboro y Particulares)
bebidas, en cuyo caso registramos si son alcohólicas y la cantidad

Queremos agregar las siguientes cláusulas:
dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, cigarrillos Jockey, golosinas por $ 50
dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 1 bebida no-alcohólica, golosinas por $ 10
martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.
lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.

Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió, la primera venta que hizo fue importante. Una venta es importante:
en el caso de las golosinas, si supera los $ 100.
en el caso de los cigarrillos, si tiene más de dos marcas.
en el caso de las bebidas, si son alcohólicas o son más de 5.

El predicado debe ser inversible: martu y dodain son personas suertudas.
*/

venta(dodain, fecha(10,8), [golosinas(1200), cigarillos(jockey), golosinas(50)]).
venta(dodain, fecha(12,8), [bebidas(alcoholica, 8), bebidas(noAlcoholica, 1), golosinas(10)]).
venta(martu, fecha(12,8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas, fecha(11,8), [golosinas(600)]).
venta(lucas, fecha(18,8), [bebidas(noAlcoholica, 2), cigarillos(derby)]).

esPersonaSuertuda(Persona):-
    vendedora(Persona),
    forall(venta(Persona, _, [Venta|_]), esVentaImportante(Venta)).
  
vendedora(Persona):-
    venta(Persona, _, _).

esVentaImportante(golosinas(Precio)):-
    Precio >= 100.
esVentaImportante(cigarrillos(Marcas)):-
    length(Marcas, Cantidad),
    Cantidad >= 2.
esVentaImportante(bebidas(alcoholica, _)).
esVentaImportante(bebidas(_, Cantidad)):-
    Cantidad >= 5.
    
