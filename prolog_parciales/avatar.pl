% esPersonaje/1 nos permite saber qué personajes tendrá el juego

esPersonaje(aang).
esPersonaje(katara).
esPersonaje(zoka).
esPersonaje(appa).
esPersonaje(momo).
esPersonaje(toph).
esPersonaje(tayLee).
esPersonaje(zuko).
esPersonaje(azula).
esPersonaje(iroh).

% esElementoBasico/1 nos permite conocer los elementos básicos que pueden controlar algunos personajes

esElementoBasico(fuego).
esElementoBasico(agua).
esElementoBasico(tierra).
esElementoBasico(aire).

% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado

elementoAvanzadoDe(fuego, rayo).
elementoAvanzadoDe(agua, sangre).
elementoAvanzadoDe(tierra, metal).

% controla/2 relaciona un personaje con un elemento que controla

controla(zuko, rayo).
controla(toph, metal).
controla(katara, sangre).
controla(aang, aire).
controla(aang, agua).
controla(aang, tierra).
controla(aang, fuego).
controla(azula, rayo).
controla(iroh, rayo).

% visito/2 relaciona un personaje con un lugar que visitó. Los lugares son functores que tienen la siguiente forma:
% reinoTierra(nombreDelLugar, estructura)
% nacionDelFuego(nombreDelLugar, soldadosQueLoDefienden)
% tribuAgua(puntoCardinalDondeSeUbica)
% temploAire(puntoCardinalDondeSeUbica)

visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).
visito(aang, nacionDelFuego(palacioReal, 1000)).
visito(katara, tribuAgua(norte)).
visito(aang, tribuAgua(norte)).
visito(zoka, tribuAgua(norte)).
visito(momo, tribuAgua(norte)).
visito(appa, tribuAgua(norte)).
visito(katara, tribuAgua(sur)).
visito(aang, temploAire(norte)).
visito(aang, temploAire(oeste)).
visito(aang, temploAire(este)).
visito(aang, temploAire(sur)).


%PUNTO 1

esElAvatar(Personaje):-
    esPersonaje(Personaje),
    forall(esElementoBasico(Elemento), controla(Personaje, Elemento)).


%PUNTO 2

noEsMaestro(Personaje):-
    esPersonaje(Personaje),
    not(controla(Personaje,_)).

esMaestroPrincipiante(Personaje):-
    esPersonaje(Personaje),
    controla(Personaje, Elemento),
    esElementoBasico(Elemento),
    elementoAvanzadoDe(Elemento, ElementoAvanzado),
    not(controla(Personaje, ElementoAvanzado)).

esMaestroAvanzado(Personaje):-
    esPersonaje(Personaje),
    controla(Personaje, Elemento),
    elementoAvanzadoDe(_, Elemento).


%PUNTO 3

sigueA(aang, zuko).
sigueA(Seguido, Seguidor):-
    esPersonaje(Seguido),
    esPersonaje(Seguidor),
    visito(Seguido, _),
    visito(Seguidor, _),
    forall(visito(Seguido, Lugar), visito(Seguidor, Lugar)).


%PUNTO 4

esLugar(Lugar):-
    visito(_, Lugar).

esDignoDeConocer(temploAire(Ubicacion)):-
    esLugar(temploAire(Ubicacion)).
esDignoDeConocer(tribuAgua(norte)).
esDignoDeConocer(reinoTierra(Lugar, Zonas)):-
    esLugar(reinoTierra(Lugar, Zonas)),
    not(member(muro, Zonas)).



%PUNTO 5

esPopular(Lugar):-
    esLugar(Lugar),
    cantidadDeVisitantes(Lugar, Cantidad),
    Cantidad >= 4.

cantidadDeVisitantes(Lugar, Cantidad):-
    listaDeVisitantes(Lugar, Lista),
    length(Lista, Cantidad).

listaDeVisitantes(Lugar, Lista):-
    findall(Personaje, visito(Personaje, Lugar), Lista).



%PUNTO 6

esPersonaje(bumi).
controla(tierra, bumi).
visito(bumi, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).

esPersonaje(suki).
visito(suki, nacionDelFuego(rocaHirviente, 200)).
