import Text.Show.Functions()

{-
Los enanos de Nidavellir nos han pedido modelar los guanteletes que ellos producen en su herrería. Un guantelete está hecho de un material (“hierro”, “uru”, etc.) y sabemos las gemas que posee. También se sabe de los personajes que tienen una edad, una energía, una serie de habilidades (como por ejemplo “usar espada”, “controlar la mente”, etc), su nombre y en qué planeta viven. Los fabricantes determinaron que cuando un guantelete está completo -es decir, tiene las 6 gemas posibles- y su material es “uru”, se tiene la posibilidad de chasquear un universo que contiene a todos sus habitantes y reducir a la mitad la cantidad de dichos personajes. Por ejemplo si tenemos un universo en el cual existen ironMan, drStrange, groot y wolverine, solo quedan los dos primeros que son ironMan y drStrange. Si además de los 4 personajes estuviera viudaNegra, quedarían también ironMan y drStrange porque se considera la división entera.

Punto 1: (2 puntos) Modelar Personaje, Guantelete y Universo como tipos de dato e implementar el chasquido de un universo.
-}

data Guantelete = Guantelete {
    material :: String,
    gemas :: [Gema]
} deriving Show

data Personaje = Personaje {
    edad :: Int,
    energia :: Int,
    habilidades :: [Habilidad],
    nombre :: String,
    planeta :: String
} deriving Show

type Universo = [Personaje]

type Gema = Personaje -> Personaje
type Habilidad = String

chasquear :: Guantelete -> Universo -> Universo
chasquear unGuantelete unUniverso
    | esGuanteleteCompleto unGuantelete = reducirALaMitad unUniverso
    | otherwise = unUniverso

esGuanteleteCompleto :: Guantelete -> Bool
esGuanteleteCompleto unGuantelete = tieneLas6Gemas unGuantelete && (material unGuantelete) == "uru"

tieneLas6Gemas :: Guantelete -> Bool
tieneLas6Gemas unGuantelete = (length . gemas $ unGuantelete) == 6

reducirALaMitad :: Universo -> Universo
reducirALaMitad unUniverso = take (mitad unUniverso) unUniverso

mitad :: Universo -> Int
mitad unUniverso = div (length unUniverso) 2


{-
Punto 2: (3 puntos) Resolver utilizando únicamente orden superior.
Saber si un universo es apto para péndex, que ocurre si alguno de los personajes que lo integran tienen menos de 45 años.
Saber la energía total de un universo que es la sumatoria de todas las energías de sus integrantes que tienen más de una habilidad.

-}

esAptoPendex :: Universo -> Bool
esAptoPendex unUniverso = any (edadMenorA 45) unUniverso

edadMenorA :: Int -> Personaje -> Bool
edadMenorA unaEdad unPersonaje = (edad unPersonaje) < unaEdad

energiaTotal :: Universo -> Int
energiaTotal unUniverso = foldr (+) 0 (energiasDePersonajesHabiles unUniverso)

energiasDePersonajesHabiles :: Universo -> [Int]
energiasDePersonajesHabiles unUniverso = map (energia) (personajesHabiles unUniverso)

personajesHabiles :: Universo -> Universo
personajesHabiles unUniverso = filter (tieneMuchasHabilidades) unUniverso

tieneMuchasHabilidades :: Personaje -> Bool
tieneMuchasHabilidades unPersonaje = tamañoHabilidades unPersonaje > 1

tamañoHabilidades :: Personaje -> Int
tamañoHabilidades unPersonaje = length . habilidades $ unPersonaje



{-
La mente que tiene la habilidad de debilitar la energía de un usuario en un valor dado.
El alma puede controlar el alma de nuestro oponente permitiéndole eliminar una habilidad en particular si es que la posee. Además le quita 10 puntos de energía. 
El espacio que permite transportar al rival al planeta x (el que usted decida) y resta 20 puntos de energía.
El poder deja sin energía al rival y si tiene 2 habilidades o menos se las quita (en caso contrario no le saca ninguna habilidad).
El tiempo que reduce a la mitad la edad de su oponente pero como no está permitido pelear con menores, no puede dejar la edad del oponente con menos de 18 años. Considerar la mitad entera, por ej: si el oponente tiene 50 años, le quedarán 25. Si tiene 45, le quedarán 22 (por división entera). Si tiene 30 años, le deben quedar 18 en lugar de 15. También resta 50 puntos de energía.
La gema loca que permite manipular el poder de una gema y la ejecuta 2 veces contra un rival.

Punto 3: (3 puntos) Implementar las gemas del infinito, evitando lógica duplicada. 
-}

{-GEEMASS-}

laMente :: Int -> Gema
laMente cantidadADebilitar unPersonaje = (quitarEnergia cantidadADebilitar) unPersonaje

elAlma :: Habilidad -> Gema
elAlma unaHabilidad unPersonaje = (eliminarHabilidad unaHabilidad) . (quitarEnergia 20)  $ unPersonaje

elEspacio :: String -> Gema
elEspacio unPlaneta unPersonaje = (modificarPlaneta (const unPlaneta)) . (quitarEnergia 20) $ unPersonaje

elPoder :: Gema
elPoder unPersonaje = dejarSinEnergia . quitarDosHabilidades $ unPersonaje

elTiempo :: Gema
elTiempo unPersonaje = reduciraMitadLaEdad . (quitarEnergia 50) $ unPersonaje

gemaLoca :: Gema -> Gema
gemaLoca unaGema unPersonaje = unaGema . unaGema $ unPersonaje


--aux generales

quitarEnergia :: Int -> Personaje -> Personaje
quitarEnergia unaCantidad unPersonaje = unPersonaje {energia = max 0 (energia unPersonaje - unaCantidad)}

modificarHabilidades :: ([Habilidad] -> [Habilidad]) -> Personaje -> Personaje
modificarHabilidades unaFuncion unPersonaje = unPersonaje {habilidades = unaFuncion.habilidades$unPersonaje}

eliminarHabilidad :: Habilidad -> Personaje -> Personaje
eliminarHabilidad unaHabilidad unPersonaje = unPersonaje {habilidades = habilidadesSin unaHabilidad unPersonaje}

modificarPlaneta :: (String -> String) -> Personaje -> Personaje
modificarPlaneta unaFuncion unPersonaje = unPersonaje {planeta = unaFuncion . planeta $ unPersonaje}



--aux ElAlma

habilidadesSin :: Habilidad -> Personaje -> [Habilidad]
habilidadesSin unaHabilidad unPersonaje = filter (not . esLaHabilidad unaHabilidad) (habilidades unPersonaje)

esLaHabilidad :: Habilidad -> Habilidad -> Bool
esLaHabilidad unaHabilidad otraHabilidad = unaHabilidad == otraHabilidad



--aux ElPoder

dejarSinEnergia :: Personaje -> Personaje
dejarSinEnergia unPersonaje = quitarEnergia (energia unPersonaje) unPersonaje

quitarDosHabilidades :: Personaje -> Personaje
quitarDosHabilidades unPersonaje
    | tieneMasDe 2 (habilidades unPersonaje) = modificarHabilidades (drop 2) unPersonaje
    | otherwise = unPersonaje

tieneMasDe :: Int -> [Habilidad] -> Bool
tieneMasDe cantidad listaDeHabilidades = length listaDeHabilidades > cantidad



--aux ElTiempo

reduciraMitadLaEdad :: Personaje -> Personaje
reduciraMitadLaEdad unPersonaje = unPersonaje {edad = max 18 (div (edad unPersonaje) 2)}



{-Punto 4: (1 punto) Dar un ejemplo de un guantelete de goma con las gemas tiempo, alma que quita la habilidad de “usar Mjolnir” y la gema loca que manipula el poder del alma tratando de eliminar la “programación en Haskell”.-}

guanteleteDeGoma :: Guantelete
guanteleteDeGoma = Guantelete {
    material = "Goma",
    gemas = [elTiempo, elAlma "usar Mjolnir", gemaLoca (elAlma "programacion en Haskell")]
}


{-
Punto 5: (2 puntos). No se puede utilizar recursividad. Generar la función utilizar  que dado una lista de gemas y un enemigo ejecuta el poder de cada una de las gemas que lo componen contra el personaje dado. Indicar cómo se produce el “efecto de lado” sobre la víctima.
-}

utilizar :: [Gema] -> Personaje -> Personaje
utilizar listaDeGemas unPersonaje = foldr ($) unPersonaje listaDeGemas

{-
Punto 6: (2 puntos). Resolver utilizando recursividad. Definir la función gemaMasPoderosa que dado un guantelete y una persona obtiene la gema del infinito que produce la pérdida más grande de energía sobre la víctima. 
-}

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa unGuantelete unPersonaje = gemaMasPoderosaSobre unPersonaje (gemas unGuantelete)

gemaMasPoderosaSobre :: Personaje -> [Gema] -> Gema
gemaMasPoderosaSobre _ [] = error "Ese guantelete no tiene gemas"
gemaMasPoderosaSobre _ [unaGema] = unaGema
gemaMasPoderosaSobre unPersonaje (gema1:gema2:demasGemas)
    | pierdeMasEnergiaSobre unPersonaje gema1 gema2 = gemaMasPoderosaSobre unPersonaje (gema1:demasGemas)
    | otherwise = gemaMasPoderosaSobre unPersonaje (gema2:demasGemas)

pierdeMasEnergiaSobre :: Personaje -> Gema -> Gema -> Bool
pierdeMasEnergiaSobre unPersonaje gema1 gema2 = (energia . gema1 $ unPersonaje) < (energia . gema2 $ unPersonaje)