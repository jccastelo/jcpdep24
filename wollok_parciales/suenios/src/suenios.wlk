import src.personas.Persona

class Suenio {
    var cumplido = false
    const felicidonios

    method estaPendiente() = !cumplido
    method estaCumplido() = cumplido
    method serCumplido(persona) {
        cumplido = true
        persona.aumentarFelicidad(felicidonios)
    }
    method felicidad() = felicidonios
    method puedeCumplirlo(persona)
    method esAmbicioso() {
        return felicidonios > 100
    }
}

class SuenioCarrera inherits Suenio {
    const carrera

    method carrera() = carrera

    override method puedeCumplirlo(persona) {
        return carrera == persona.carreraQueQuiereEstudiar() && !persona.carrerasRealizadas().contains(carrera)
    }

    override method serCumplido(persona) {
        super(persona)
        persona.agregarCarrera(carrera)
    }
}

class SuenioAdoptarHijos inherits Suenio {
    const cantidad

    override method puedeCumplirlo(persona) {
        return persona.hijos() < 1
    }

    override method serCumplido(persona) {
        super(persona)
        persona.agregarHijos(cantidad)
    }
}

class SuenioViajar inherits Suenio {
    const destino

    override method puedeCumplirlo(persona) = true
}

class SuenioLaburo inherits Suenio {
    const sueldo

    override method puedeCumplirlo(persona) {
        return sueldo < persona.plataQueQuiereGanar()
    }
}
