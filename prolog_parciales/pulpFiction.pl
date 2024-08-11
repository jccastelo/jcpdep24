personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).
personaje(marvin,      bailarin).

pareja(marsellus, mia).
pareja(pumkin,    honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

%etc

/*
1. esPeligroso/1. Nos dice si un personaje es peligroso. Eso ocurre cuando:
-realiza alguna actividad peligrosa: ser matón, o robar licorerías. 
-tiene empleados peligrosos
*/

esPeligroso(Personaje):-
    personaje(Personaje, Actividad),
    esActividadPeligrosa(Actividad).
esPeligroso(Personaje):-
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).

esActividadPeligrosa(mafioso(maton)).
esActividadPeligrosa(ladron(Lista)):-
    member(licorerias, Lista).


/*
2. duoTemible/2 que relaciona dos personajes cuando son peligrosos y además son pareja o amigos. Considerar que Tarantino también nos dió los siguientes hechos:
*/

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

duoTemible(Personaje1, Personaje2):-
    esPeligroso(Personaje1),
    esPeligroso(Personaje2),
    sonCercanos(Personaje1, Personaje2).

sonCercanos(Personaje1, Personaje2):- amigo(Personaje1, Personaje2).
sonCercanos(Personaje1, Personaje2):- pareja(Personaje1, Personaje2).


/*
3.  estaEnProblemas/1: un personaje está en problemas cuando 
el jefe es peligroso y le encarga que cuide a su pareja
o bien, tiene que ir a buscar a un boxeador. 
Además butch siempre está en problemas. 

Ejemplo:

? estaEnProblemas(vincent)
yes. %porque marsellus le pidió que cuide a mia, y porque tiene que ir a buscar a butch
*/

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(marsellus, jules,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).



estaEnProblemas(Personaje):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    pareja(Jefe, Pareja),
    encargo(Jefe, Personaje, cuidar(Pareja)).
estaEnProblemas(Personaje):-
    encargo(_, Personaje, buscar(Buscado, _)),
    personaje(Buscado, boxeador).
estaEnProblemas(butch).


/*
4.  sanCayetano/1:  es quien a todos los que tiene cerca les da trabajo (algún encargo). 
Alguien tiene cerca a otro personaje si es su amigo o empleado. 
*/

sanCayetano(Personaje):-
    personaje(Personaje,_),
    tieneCercaA(Personaje, _),
    forall(tieneCercaA(Personaje, Cercano), leDaTrabajo(Personaje, Cercano)).

tieneCercaA(Personaje, Cercano):- amigo(Personaje, Cercano).
tieneCercaA(Personaje, Cercano):- trabajaPara(Personaje, Cercano).

leDaTrabajo(Personaje, Cercano):-
    encargo(Personaje, Cercano, _).


/*
5. masAtareado/1. Es el más atareado aquel que tenga más encargos que cualquier otro personaje.
*/

masAtareado(Personaje):-
    personaje(Personaje, _),
    cantidadDeEncargos(Personaje, Cantidad),
    forall(cantidadDeEncargos(_, Cantidad2), Cantidad>=Cantidad2).

cantidadDeEncargos(Personaje, Cantidad):-
    personaje(Personaje, _),
    listaDeEncargos(Personaje, Lista),
    length(Lista, Cantidad).

listaDeEncargos(Personaje, Lista):-
    findall(Encargo, encargo(_, Personaje, Encargo), Lista).


/*
6. personajesRespetables/1: genera la lista de todos los personajes respetables. Es respetable cuando su actividad tiene un nivel de respeto mayor a 9. Se sabe que:
Las actrices tienen un nivel de respeto de la décima parte de su cantidad de peliculas.
Los mafiosos que resuelven problemas tienen un nivel de 10 de respeto, los matones 1 y los capos 20.
Al resto no se les debe ningún nivel de respeto. 
*/

personajesRespetables(Lista):-
    findall(Personaje, esRespetable(Personaje), Lista).

esRespetable(Personaje):-
    personaje(Personaje, Actividad),
    nivelDeRespeto(Actividad, Nivel),
    Nivel > 9.

nivelDeRespeto(actriz(Peliculas), Nivel):-
    length(Peliculas, Cantidad),
    Nivel is Cantidad / 10.
nivelDeRespeto(mafioso(resuelveProblemas), 10).
nivelDeRespeto(mafioso(maton), 1).
nivelDeRespeto(mafioso(capo), 20).


/*
7. hartoDe/2: un personaje está harto de otro, cuando todas las tareas asignadas al primero requieren interactuar con el segundo (cuidar, buscar o ayudar) o un amigo del segundo. Ejemplo:

? hartoDe(winston, vincent).
true % winston tiene que ayudar a vincent, y a jules, que es amigo de vincent.
*/

hartoDe(Personaje, OtroPersonaje):-
    personaje(Personaje, _),
    personaje(OtroPersonaje, _),
    interactuaConElOtro(Personaje, OtroPersonaje).

interactuaConElOtro(Personaje, OtroPersonaje):-
    encargo(_, Personaje, _),
    forall(encargo(_, Personaje, Tipo), tipoEncargo(Tipo, OtroPersonaje)).

tipoEncargo(cuidar(OtroPersonaje), OtroPersonaje).
tipoEncargo(ayudar(OtroPersonaje), OtroPersonaje).
tipoEncargo(buscar(OtroPersonaje, _), OtroPersonaje).

tipoEncargo(Tipo, OtroPersonaje):-
    amigo(OtroPersonaje, PersonajeAmigo),
    tipoEncargo(Tipo, PersonajeAmigo).


/*
8. Ah, algo más: nuestros personajes tienen características. Lo cual es bueno, porque nos ayuda a diferenciarlos cuando están de a dos. Por ejemplo:

caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

Desarrollar duoDiferenciable/2, que relaciona a un dúo (dos amigos o una pareja) en el que uno tiene al menos una característica que el otro no. 
*/

caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

amigo(jules,marvin).

duoDiferenciable(Personaje1, Personaje2):-
    personaje(Personaje1,_),
    personaje(Personaje2,_),
    sonUnDuo(Personaje1, Personaje2),
    noCompartenCaracteristicas(Personaje1, Personaje2).

sonUnDuo(Personaje1, Personaje2):- amigo(Personaje1, Personaje2).
sonUnDuo(Personaje1, Personaje2):- pareja(Personaje1, Personaje2).

noCompartenCaracteristicas(Personaje1, Personaje2):-
    caracteristicas(Personaje1, Caracteristicas1),
    caracteristicas(Personaje2, Caracteristicas2),
    intersection(Caracteristicas1, Caracteristicas2, ListaTotal),
    length(ListaTotal, Cantidad),
    Cantidad < 1.