import Text.Show.Functions()

{-
Nombre: TIE Fighter
Durabilidad: 200
Escudo: 100
Ataque: 50
Poder:  Hace un movimiento Turbo, el cual incrementa su ataque en 25

Nombre: X Wing
Durabilidad: 300
Escudo: 150
Ataque: 100
Poder: Hace una reparación de emergencia, lo cual aumenta su durabilidad en 50 pero reduce su ataque en 30.

Nombre: Nave de Darth Vader
Durabilidad: 500
Escudo: 300
Ataque: 200
Poder: Hace un movimiento Super Turbo, lo cual significa hacer 3 veces el movimiento Turbo y reducir la durabilidad en 45.

Nombre: Millennium Falcon
Durabilidad: 1000
Escudo: 500
Ataque: 50
Poder: Hace una reparación de emergencia y además se incrementan sus escudos en 100.

-}

data Nave = Nave {
    nombre :: String,
    durabilidad :: Int,
    escudo :: Int,
    ataque :: Int,
    poder :: Poder
} deriving Show

type Poder = Nave -> Nave

modificarAtaque :: (Int -> Int) -> Nave -> Nave
modificarAtaque unaFuncion unaNave = unaNave {ataque = unaFuncion . ataque $ unaNave}

modificarDurabilidad :: (Int -> Int) -> Nave -> Nave
modificarDurabilidad unaFuncion unaNave = unaNave {durabilidad = unaFuncion . durabilidad $ unaNave}

modificarEscudo :: (Int -> Int) -> Nave -> Nave
modificarEscudo unaFuncion unaNave = unaNave {escudo = unaFuncion . escudo $ unaNave}

tieFighter :: Nave
tieFighter = Nave {
    nombre = "TIE Fighter",
    durabilidad = 200,
    escudo = 100,
    ataque = 50,
    poder = movimientoTurbo
}

xWing :: Nave
xWing = Nave {
    nombre = "X Wing",
    durabilidad = 300,
    escudo = 150,
    ataque = 100,
    poder = reparacionDeEmergencia
}

naveDeDarthVader :: Nave
naveDeDarthVader = Nave {
    nombre = "Nave de Darth Vader",
    durabilidad = 500,
    escudo = 300,
    ataque = 200,
    poder = movimientoSuperTurbo
}

milenniumFalcon :: Nave
milenniumFalcon = Nave {
    nombre = "Milennium Falcon",
    durabilidad = 1000,
    escudo = 500,
    ataque = 50,
    poder = reparacionDeEmergencia . modificarEscudo ((+)10)
}

movimientoTurbo :: Poder
movimientoTurbo unaNave = modificarAtaque ((+) 25) unaNave

reparacionDeEmergencia :: Poder
reparacionDeEmergencia unaNave = modificarDurabilidad ((+) 50) . modificarAtaque (reducir 50) $ unaNave

reducir :: Int -> Int -> Int
reducir valorAReducir valorTotal = max 0 (valorTotal - valorAReducir)

movimientoSuperTurbo :: Poder
movimientoSuperTurbo unaNave = movimientoTurbo . movimientoTurbo . movimientoTurbo . modificarDurabilidad (reducir 45) $ unaNave

--NAVE AGREGADA:
naveJuancito :: Nave
naveJuancito = Nave {
    nombre = "Nave Juancito",
    durabilidad = 10000,
    escudo = 1000,
    ataque = 500,
    poder = movimientoUltraTurbo
}

movimientoUltraTurbo :: Poder
movimientoUltraTurbo unaNave = movimientoSuperTurbo . movimientoTurbo . modificarDurabilidad (reducir 100) $ unaNave


{-
2-Calcular la durabilidad total de una flota, formada por un conjunto de naves, que es la suma de la durabilidad de todas las naves que la integran.
-}

type Flota = [Nave]

durabilidadDeUnaFlota :: Flota -> Int
durabilidadDeUnaFlota unaFlota = sum (map durabilidad unaFlota)

{-
2. Saber cómo queda una nave luego de ser atacada por otra. Cuando ocurre un ataque ambas naves primero activan su poder especial y luego la nave atacada reduce su durabilidad según el daño recibido, que es la diferencia entre el ataque de la atacante y el escudo de la atacada. (si el escudo es superior al ataque, la nave atacada no es afectada). La durabilidad, el escudo y el ataque nunca pueden ser negativos, a lo sumo 0.
-}

estadoPostAtaque :: Nave -> Nave -> Nave
estadoPostAtaque naveAtacada naveAtacante
    | danioRecibidoEscudo naveAtacadaY naveAtacanteY <= 0 = modificarDurabilidad (reducir (ataqueTotal naveAtacadaY naveAtacanteY)) (naveAtacadaY)
    | otherwise = modificarEscudo (reducir (danioRecibidoEscudo naveAtacadaY naveAtacanteY)) (activarPoder naveAtacadaY)
    where   naveAtacanteY = activarPoder naveAtacante
            naveAtacadaY = activarPoder naveAtacada   
ataqueTotal :: Nave -> Nave -> Int
ataqueTotal naveAtacada naveAtacante = reducir (ataque naveAtacante - escudo naveAtacada) (durabilidad naveAtacada)

danioRecibidoEscudo :: Nave -> Nave -> Int
danioRecibidoEscudo naveAtacada naveAtacante = reducir (ataque naveAtacante) (escudo naveAtacada)

activarPoder :: Nave -> Nave
activarPoder unaNave = (poder unaNave) unaNave