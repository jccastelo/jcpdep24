--PUNTO 1

{-
1. Modelar a los animales: escribir un sinónimo de tipo y definir algunos ejemplos de animales como constantes. De un animal se sabe su coeficiente intelectual (un número), su especie (un string) y sus capacidades (strings).
-}

data Animal = Animal {
    coeficienteIntelectual :: Int,
    especie :: Especie,
    capacidades :: [Capacidad]
}

type Especie = String
type Capacidad = String

modificarCoeficiente :: (Int -> Int) -> Animal -> Animal
modificarCoeficiente unaFuncion unAnimal = unAnimal {coeficienteIntelectual = unaFuncion . coeficienteIntelectual $ unAnimal}

modificarCapacidades :: ([Capacidad] -> [Capacidad]) -> Animal -> Animal
modificarCapacidades unaFuncion unAnimal = unAnimal {capacidades = unaFuncion . capacidades $ unAnimal}

tigre :: Animal
tigre = Animal {
    coeficienteIntelectual = 80,
    especie = "Tigre",
    capacidades = ["Correr", "Rugir"]
}

mono :: Animal
mono = Animal {
    coeficienteIntelectual = 100,
    especie = "Mono",
    capacidades = ["Trepar", "Lavarse"]
}

elefante :: Animal
elefante = Animal {
    coeficienteIntelectual = 30,
    especie = "Elefante",
    capacidades = ["Lavarse", "Cubrirse"]
}

raton :: Animal
raton = Animal {
    coeficienteIntelectual = 150,
    especie = "Raton",
    capacidades = ["Correr", "Comer queso", "hacer narf", "hacer loco", "hacer asdf"]
}




--PUNTO 2

{-
2. Transformar a un animal de laboratorio:
inteligenciaSuperior: Incrementa en n unidades su coeficiente intelectual
pinkificar: quitarle todas las habilidades que tenía
superpoderes:  le da habilidades nuevas	
En caso de ser un elefante: le da la habilidad “no tenerle miedo a los ratones”
En caso de ser un ratón con coeficiente intelectual mayor a 100: le agrega la habilidad de “hablar”. 
Si no, lo deja como está. 

-}

inteligenciaSuperior :: Int -> Animal -> Animal
inteligenciaSuperior unNumero unAnimal = modificarCoeficiente ((+)unNumero) unAnimal

pinkificar :: Animal -> Animal
pinkificar unAnimal = unAnimal {capacidades = []}

superPoderes :: Animal -> Animal
superPoderes unAnimal
    | especie unAnimal == "Elefante" = agregarCapacidad "no tenerle miedo a los ratones" unAnimal
    | especie unAnimal == "Raton" && (coeficienteIntelectual raton) > 100 = agregarCapacidad "hablar" unAnimal
    | otherwise = unAnimal

agregarCapacidad :: Capacidad -> Animal -> Animal
agregarCapacidad unaCapacidad unAnimal = modificarCapacidades ((++) [unaCapacidad]) unAnimal




--PUNTO 3

{-
3. Los científicos muchas veces desean saber si un animal cumple ciertas propiedades, porque luego las usan como criterio de éxito de una transformación. Desarrollar los siguientes criterios:
antropomórfico: si tiene la habilidad de hablar y su coeficiente es mayor a 60.
noTanCuerdo: si tiene más de dos habilidades de hacer sonidos pinkiescos. Hacer una  función pinkiesco, que significa que la habilidad empieza con “hacer ”, y luego va seguido de una palabra "pinkiesca", es decir, con 4 letras o menos y al menos una vocal. Ejemplo:

> pinkiesco “hacer narf”
True

> pinkiesco “hacer asdf”
True
-}

esAntropomorfico :: Animal -> Bool
esAntropomorfico unAnimal = puedeHablar unAnimal && (coeficienteIntelectual unAnimal) > 60

puedeHablar :: Animal -> Bool
puedeHablar unAnimal = elem "Hablar" (capacidades unAnimal)

noTanCuerdo :: Animal -> Bool
noTanCuerdo unAnimal = (length . habilidadesPinkiescas $ unAnimal) > 2

habilidadesPinkiescas :: Animal -> [Capacidad]
habilidadesPinkiescas unAnimal = filter (esHabilidadPinkiesca) (capacidades unAnimal)

esHabilidadPinkiesca :: Capacidad -> Bool
esHabilidadPinkiesca unaHabilidad = (empiezaCon "hacer " unaHabilidad) && (sigueUnaPalabraPinkiesca "hacer " unaHabilidad)

empiezaCon :: String -> Capacidad -> Bool
empiezaCon unaPalabra unaHabilidad = (take (length unaPalabra) unaHabilidad) == unaPalabra

sigueUnaPalabraPinkiesca :: String -> Capacidad -> Bool
sigueUnaPalabraPinkiesca unaPalabra unaHabilidad = esPalabraPinkiesca (drop (length unaPalabra) unaHabilidad)

esPalabraPinkiesca :: String -> Bool
esPalabraPinkiesca unaPalabra = (length unaPalabra) <= 4 && tieneVocal unaPalabra

tieneVocal :: String -> Bool
tieneVocal unaPalabra = any esVocal unaPalabra

esVocal :: Char -> Bool
esVocal unaLetra = elem unaLetra vocales

vocales :: String
vocales = "AEIOUaeiou"


--PUNTO 4

{-
4. Los científicos construyen experimentos: un experimento se compone de un conjunto de transformaciones sobre un animal, y un criterio de éxito. Se pide:
Modelar a los experimentos: dar un sinónimo de tipo.
Desarollar experimentoExitoso: Dado un experimento y un animal, indica si al aplicar sucesivamente todas las transformaciones se cumple el criterio de éxito. 
Dar un ejemplo de consulta para representar la siguiente situación:


"En un ratón de coeficiente intelectual 17, con habilidades de destruenglonir el mundo y hacer planes desalmados, hacer un experimento que consista en pinkificarlo, luego darle inteligencia superior de 10 y por último darle superpoderes. Como criterio de éxito, ver si quedó antropomórfico" 

-}

type Experimento = ([Transformacion], Criterio)
type Transformacion = Animal -> Animal
type Criterio = Animal -> Bool

transformaciones :: Experimento -> [Transformacion]
transformaciones unExperimento = fst unExperimento 

criterio :: Experimento -> Criterio
criterio unExperimento = snd unExperimento

experimentoExitoso :: Experimento -> Animal -> Bool
experimentoExitoso unExperimento unAnimal = (criterio unExperimento) (aplicarTransformaciones unExperimento unAnimal)

aplicarTransformaciones :: Experimento -> Animal -> Animal
aplicarTransformaciones unExperimento unAnimal = foldl (aplicarTransformacion) unAnimal (transformaciones unExperimento)

aplicarTransformacion :: Animal -> Transformacion -> Animal
aplicarTransformacion unAnimal unaTransformacion = unaTransformacion unAnimal

rata :: Animal
rata = Animal {
    coeficienteIntelectual = 17,
    especie = "Rata",
    capacidades = ["destruenglonir el mundo", "hacer planes desalmados"]
}

experimentoLoco :: Experimento
experimentoLoco = ([pinkificar, modificarCoeficiente ((+)10), superPoderes], esAntropomorfico)

--experimentoExitoso experimentoLoco rata



--PARTE 5

{-
5. Periódicamente, ACME pide informes sobre los experimentos realizados. Desarrollar los siguientes reportes, que a partir de una lista de animales, una lista de capacidades y un experimento (o una serie de transformaciones) permitan obtener:
una lista con los coeficientes intelectuales de los animales que entre sus capacidades, luego de efectuar el experimento, tengan alguna de las capacidades dadas.
una lista con las especie de los animales que, luego de efectuar el experimento, tengan entre sus capacidades todas las capacidades dadas.
una lista con la cantidad de capacidades de todos los animales que, luego de efectuar el experimento, no tengan ninguna de las capacidades dadas.

-}

type Filtrador = (Capacidad -> Bool) -> [Capacidad] -> Bool
type Condicion = (Animal -> Bool)

informeCoeficientes :: [Animal] -> [Capacidad] -> Experimento -> [Int]
informeCoeficientes listaDeAnimales listaDeCapacidades unExperimento = map coeficienteIntelectual (listaAnimales (tienen any listaDeCapacidades) listaDeAnimales unExperimento)


informeEspecies :: [Animal] -> [Capacidad] -> Experimento -> [Especie]
informeEspecies listaDeAnimales listaDeCapacidades unExperimento = map especie (listaAnimales (tienen all listaDeCapacidades) listaDeAnimales unExperimento)


informeCapacidades :: [Animal] -> [Capacidad] -> Experimento -> [[Capacidad]]
informeCapacidades listaDeAnimales listaDeCapacidades unExperimento = map capacidades (listaAnimales (not.(tienen all) listaDeCapacidades) listaDeAnimales  unExperimento)




listaAnimales :: Condicion -> [Animal] -> Experimento -> [Animal]
listaAnimales unaCondicion listaDeAnimales unExperimento = filter unaCondicion ((transformacionesAplicadas unExperimento) listaDeAnimales)

tienen :: Filtrador -> [Capacidad] -> Animal -> Bool
tienen unaFuncion listaDeCapacidades unAnimal = unaFuncion (tieneLaCapacidad unAnimal) (listaDeCapacidades)

transformacionesAplicadas :: Experimento -> [Animal] -> [Animal]
transformacionesAplicadas unExperimento listaDeAnimales = map (aplicarTransformaciones unExperimento) listaDeAnimales

tieneLaCapacidad :: Animal -> Capacidad -> Bool
tieneLaCapacidad unAnimal unaCapacidad = elem unaCapacidad (capacidades unAnimal)








--Codigo juli

abecedario :: [Char]
abecedario = ['a'..'z']

charToString :: Char -> String
charToString unChar = [unChar]

palabrasDe1Letra :: [String]
palabrasDe1Letra = map charToString abecedario

prefijarPalabrasConCaracter :: [String] -> Char -> [String]
prefijarPalabrasConCaracter palabras caracter = map (caracter :) palabras

prefijarPalabrasConCaracteres :: [String] -> [Char] -> [String]
prefijarPalabrasConCaracteres palabras caracteres = concatMap (prefijarPalabrasConCaracter palabras) caracteres

palabrasDeNLetras :: Int -> [String]
palabrasDeNLetras 1 = palabrasDe1Letra
palabrasDeNLetras n = prefijarPalabrasConCaracteres (palabrasDeNLetras (n - 1)) abecedario