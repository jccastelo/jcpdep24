class Traje {
    var nivelDeDesgaste

    method efectoDelTrajeEnergia() = 0
    method efectoDelTrajeExperiencia() = 0

    method serUsado() {
        nivelDeDesgaste += 5
    }

    method estaGastado() {
        return nivelDeDesgaste >= 100
    }

    method elementosDelTraje() = 1
}

class TrajeComun inherits Traje {
    const porcentajeDeProteccion

    override method efectoDelTrajeEnergia() {
        return porcentajeDeProteccion / 100
    }
}

class TrajeDeEntrenamiento inherits Traje {
    var porcentajeAumentoExperiencia

    method porcentajeAumentoExperiencia(nuevoPorcentaje) {
        porcentajeAumentoExperiencia = nuevoPorcentaje
    }

    override method efectoDelTrajeExperiencia() = porcentajeAumentoExperiencia
}

class TrajeModularizado inherits Traje {
    const piezas = []

    override method efectoDelTrajeEnergia() {
        return piezas.sum({pieza => pieza.porcentajeDeResistencia()}) / 100
    }

    override method efectoDelTrajeExperiencia() {
        const piezasTotales = piezas.size()
        const piezasGastadas = piezas.filter({pieza => pieza.estaGastada()}).size()
        return (piezasTotales - piezasGastadas) / piezasTotales
    }

    override method estaGastado() {
        return piezas.all({pieza => pieza.estaGastada()})
    }

    override method elementosDelTraje() = piezas.size()
}

class Pieza {
    const porcentajeDeResistencia
    var valorDeDesgaste

    method porcentajeDeResistencia() = porcentajeDeResistencia

    method estaGastada() = valorDeDesgaste >= 20
}