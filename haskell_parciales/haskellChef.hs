import Text.Show.Functions()

--DATAS Y TIPOS

data Participante = UnParticipante {
    nombre :: String,
    trucosDeCocina :: [Truco],
    especialidad :: Plato
} deriving Show

data Plato = UnPlato {
    dificultad :: Int,
    componentes :: [Componente]
} deriving Show

type Truco = Plato -> Plato

milanesa :: Plato
milanesa = UnPlato {
    dificultad = 15,
    componentes = [("Pan", 5), ("Carne", 20), ("Huevo", 5), ("Queso", 10), ("Jamon", 5), ("Oregano",2)]
}

modificarComponentes :: ([Componente] -> [Componente]) -> Plato -> Plato
modificarComponentes unaFuncion unPlato = unPlato {componentes = unaFuncion.componentes$unPlato}

type Componente = (Ingrediente, Peso)
type Ingrediente = String
type Peso = Int

pesoDelComponente :: Componente -> Peso
pesoDelComponente unComponente = snd unComponente

cantidadDelComponente :: Componente -> Int
cantidadDelComponente componente = snd componente

{-
endulzar: dada una cantidad de gramos de azúcar, le agrega ese componente a un plato.  
salar: la vieja y confiable… dada una cantidad de gramos de sal y un plato, nos retorna el mismo con esa cantidad de sal para que quede flama.
darSabor: dadas una cantidad de sal y una de azúcar sala y endulza un plato.
duplicarPorcion: se duplica la cantidad de cada componente de un plato… para más placer.
simplificar: hay platos que son realmente un bardo. Es por ello que si un plato tiene más de 5 componentes y una dificultad mayor a 7 lo vamos a simplificar, sino lo dejamos igual. Simplificar un plato es dejarlo con 5 de dificultad y quitarle aquellos componentes de los que hayamos agregado menos de 10 gramos.
-}

endulzar :: Int -> Plato -> Plato
endulzar cantidad unPlato = modificarComponentes ((:) ("Azucar", cantidad)) unPlato

salar :: Int -> Plato -> Plato
salar cantidad unPlato = modificarComponentes ((:) ("Sal", cantidad)) unPlato

darSabor :: Int -> Int -> Plato -> Plato
darSabor cantidadDeSal cantidadDeAzucar unPlato = (endulzar cantidadDeAzucar) . (salar cantidadDeSal) $ unPlato

duplicarPorcion :: Plato -> Plato
duplicarPorcion unPlato = modificarComponentes (map duplicarCantidad) unPlato

duplicarCantidad :: Componente -> Componente
duplicarCantidad (ingrediente, peso) = (ingrediente, peso * 2)

simplificar :: Plato -> Plato
simplificar unPlato
    | esComplejo unPlato = realizarSimplificacion unPlato
    | otherwise = unPlato

realizarSimplificacion :: Plato -> Plato
realizarSimplificacion unPlato = modificarComponentes (filter (hayMucho)) $ unPlato {dificultad = 5}

hayMucho :: Componente -> Bool
hayMucho unComponente = pesoDelComponente unComponente > 10


{-
esVegano: si no tiene carne, huevos o alimentos lácteos.
esSinTacc: si no tiene harina.
esComplejo: cuando tiene más de 5 componentes y una dificultad mayor a 7.
noAptoHipertension: si tiene más de 2 gramos de sal.
-}

esVegano :: Plato -> Bool
esVegano unPlato = all (esComponenteVegano) (componentes unPlato)

componentesVeganos :: [Ingrediente]
componentesVeganos = ["Carne", "Huevos"] ++ alimentosLacteos

alimentosLacteos :: [Ingrediente]
alimentosLacteos = ["Leche", "Queso", "Dulce de Leche"]

esComponenteVegano :: Componente -> Bool
esComponenteVegano (nombreDelComponente, _) = not (elem nombreDelComponente componentesVeganos)

esSinTacc :: Plato -> Bool
esSinTacc unPlato = not (tiene "Harina" unPlato)

tiene :: Ingrediente -> Plato -> Bool
tiene unIngrediente unPlato = elem unIngrediente (nombresDeComponentes unPlato)

nombresDeComponentes :: Plato -> [Ingrediente]
nombresDeComponentes unPlato = map fst (componentes unPlato)

esComplejo :: Plato -> Bool
esComplejo unPlato = ((length.componentes$unPlato) > 5) && (dificultad unPlato > 7)

noAptoHipertension :: Plato -> Bool
noAptoHipertension unPlato = (tiene "Sal" unPlato) && (cantidadDe "Sal" unPlato > 2)

cantidadDe :: Ingrediente -> Plato -> Int
cantidadDe unIngrediente unPlato = cantidadDelComponente . (conseguirComponente unIngrediente) $ unPlato

conseguirComponente :: Ingrediente -> Plato -> Componente
conseguirComponente unIngrediente unPlato = head . filter (esDe unIngrediente) . componentes  $ unPlato

esDe :: Ingrediente -> Componente -> Bool
esDe unIngrediente (ingredienteDelComponente, _) = unIngrediente == ingredienteDelComponente



--PARTE B

{-
En la prueba piloto del programa va a estar participando Pepe Ronccino quien tiene unos trucazos bajo la manga como darle sabor a un plato con 2 gramos de sal y 5 de azúcar, simplificarlo y duplicar su porción. Su especialidad es un plato complejo y no apto para personas hipertensas.
 
Modelar a Pepe y su plato. 

-}

pepeRonccino :: Participante
pepeRonccino = UnParticipante {
    nombre = "Pepe Ronccino",
    trucosDeCocina = [(darSabor 2 5), simplificar, duplicarPorcion],
    especialidad = especialidadPepe
}

especialidadPepe :: Plato
especialidadPepe = UnPlato {
    dificultad = 8,
    componentes = [("Sal", 3), ("Leche", 5), ("Azucar", 3), ("Carne", 5), ("Lechuga", 10), ("Aceite", 5)]
}

turcoGarcia :: Participante
turcoGarcia = UnParticipante {
    nombre = "Turco Garcia",
    trucosDeCocina = [(endulzar 5), duplicarPorcion],
    especialidad = especialidadTurco
}

especialidadTurco :: Plato
especialidadTurco = UnPlato {
    dificultad = 10,
    componentes = [("Carne", 10), ("Papas", 8), ("Cebolla", 5), ("Crema", 5)]
}

--PARTE C

{-
¡Ahora sí! Manos a la obra… o manos en la masa… bueno, continuemos. 

Dado que este es un programa de concursos de cocina vamos a tener que modelar tres funcionalidades: 

cocinar: es el momento en el que la magia ocurre y vemos como queda finalmente el plato de un participante luego de aplicar todos sus trucos a su especialidad.
esMejorQue: en esta contienda diremos que un plato es mejor que otro si tiene más dificultad pero la suma de los pesos de sus componentes es menor.
participanteEstrella (este punto es el único en el que pueden usar recursividad si así lo desean): ¡se picó y no estamos hablando de la cebolla! Dada una lista de participantes, diremos que la estrella es quien luego de que todo el grupo cocine tiene el mejor plato.
-}

cocinar :: Participante -> Plato
cocinar unParticipante = aplicarTrucos (trucosDeCocina unParticipante) (especialidad unParticipante)

aplicarTrucos :: [Truco] -> Plato -> Plato
aplicarTrucos listaDeTrucos unPlato = foldr ($) unPlato listaDeTrucos

esMejorQue :: Plato -> Plato -> Bool
esMejorQue unPlato otroPlato = (esMasDificil unPlato otroPlato) && (pesaMenos unPlato otroPlato)

esMasDificil :: Plato -> Plato -> Bool
esMasDificil unPlato otroPlato = dificultad unPlato > dificultad otroPlato

pesaMenos :: Plato -> Plato -> Bool
pesaMenos unPlato otroPlato = sumaDeComponentes unPlato < sumaDeComponentes otroPlato

sumaDeComponentes :: Plato -> Int
sumaDeComponentes unPlato = sum (map cantidadDelComponente (componentes unPlato))

participanteEstrella :: [Participante] -> Participante
participanteEstrella listaDeParticipantes = foldl (mejorParticipante) (head listaDeParticipantes) listaDeParticipantes

mejorParticipante :: Participante -> Participante -> Participante
mejorParticipante unParticipante otroParticipante
    | esMejorQue (especialidad unParticipante) (especialidad otroParticipante) = unParticipante
    | otherwise = otroParticipante



--PARTE D

{-
Para finalizar vamos a modelar el plato definitivo, el platinum. Este plato tiene de especial que tiene infinitos componentes misteriosos con cantidades incrementales y dificultad 10:

> componentes platinum
[("Ingrediente 1", 1), ("Ingrediente 2", 2), ("Ingrediente 3", 3),..]

> dificultad platinum
10

Luego de modelar el platinum respondé las siguientes preguntas justificando tus respuestas:
 
¿Qué sucede si aplicamos cada uno de los trucos modelados en la Parte A al platinum?
¿Cuáles de las preguntas de la Parte A (esVegano, esSinTacc, etc.) se pueden responder sobre el platinum? 
¿Se puede saber si el platinum es mejor que otro plato?

-}

platinum :: Plato
platinum = UnPlato {
    dificultad = 10,
    componentes = componentesInfinitos
}

convertirComponente :: Int -> Componente
convertirComponente unNumero = ("Ingrediente " ++ show unNumero, unNumero)

componentesInfinitos :: [Componente]
componentesInfinitos = map (convertirComponente) [1..]

{-
Tanto en endulzar, como salar y darSabor no podrán mostrarse porque la lista de ingredientes es infinita, y el componente se agrega al final.
Al nunca finalizar de mostrarse la lista, nunca podrá agregarse, aunque en un hipotético caso de que termine, si se haría
Debido al lazy evaluation utilizado en haskell, el duplicar porción irá duplicando cada ingrediente a medida que se genera la lista
Por otro lado, no puede simplificar ya que necesita saber el tamaño de la lista de componentes, y al ser infinita nunca podrá conseguirlo

Ninguno, ya que al ser infinita jamás terminará de buscar los elementos que sugieren esas funciones. Si bien yo se que jamás aparecerá una sal, por ejemplo, la computadora no puede saberlo

Se podría solo si la primer condición, de que la dificultad del otro plato sea mayor que platinum, sea falsa. Esto haría que la primer condición sea falsa y ni evalue la segunda por el AND. En cambio, si da verdadera, al internar evaluar la otra jamás temrinaria pues la suma es infinita
-}