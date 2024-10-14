import src.MeQuedeSinPlataException.MeQuedeSinPlataException
import src.Suscripciones.*

class Cliente {
    var humor
    var plata
    var suscripcion

    method suscripcion(unaSuscripcion) {
        suscripcion = unaSuscripcion
    }


    method bajarHumor(unaCantidad) {
        humor -= unaCantidad
    }


    method aumentarHumor(unaCantidad) {
        humor += unaCantidad
    }

    method pagar(unPrecio) {
        if (plata < unPrecio) {
            throw new MeQuedeSinPlataException()
        }
        plata -= unPrecio
    }

    method pagarSuscripcion() {
        try {
        self.pagar(suscripcion.precio())
        } catch unError : MeQuedeSinPlataException {
            self.suscripcion(prueba)
        }
    }
}