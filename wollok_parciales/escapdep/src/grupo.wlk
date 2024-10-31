import src.escapistas.*
import src.salas.*

class Grupo {
    const equipo = []
    var sala

    method sala() = sala
    method sala(nuevaSala) {sala = nuevaSala}

    method puedeEscapar() {
        return equipo.any({miembro => miembro.puedeSalir(sala)})
    }

    method escapar() {
        self.pagar()
        self.registrarEnCadaIntegrante()
    }

    method pagar() {
        const precioDeSala = sala.precio()
        const cantidadCorrespondiente = precioDeSala / self.cantidadDeIntegrantes()
        if (self.puedenPagar(precioDeSala, cantidadCorrespondiente)) { 
        equipo.forEach({miembro => miembro.descontarSalario(cantidadCorrespondiente)})
        } else {
            throw new Exception(message="¡El grupo no puede pagar la sala de escape!")
        }
    }

    method cantidadDeIntegrantes() = equipo.size()

    method registrarEnCadaIntegrante() {
        equipo.forEach({miembro => miembro.agregarSala(sala)})
    }

    method puedenPagar(cantidadTotal, cantidadIndividual) {
        return self.todosTienenSuficiente(cantidadIndividual) || self.sumaTotalSupera(cantidadTotal)
    }

    method todosTienenSuficiente(cantidad) {
        return equipo.forEach({miembro => miembro.puedePagar(cantidad)})
    }
    method sumaTotalSupera(cantidad) {
        const dineroTotal = equipo.sum({miembro => miembro.saldo()})
        return dineroTotal >= cantidad
    }
}