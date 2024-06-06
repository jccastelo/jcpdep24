import Text.Show.Functions()
import Data.Char(toUpper)

-- Definicion barbaros

data Barbaro = UnBarbaro {
    nombre :: String,
    fuerza :: Int,
    habilidades :: [Habilidad],
    objetos :: [Objeto]
} deriving Show

omar :: Barbaro
omar = UnBarbaro {
    nombre = "Omar",
    fuerza = 100,
    habilidades = ["tejer","escribirPoesia"],
    objetos = []
}

type Objeto = Barbaro -> Barbaro
type Habilidad = String

--genericas atributos del data

modificarFuerza :: (Int -> Int) -> Barbaro -> Barbaro
modificarFuerza unaFuncion unBarbaro = unBarbaro {fuerza = abs.unaFuncion.fuerza $ unBarbaro }

modificarHabilidad :: ([Habilidad] -> [Habilidad]) -> Barbaro -> Barbaro
modificarHabilidad unaFuncion unBarbaro = unBarbaro {habilidades = unaFuncion.habilidades $ unBarbaro}


--P1

espada :: Int -> Objeto
espada peso unBarbaro = modificarFuerza ((+) (peso * 2)) unBarbaro

amuletosMisticos :: Habilidad -> Objeto
amuletosMisticos unaHabilidad unBarbaro = modificarHabilidad (++ [unaHabilidad]) unBarbaro

varitasDefectuosas :: Objeto
varitasDefectuosas unBarbaro = desaparecerObjetos.(modificarHabilidad (++ ["hacerMagia"])) $ unBarbaro

desaparecerObjetos :: Barbaro -> Barbaro
desaparecerObjetos unBarbaro = unBarbaro {objetos = []}

ardilla :: Objeto
ardilla unBarbaro = unBarbaro

cuerda :: Objeto -> Objeto -> Objeto
cuerda unObjeto otroObjeto unBarbaro = unObjeto . otroObjeto $ unBarbaro


--P2

megafono :: Objeto
megafono unBarbaro = unBarbaro {habilidades = potenciarHabilidades (habilidades unBarbaro)}

potenciarHabilidades :: [Habilidad] -> [Habilidad]
potenciarHabilidades unaHabilidad = map transformarPalabraMayuscula unaHabilidad

transformarPalabraMayuscula :: String -> String
transformarPalabraMayuscula unaPalabra = map toUpper unaPalabra

megafonoBarbarico :: Objeto
megafonoBarbarico unBarbaro = cuerda megafono ardilla unBarbaro


--P3

type Grupo = [Barbaro]
type Aventura = [Evento]
type Evento = Barbaro -> Bool
type Pruebas = [Evento]

invasionDeSuciosDuendes :: Evento
invasionDeSuciosDuendes unBarbaro = sabe "Escribir Poesía Atroz" unBarbaro

cremalleraDelTiempo :: Evento
cremalleraDelTiempo unBarbaro = not.noTienePulgares$unBarbaro

ritualDeFechorias :: Pruebas -> Evento
ritualDeFechorias listaDePruebas unBarbaro = any ($ unBarbaro) listaDePruebas
--ese ($ unBarbaro) equivale a (\evento -> evento unBarbaro)


saqueo :: Evento
saqueo unBarbaro = sabeRobar unBarbaro && (>80) (fuerza unBarbaro)

gritoDeGuerra :: Evento
gritoDeGuerra unBarbaro = poderGritoDeGuerra unBarbaro == cantidadDeLetrasDeHabilidades unBarbaro

caligrafia :: Evento
caligrafia unBarbaro = (masDe3Vocales . habilidades $ unBarbaro) && (comienzanConMayuscula . habilidades $ unBarbaro)


--EJEMPLO DE AVENTURA:
aventuraLoca :: Aventura
aventuraLoca = [invasionDeSuciosDuendes, cremalleraDelTiempo]

sobrevivientes :: Aventura -> Grupo -> Grupo
sobrevivientes unaAventura unGrupo = filter (sobreviveA unaAventura) unGrupo



--Funciones aux:

sabe :: Habilidad -> Barbaro -> Bool
sabe unaHabilidad unBarbaro = elem unaHabilidad (habilidades unBarbaro)

noTienePulgares :: Barbaro -> Bool
noTienePulgares unBarbaro = elem (nombre unBarbaro) barbarosSinPulgares

barbarosSinPulgares :: [String]
barbarosSinPulgares = ["faffy", "astro"]

sabeRobar :: Barbaro -> Bool
sabeRobar unBarbaro = elem "Robar" (habilidades unBarbaro)

poderGritoDeGuerra :: Barbaro -> Int
poderGritoDeGuerra unBarbaro = (4*) . length . objetos $ unBarbaro

cantidadDeLetrasDeHabilidades :: Barbaro -> Int
cantidadDeLetrasDeHabilidades unBarbaro = length . concat . habilidades $ unBarbaro

masDe3Vocales :: [Habilidad] -> Bool
masDe3Vocales listaDeHabilidades = (length . (filter esVocal) . concat $ listaDeHabilidades) > 3

esVocal :: Char -> Bool
esVocal caracter = elem caracter "AEIOUaeiou"

comienzanConMayuscula :: [Habilidad] -> Bool
comienzanConMayuscula listaDeHabilidades = all esVocal (map head listaDeHabilidades)

sobreviveA :: Aventura -> Barbaro -> Bool
sobreviveA unaAventura unBarbaro = all ($ unBarbaro) unaAventura




--P4

{-
A - Los bárbaros se marean cuando tienen varias habilidades iguales. Por todo esto, nos piden desarrollar una función que elimine los elementos repetidos de una lista (sin utilizar nub ni nubBy)

> sinRepetidos [1,2,3,4,4,5,5,6,7]
[1,2,3,4,5,6,7]

Nota: Puede usarse recursividad para este punto.
-}

sinRepetidos :: [Habilidad] -> [Habilidad]
sinRepetidos [] = []
sinRepetidos (cabeza:cola) = cabeza : sinRepetidos (filter (/= cabeza) cola) 


{-
B - Los bárbaros son una raza muy orgullosa, tanto que quieren saber cómo van a ser sus descendientes y asegurarse de que los mismos reciban su legado.

El descendiente de un bárbaro comparte su nombre, y un asterisco por cada generación. Por ejemplo "Dave*", "Dave**" , "Dave***" , etc. 

Además, tienen en principio su mismo poder, habilidades sin repetidos, y los objetos de su padre, pero antes de pasar a la siguiente generación, utilizan (aplican sobre sí mismos) los objetos. Por ejemplo, el hijo de Dave será equivalente a:

(ardilla.varitasDefectuosas) (Barbaro "Dave*" 100 ["tejer","escribirPoesia"] [ardilla, varitasDefectuosas])


Definir la función descendientes, que dado un bárbaro nos de sus infinitos descendientes. 
-}

descendientes :: Barbaro -> [Barbaro]
descendientes unBarbaro = iterate (modificarHabilidad sinRepetidos . nombreDescendiente . aplicarObjetos) unBarbaro

aplicarObjetos :: Barbaro -> Barbaro
aplicarObjetos unBarbaro = foldr ($) unBarbaro (objetos unBarbaro)

nombreDescendiente :: Barbaro -> Barbaro
nombreDescendiente unBarbaro = modificarNombre (++ "*") unBarbaro

modificarNombre :: (String->String) -> Barbaro -> Barbaro
modificarNombre funcion unBarbaro = unBarbaro {nombre = funcion.nombre$unBarbaro}