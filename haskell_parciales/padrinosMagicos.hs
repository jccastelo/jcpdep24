import Text.Show.Functions()

--DATOS

data Chico = Chico {
    nombre :: String,
    edad :: Int,
    habilidades :: [Habilidad],
    deseos :: [Deseo]
} deriving Show

type Habilidad = String
type Deseo = Chico -> Chico

timmy :: Chico
timmy = Chico {
    nombre = "Timmy",
    edad = 10,
    habilidades = ["mirar television", "jugar en la pc"],
    deseos = [serMayor]
}

chester :: Chico
chester = Chico {
    nombre = "Chester",
    edad = 10,
    habilidades = ["Pelearse", "Domesticar ratas"],
    deseos = []
}

modificarHabilidades :: ([Habilidad] -> [Habilidad]) -> Chico -> Chico
modificarHabilidades unaFuncion unChico = unChico {habilidades = unaFuncion.habilidades$unChico}

modificarEdad :: (Int -> Int) -> Chico -> Chico
modificarEdad unaFuncion unChico = unChico {edad = unaFuncion.edad$unChico}

{-
1. Desarrollar los siguiente deseos y declarar el data Chico
a. aprenderHabilidades habilidades unChico : agrega una lista de habilidades
nuevas a las que ya tiene el chico.
b. serGrosoEnNeedForSpeed unChico: dado un chico, le agrega las habilidades
de jugar a todas las versiones pasadas y futuras del Need For Speed, que
son: “jugar need for speed 1”, “jugar need for speed 2”, etc.
c. serMayor unChico: Hace que el chico tenga 18 años.
-}

aprenderHabilidades :: [Habilidad] -> Deseo
aprenderHabilidades listaDeHabilidades unChico = modificarHabilidades (++ listaDeHabilidades) unChico

serGrosoEnNeedForSpeed :: Deseo
serGrosoEnNeedForSpeed unChico = modificarHabilidades (++ saberJugarNeedForSpeeds) unChico

saberJugarNeedForSpeeds :: [Habilidad]
saberJugarNeedForSpeeds = map (siguienteNeedForSpeed) [1..]

siguienteNeedForSpeed :: Int -> String
siguienteNeedForSpeed numero = "Jugar need for speed " ++ show (numero)

serMayor :: Deseo
serMayor unChico = unChico {edad = 18}


{-
2. Los padrinos son seres mágicos capaces de cumplir los deseos de sus ahijados.
Desarrollar los siguientes padrinos:
a. wanda: dado un chico, wanda le cumple el primer deseo y lo hace madurar
(crecer un año de edad).
a. cosmo: dado un chico, lo hace “des”madurar, quedando con la mitad de años de
edad. Como es olvidadizo, no le concede ningún deseo.
b. muffinMagico: dado un chico le concede todos sus deseos.
Nota importante: no debe haber lógica repetida entre wanda, cosmo y serMayor
-}

wanda :: Deseo
wanda unChico = madurar . cumplirPrimerDeseo $ unChico

madurar :: Deseo
madurar unChico = modificarEdad ((+)1) unChico

cumplirPrimerDeseo :: Deseo
cumplirPrimerDeseo unChico = (head . deseos $ unChico) unChico

cosmo :: Deseo
cosmo unChico = desmadurar unChico

desmadurar :: Chico -> Chico
desmadurar unChico = modificarEdad (dividir 2) unChico

dividir :: Int -> Int -> Int
dividir dividendo divisor = div divisor dividendo

muffinMagico :: Deseo
muffinMagico unChico = cumplirLos (deseos unChico) unChico

cumplirLos :: [Deseo] -> Chico -> Chico
cumplirLos listaDeDeseos unChico = foldr ($) unChico listaDeDeseos


--PARTE B

{-
1. Se acerca el baile de fin de año y se quiere saber cuáles van a ser las parejas. Para
esto las chicas tienen condiciones para elegir al chico con el que van a salir, algunas de
ellas son:
a. tieneHabilidad unaHabilidad unChico: Dado un chico y una habilidad, dice
si la posee.
b. esSuperMaduro: Dado un chico dice si es mayor de edad (es decir, tiene más
de 18 años) y además sabe manejar.
-}

tieneHabilidad :: Habilidad -> Chico -> Bool
tieneHabilidad unaHabilidad unChico = elem unaHabilidad (habilidades unChico)

esSuperMaduro :: Chico -> Bool
esSuperMaduro unChico = (edad unChico) > 18

{-
2. Las chicas tienen un nombre, y una condición para elegir al chico con el que van ir al
baile. Ejemplos:
-- para Trixie la única condición es que el chico no sea Timmy,

--ya que nunca saldría con él
trixie = Chica “Trixie Tang” noEsTimmy
vicky = Chica “Vicky” (tieneHabilidad “ser un supermodelo noruego”)
Se pide definir el data Chica y desarrollar las siguientes funciones:
a. quienConquistaA unaChica losPretendientes: Dada una chica y una lista
de pretendientes, devuelve al que se queda con la chica, es decir, el primero
que cumpla con la condición que ella quiere. Si no hay ninguno que la cumpla,
devuelve el último pretendiente (una chica nunca se queda sola). (Sólo en este
punto se puede usar recursividad)
b. Dar un ejemplo de consulta para una nueva chica, cuya condición para elegir a
un chico es que este sepa cocinar.
-}

data Chica = UnaChica {
    nombreChica :: String,
    condicion :: Condicion
} deriving Show

type Condicion = Chico -> Bool

trixie :: Chica
trixie = UnaChica {
    nombreChica = "Trixie",
    condicion = (not.esTimmy)
}

vicky :: Chica
vicky = UnaChica {
    nombreChica = "Vicky",
    condicion = (tieneHabilidad "Ser un supermodelo noruego")
}

esTimmy :: Chico -> Bool
esTimmy unChico = (nombre unChico) == "Timmy"

quienConquistaA :: Chica -> [Chico] -> Chico
quienConquistaA _ [] = error "No hay pretendientes"
quienConquistaA _ [pretendiente] = pretendiente
quienConquistaA unaChica (pretendiente : demasPretendientes)
    | cumpleLaCondicion unaChica pretendiente = pretendiente
    | otherwise = quienConquistaA unaChica demasPretendientes

cumpleLaCondicion :: Chica -> Chico -> Bool
cumpleLaCondicion unaChica unChico = (condicion unaChica) unChico

tootie :: Chica
tootie = UnaChica {
    nombreChica = "Tootie",
    condicion = (tieneHabilidad "cocinar")
}

aj :: Chico
aj = Chico {
    nombre = "A.J.",
    edad = 10,
    habilidades = ["estudiar", "cocinar"],
    deseos = []
}

--quienConquistaA tootie [chester, aj, timmy]
-- aj

--PARTE C

{-
1. infractoresDeDaRules : Dada una lista de
chicos, devuelve la lista de los nombres de
aquellos que tienen deseos prohibidos. Un deseo
está prohibido si, al aplicarlo, entre las
cinco primeras habilidades, hay alguna prohibida.
En tanto, son habilidades prohibidas enamorar,
matar y dominar el mundo.
-}

infractoresDeDaRules :: [Chico] -> [String]
infractoresDeDaRules listaDeChicos = map (nombre) (chicosConDeseosProhibidos listaDeChicos)

habilidadesProhibidas :: [Habilidad]
habilidadesProhibidas = ["enamorar", "matar", "dominar el mundo"]

chicosConDeseosProhibidos :: [Chico] -> [Chico]
chicosConDeseosProhibidos listaDeChicos = filter (tieneDeseoProhibido) listaDeChicos

tieneDeseoProhibido :: Chico -> Bool
tieneDeseoProhibido unChico = any (esDeseoProhibido unChico) (deseos unChico)

esDeseoProhibido :: Chico -> Deseo -> Bool
esDeseoProhibido unChico unDeseo = any (esHabilidadProhibida) ((take 5) . habilidades . unDeseo $ unChico)

esHabilidadProhibida :: Habilidad -> Bool
esHabilidadProhibida unaHabilidad = elem unaHabilidad habilidadesProhibidas