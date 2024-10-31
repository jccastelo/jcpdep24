import src.salas.*

class Escapista {
    var maestria
    const salasQueSalio = []
    var saldo

    method saldo() = saldo
    method puedePagar(cantidad) {
        return saldo >= cantidad
    }
    method descontarSalario(cantidad) {
        saldo -= cantidad
    }
    method agregarSala(sala) {
        salasQueSalio.add(sala)
    }

    method puedeSalir(sala) {
        const esDificil = sala.esSalaDificil()
        const hizoMuchasSalas = self.cantidadSalasQueSalio() >= 6
        return maestria.puedeSalir(esDificil, hizoMuchasSalas)
    }

    method subirNivelDeMaestria() {
        if (self.cantidadSalasQueSalio() > 5) {
            maestria = maestria.siguienteNivel()
        }
    }

    method cantidadSalasQueSalio() {
        return salasQueSalio.size()
    }

    method nombreSalasQueSalio() {
        return salasQueSalio.map({sala => sala.nombre()}).asSet()
    }
}


object amateur {
    const siguienteNivel = profesional
    method siguienteNivel() = siguienteNivel
    method puedeSalir(esSalaDificil, hizoMuchasSalas) {
        return esSalaDificil && hizoMuchasSalas
    }
}

object profesional {
    const siguienteNivel = self
    method siguienteNivel() = siguienteNivel
    method puedeSalir(esSalaDificil, hizoMuchasSalas) = true
}
