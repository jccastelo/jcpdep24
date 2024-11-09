import src.personas.Persona

object alegria {

    method asentarRecuerdo(persona, recuerdo) {
        if (persona.tieneMasFelicidadQue(500)) {
            persona.agregarPensamientoCentral(recuerdo)
        }
    }

    method niega(emocion) {
        return emocion != self
    }
}

object tristeza {

    method asentarRecuerdo(persona, recuerdo) {
        persona.agregarPensamientoCentral(recuerdo)
        if (persona.felicidad() - (persona.felicidad() * 0.1) < 1)
            throw new Exception(message="La alegría no puede ser menor a 1")
        persona.disminuirPorcentajeAlegria(10)
    }

    method niega(emocion) {
        return emocion == alegria
    }
}

class DemasEmociones {
    method asentarRecuerdo(persona, recuerdo) {}

    method niega(emocion) = false
}

const desagrado = new DemasEmociones()
const furia = new DemasEmociones()
const temor = new DemasEmociones()

