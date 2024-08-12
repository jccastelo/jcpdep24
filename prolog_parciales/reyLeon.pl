%comio(Personaje, Bicho)
comio(pumba, vaquitaSanAntonio(gervasia,3)).
comio(pumba, hormiga(federica)).
comio(pumba, hormiga(tuNoEresLaReina)).
comio(pumba, cucaracha(ginger,15,6)).
comio(pumba, cucaracha(erikElRojo,25,70)).
comio(timon, vaquitaSanAntonio(romualda,4)).
comio(timon, cucaracha(gimeno,12,8)).
comio(timon, cucaracha(cucurucha,12,5)).
comio(simba, vaquitaSanAntonio(remeditos,4)).
comio(simba, hormiga(schwartzenegger)).
comio(simba, hormiga(niato)).
comio(simba, hormiga(lula)).

comio(shenzi,hormiga(conCaraDeSimba)).

pesoHormiga(2).

%peso(Personaje, Peso)
peso(pumba, 100).
peso(timon, 50).
peso(simba, 200).
peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).

/*
Definir los predicados que permitan saber:
a) Qué cucaracha es jugosita: ó sea, hay otra con su mismo tamaño pero ella es más gordita.
?- jugosita(cucaracha(gimeno,12,8)).
Yes
b) Si un personaje es hormigofílico... (Comió al menos dos hormigas).
?- hormigofilico(X).
X = pumba;
X = simba.
c) Si un personaje es cucarachofóbico (no comió cucarachas).
?- cucarachofobico(X).
X = simba
d) Conocer al conjunto de los picarones. Un personaje es picarón si comió una cucaracha jugosita ó si se
come a Remeditos la vaquita. Además, pumba es picarón de por sí.
?- picarones(L).
L = [pumba, timon, simba]
*/

jugosita(cucaracha(Cucaracha,Tamanio,Peso)):-
    comio(_, cucaracha(Cucaracha,Tamanio,Peso)),
    comio(_,cucaracha(OtraCucaracha,Tamanio,OtroPeso)),
    Cucaracha \= OtraCucaracha,
    Peso > OtroPeso.

esHormigofilico(Personaje):-
    comio(Personaje, hormiga(Nombre1)),
    comio(Personaje, hormiga(Nombre2)),
    Nombre1 \= Nombre2.

esCucarachafobico(Personaje):-
    comio(Personaje, _),
    not(comio(Personaje, cucaracha(_,_,_))).

picarones(Personajes):-
    findall(Personaje, esPicaron(Personaje), Personajes).

esPicaron(Personaje):-
    comio(Personaje, Cucaracha),
    jugosita(Cucaracha).
esPicaron(Personaje):-
    comio(Personaje, vaquitaSanAntonio(remeditos,4)).
esPicaron(pumba).


/*
a) Se quiere saber cuánto engorda un personaje (sabiendo que engorda una cantidad igual a la suma de
los pesos de todos los bichos en su menú). Los bichos no engordan.
?- cuantoEngorda(Personaje, Peso).
Personaje= pumba
Peso = 83;
Personaje= timon
Peso = 17;

Personaje= simba
Peso = 10
*/

cuantoEngorda(Personaje, Peso):-
    comio(Personaje,_),
    listaDePesos(Personaje, Lista),
    sum_list(Lista, Peso).

listaDePesos(Personaje, Lista):-
    findall(PesoDelBicho, pesoPorBicho(Personaje, PesoDelBicho), Lista).

pesoPorBicho(Personaje, PesoDelBicho):- 
    comio(Personaje, hormiga(_)),
    pesoHormiga(PesoDelBicho).
pesoPorBicho(Personaje, PesoDelBicho):- comio(Personaje, vaquitaSanAntonio(_, PesoDelBicho)).
pesoPorBicho(Personaje, PesoDelBicho):- comio(Personaje, cucaracha(_,_,PesoDelBicho)).


/*
b) Pero como indica la ley de la selva, cuando un personaje persigue a otro, se lo termina comiendo, y por lo
tanto también engorda. Realizar una nueva version del predicado cuantoEngorda.
?- cuantoEngorda(scar,Peso).
Peso = 150
(es la suma de lo que pesan pumba y timon)
?- cuantoEngorda(shenzi,Peso).
Peso = 502
(es la suma del peso de scar y simba, mas 2 que pesa la hormiga)
*/
persigue(scar, timon).
persigue(scar, pumba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).
persigue(scar, mufasa).

cuantoEngorda2(Personaje, Peso):-
    persigue(Personaje, _),
    listaPesosPerseguidos(Personaje, Lista),
    sum_list(Lista, Peso).

listaPesosPerseguidos(Personaje, Lista):-
    findall(Peso, pesoDelSeguido(Personaje, Peso), Lista).

pesoDelSeguido(Personaje, Peso):-
    persigue(Personaje, Seguido),
    peso(Seguido, Peso).

/*
c) Ahora se complica el asunto, porque en realidad cada animal antes de comerse a sus víctimas espera a que
estas se alimenten. De esta manera, lo que engorda un animal no es sólo el peso original de sus víctimas, sino
también hay que tener en cuenta lo que éstas comieron y por lo tanto engordaron. Hacer una última version del
predicado.

?- cuantoEngorda(scar,Peso).
Peso = 250
(150, que era la suma de lo que pesan pumba y timon, más 83 que se come
pumba y 17 que come timon )
?- cuantoEngorda(shenzi,Peso).
Peso = 762
(502 era la suma del peso de scar y simba, mas 2 de la hormiga. A eso se
le suman los 250 de todo lo que engorda scar y 10 que engorda simba)
*/

cuantoEngorda3(Personaje, Peso):-
    persigue(Personaje, _),
    pesoPerseguidos(Personaje, PesoPerseguidos),
    cuantoEngorda2(Personaje, PesoSinComer),
    Peso is PesoPerseguidos + PesoSinComer.

pesoPerseguidos(Personaje, PesoPerseguidos):-
    findall(Peso, distinct(pesoPerseguido(Personaje, Peso)), Pesos),
    sum_list(Pesos, PesoPerseguidos).

pesoPerseguido(Personaje, Peso):-
    persigue(Personaje, Perseguido),
    cuantoEngorda(Perseguido, Peso).


/*
3) Buscando el rey...
Sabiendo que todo animal adora a todo lo que no se lo come o no lo
persigue, encontrar al rey. El rey es el animal a quien sólo hay un animal
que lo persigue y todos adoran.
Si se agrega el hecho:
persigue(scar, mufasa).
?- rey(R).
R = mufasa.
(sólo lo persigue scar y todos los adoran)
*/

esElRey(Personaje):-
    personaje(Personaje),
    esAdorado(Personaje),
    soloUnPerseguidor(Personaje).

personaje(Personaje):- comio(Personaje, _).
personaje(Personaje):- persigue(Personaje, _).
personaje(Personaje):- persigue(_, Personaje).

esAdorado(Personaje):-
    personaje(Personaje),
    not(comio(Personaje, _)),
    not(persigue(Personaje,_)).

soloUnPerseguidor(Personaje):-
    persigue(Perseguidor, Personaje),
    persigue(Perseguidor2, Personaje),
    Perseguidor == Perseguidor2.