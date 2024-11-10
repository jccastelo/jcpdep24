import src.trajes.*

class Guerrero {
    const potencialOfensivo
    var nivelDeExperiencia
    const nivelDeEnergiaInicial
    var nivelDeEnergia
    const tipoDeTraje

    method potencialOfensivo() = potencialOfensivo

    method aumentarExperiencia(cantidad) {
        nivelDeExperiencia += cantidad
    }

    method disminuirEnergia(cantidad) {
        nivelDeEnergia -= cantidad
    }

    method atacar(otroGuerrero) {
        otroGuerrero.serAtacado(self.potencialOfensivo() * 0.1)
    }

    method serAtacado(puntosDeFuerza) {
        self.disminuirEnergia(puntosDeFuerza - puntosDeFuerza * self.resistencia()) //porcentaje que disminuye daño
        self.aumentarExperiencia(1 * tipoDeTraje.efectoDelTrajeExperiencia()) //porcentaje q aumenta la exp
    }

    method resistencia() {
        return tipoDeTraje.efectoDelTrajeEnergia()
    }

    method comerSemillaDelErmitanio() {
        nivelDeEnergia = nivelDeEnergiaInicial
    }

    method elementosEnSuTraje() = tipoDeTraje.elementosDelTraje()
}

class Saiyajin inherits Guerrero {
    var nivelTransformacion

    override method potencialOfensivo() {
        return super() * nivelTransformacion.potencialOfensivoTransformado()
    }

    override method resistencia() {
        return super() * nivelTransformacion.porcentajeAumentoResistencia()
    }

    method transformar(estado) {
        nivelTransformacion = estado
    }

    override method comerSemillaDelErmitanio() {
        super()
        potencialOfensivo * 1.05
    }
}

class NivelDeTransformacion {
    const porcentajeAumentoResistencia
    const potencialOfensivoTransformado

    method porcentajeAumentoResistencia() = porcentajeAumentoResistencia

    method potencialOfensivoTransformado() = potencialOfensivoTransformado
}

const estadoBase = new NivelDeTransformacion(porcentajeAumentoResistencia = 1, potencialOfensivoTransformado = 1)
const ssj1 = new NivelDeTransformacion(porcentajeAumentoResistencia = 1.05, potencialOfensivoTransformado = 1.5)
const ssj2 = new NivelDeTransformacion(porcentajeAumentoResistencia = 1.07, potencialOfensivoTransformado = 1.5)
const ssj3 = new NivelDeTransformacion(porcentajeAumentoResistencia = 1.15, potencialOfensivoTransformado = 1.5)