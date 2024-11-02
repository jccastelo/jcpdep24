import src.ubicacion.Ubicacion
import src.estadosOperaciones.*
import src.tiposDeOperaciones.*

class Inmueble {
    const tamanio
    const cantidadDeAmbientes
    const operacion
    const ubicacion
    var estadoOperacion = disponible

    method estadoOperacion(nuevoEstado) {
        estadoOperacion = nuevoEstado
    }
    method estadoOperacion() = estadoOperacion

    method valorDeInmueble() {
        return ubicacion.valorAgregado()
    }

    method comisionEmpleado() {
        return operacion.comisionDelAgente(self.valorDeInmueble())
    }
}

class Casa inherits Inmueble {
    const valorDeLaCasa

    override method valorDeInmueble() {
        return super() + valorDeLaCasa
    }
}

class PH inherits Inmueble {
    override method valorDeInmueble() {
        return super() + (14000 * tamanio).min(500000)
    }
}

class Departamento inherits Inmueble {
    override method valorDeInmueble() {
        return super() + (350000 * cantidadDeAmbientes)
    }
}