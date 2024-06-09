import Text.Show.Functions()

data Elemento = UnElemento { 
    tipo :: String,
    ataque :: (Personaje-> Personaje),
    defensa :: (Personaje-> Personaje)
} deriving Show

data Personaje = UnPersonaje { 
    nombre :: String,
    salud :: Float,
    elementos :: [Elemento],
    anioPresente :: Int
} deriving Show

modificarAnio :: (Int -> Int) -> Personaje -> Personaje
modificarAnio unaFuncion unPersonaje = unPersonaje {anioPresente = unaFuncion . anioPresente $ unPersonaje}

modificarSalud :: (Float -> Float) -> Personaje -> Personaje
modificarSalud unaFuncion unPersonaje = unPersonaje {salud = unaFuncion . salud $ unPersonaje}

{-
PUNTO 1
Empecemos por algunas transformaciones básicas:
mandarAlAnio: lleva al personaje al año indicado.
meditar: le agrega la mitad del valor que tiene a la salud del personaje.
causarDanio: le baja a un personaje una cantidad de salud dada.
Hay que tener en cuenta al modificar la salud de un personaje que ésta nunca puede quedar menor a 0.
Importante: no repetir lógica.
-}

mandarAlAnio :: Int -> Personaje -> Personaje
mandarAlAnio anio unPersonaje = modificarAnio (const anio) unPersonaje

meditar :: Personaje -> Personaje
meditar unPersonaje = modificarSalud ((+) (salud unPersonaje / 2)) unPersonaje

causarDanio :: Float -> Personaje -> Personaje
causarDanio danio unPersonaje = modificarSalud (daniar danio) unPersonaje

daniar :: Float -> Float -> Float
daniar unDanio unaSalud = max 0 (unaSalud - unDanio)


{-
Punto 2
esMalvado, que retorna verdadero si alguno de los elementos que tiene el personaje en cuestión es de tipo “Maldad”.
danioQueProduce :: Personaje -> Elemento -> Float, que retorne la diferencia entre la salud inicial del personaje y la salud del personaje luego de usar el ataque del elemento sobre él.
enemigosMortales que dado un personaje y una lista de enemigos, devuelve la lista de los enemigos que pueden llegar a matarlo con un solo elemento. Esto sucede si luego de aplicar el efecto de ataque del elemento, el personaje queda con salud igual a 0.
-}

esMalvado :: Personaje -> Bool
esMalvado unPersonaje = any (esElementoMalvado) (elementos unPersonaje)

esElementoMalvado :: Elemento -> Bool
esElementoMalvado unElemento = (tipo unElemento) == "Maldad"

danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce unPersonaje unElemento = (salud unPersonaje) - (salud . (ataque unElemento) $ unPersonaje)

enemigosMortales :: Personaje -> [Personaje] -> [Personaje]
enemigosMortales unPersonaje listaDeEnemigos = filter (puedeMatarA unPersonaje) listaDeEnemigos

puedeMatarA :: Personaje -> Personaje -> Bool
puedeMatarA unPersonaje otroPersonaje = danioQueProduce unPersonaje (head . elementos $ otroPersonaje) <= 0


{-
 Definir los siguientes personajes y elementos:
Definir concentracion de modo que se pueda obtener un elemento cuyo efecto defensivo sea aplicar meditar tantas veces como el nivel de concentración indicado y cuyo tipo sea "Magia".
Definir esbirrosMalvados que recibe una cantidad y retorna una lista con esa cantidad de esbirros (que son elementos de tipo “Maldad” cuyo efecto ofensivo es causar un punto de daño).
Definir jack de modo que permita obtener un personaje que tiene 300 de salud, que tiene como elementos concentración nivel 3 y una katana mágica (de tipo "Magia" cuyo efecto ofensivo es causar 1000 puntos de daño) y vive en el año 200.
Definir aku :: Int -> Float -> Personaje que recibe el año en el que vive y la cantidad de salud con la que debe ser construido. Los elementos que tiene dependerán en parte de dicho año. Los mismos incluyen:
Concentración nivel 4
Tantos esbirros malvados como 100 veces el año en el que se encuentra.
Un portal al futuro, de tipo “Magia” cuyo ataque es enviar al personaje al futuro (donde el futuro es 2800 años después del año indicado para aku), y su defensa genera un nuevo aku para el año futuro correspondiente que mantenga la salud que tenga el personaje al usar el portal.

-}

concentracion :: Int -> Elemento
concentracion nivelDeconcentracion = UnElemento {
    tipo = "Magia",
    ataque = noHacerNada,
    defensa = (foldr1 (.) (replicate nivelDeconcentracion meditar))
}

noHacerNada :: Personaje -> Personaje
noHacerNada unPersonaje = unPersonaje

esbirrosMalvados :: Int -> [Elemento]
esbirrosMalvados unaCantidad = replicate unaCantidad esbirros

esbirros :: Elemento
esbirros = UnElemento {
    tipo = "Maldad",
    ataque = (causarDanio 1),
    defensa = noHacerNada
}

jack :: Personaje
jack = UnPersonaje {
    nombre = "Jack",
    salud = 300,
    elementos = [(concentracion 3), katanaMagica],
    anioPresente = 200
}

katanaMagica :: Elemento
katanaMagica = UnElemento {
    tipo = "Magia",
    ataque = (causarDanio 1000),
    defensa = noHacerNada
}

aku :: Int -> Float -> Personaje
aku anioQueVive cantidadDeSalud = UnPersonaje {
    nombre = "Aku",
    salud = cantidadDeSalud,
    elementos = (concentracion 4) : (portalAlFuturo anioQueVive) : (esbirrosMalvados (anioQueVive * 100)),
    anioPresente = anioQueVive
}

portalAlFuturo :: Int -> Elemento
portalAlFuturo anioIndicado = UnElemento {
    tipo = "Magia",
    ataque = mandarAlAnio (2800 + anioIndicado),
    defensa = (aku (anioFuturo anioIndicado).salud)
}

anioFuturo :: Int -> Int
anioFuturo unNumero = 2800 + unNumero

{-
Finalmente queremos saber cómo puede concluir la lucha entre Jack y Aku. Para ello hay que definir la función luchar :: Personaje -> Personaje -> (Personaje, Personaje) donde se espera que si el primer personaje (el atacante) está muerto, retorne la tupla con el defensor primero y el atacante después, en caso contrario la lucha continuará invirtiéndose los papeles (el atacante será el próximo defensor) luego de que ambos personajes se vean afectados por el uso de todos los elementos del atacante.

O sea que si luchan Jack y Aku siendo Jack el primer atacante, Jack se verá afectado por el poder defensivo de la concentración y Aku se verá afectado por el poder ofensivo de la katana mágica, y la lucha continuará con Aku (luego del ataque) como atacante y con Jack (luego de la defensa) como defensor.
-}


luchar :: Personaje -> Personaje -> (Personaje, Personaje)
luchar atacante defensor
    | estaMuerto atacante = (defensor, atacante)
    | otherwise = luchar (recibir ataque defensor (elementos atacante)) (recibir defensa atacante (elementos defensor))

recibir :: (Elemento -> Personaje -> Personaje) -> Personaje -> [Elemento] -> Personaje
recibir funcion receptor listaDeElementos = foldl (afectar) receptor (map funcion listaDeElementos)

afectar :: Personaje -> (Personaje -> Personaje) -> Personaje
afectar unPersonaje funcion = funcion unPersonaje

estaMuerto :: Personaje -> Bool
estaMuerto unPersonaje = (<=0) . salud $ unPersonaje

