import src.ubicacion.Ubicacion
import src.estadosOperaciones.*
import src.tiposDeOperaciones.*
import src.inmuebles.*

object inmobiliaria {
    const operaciones = []
    const empleados = []
}

class Cliente {
    method solicitarReservaA(unEmpleado, unaPropiedad) {
        unEmpleado.reservar(self, unaPropiedad)
    }

    method solicitarConcretarA(unEmpleado, unaPropiedad) {
        unEmpleado.concretar(self, unaPropiedad)
    }
}

class Empleado {
    const operacionesCerradas = []
    const reservas = []
    var comisiones = []

    method comisionesTotales() {
        return comisiones.size()
    }

    method cantidadDeOperacionesCerradas() {
        return operacionesCerradas.size()
    }

    method cantidadDeReservas() {
        return reservas.size()
    }

    method reservar(unCliente, unaPropiedad) {
        const reserva = new Reserva(empleado= self, cliente= unCliente)
        unaPropiedad.estadoDeOperacion(reserva)
        reservas.add(reserva)
    }

    method concretar(unCliente, unaPropiedad) {
        const clienteQueReservo = unaPropiedad.estadoOperacion().clienteQueReservo()
        if (unCliente == clienteQueReservo) {
            const concreta = new Concreta(empleado= self, cliente= unCliente)
            unaPropiedad.estadoOperacion(concreta)
            operacionesCerradas.add(concreta)
            comisiones.add(unaPropiedad.comisionEmpleado())
        }
    }
}