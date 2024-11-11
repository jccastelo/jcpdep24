class Pared {
    const ancho

    method resistencia() = self.multiplicador() * ancho

    method multiplicador()

    method puedeSerDerribado(fuerzaDelPajaro) {
        return fuerzaDelPajaro > self.resistencia()
    }
}

class ParedDeVidrio inherits Pared {
    override method multiplicador() = 10
}

class ParedDeMadera inherits Pared {
    override method multiplicador() = 25
}

class ParedDePiedra inherits Pared {
    override method multiplicador() = 50
}

class CerditoObrero {
    method resistencia() = 50

    method puedeSerDerribado(fuerzaDelPajaro) {
        return fuerzaDelPajaro > self.resistencia()
    }
}

class CerditoArmado {
    method resistencia() = 10 * self.resistenciaDeSuItem()

    method resistenciaDeSuItem()

    method puedeSerDerribado(fuerzaDelPajaro) {
        return fuerzaDelPajaro > self.resistencia()
    }
}
class CerditoConCasco inherits CerditoArmado {
    const resistenciaDelCasco

    override method resistenciaDeSuItem() = resistenciaDelCasco
}

class CerditoConEscudo inherits CerditoArmado {
    const resistenciaDelEscudo

    override method resistenciaDeSuItem() = resistenciaDelEscudo
}