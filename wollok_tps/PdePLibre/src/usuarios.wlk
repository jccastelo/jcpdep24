import src.excepcion.NoPuedoAgregarAlCarritoException
import src.cupones.Cupon
import src.niveles.*

class Usuario {
    const nombre
    var dineroDisponible
    var puntos
    var nivel
    const carrito = []
    const cupones = []

    method restarDinero(cantidad) {
        dineroDisponible -= cantidad
    }

    method sumarPuntos(cantidad) {
        puntos += cantidad
    }

    method agregarAlCarrito(unProducto) {
        if (nivel.puedeAgregarAlCarrito(carrito.size())) {
            carrito.add(unProducto)
        } else {
            throw new NoPuedoAgregarAlCarritoException()
        }
    }

    method comprarCarrito() {
        const cupon = self.cuponDisponible()
        cupon.usar()
        const precioAPagar = cupon.precioConElDescuentoAplicado(self.precioDelCarrito())
        self.restarDinero(precioAPagar)
        self.sumarPuntos(precioAPagar * 0.1)
    }

    method cuponDisponible() {
        return cupones.filter({ unCupon => unCupon.estaDisponible()}).anyOne()
    }

    method precioDelCarrito() {
        return carrito.sum({ unProducto => unProducto.precio()})
    }

    method esMoroso() {
        return dineroDisponible < 0
    }

    method penalizar() {
        puntos -= 1000
    }

    method eliminarCuponesUsados() {
        cupones.removeAllSuchThat({ cupon => !cupon.estaDisponible()})
    }

    method actualizarNivel() {
        nivel = self.nivelCorrespondiente()
    }

    method nivelCorrespondiente() {
        if (puntos < 5000) return bronce
        if (puntos < 15000) return plata
        return oro
    }

}