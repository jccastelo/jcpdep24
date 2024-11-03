import src.suenios.*

class Persona {
    const edad
    const carreraQueQuiereEstudiar
    const plataQueQuiereGanar
    const lugaresQueQuiereViajar = []
    var hijos = 0
    var felicidonios

    const suenios = []
    const carrerasRealizadas = []

    var tipoDePersona

    method tipoDePersona(tipo) {
        tipoDePersona = tipo
    }

    method aumentarFelicidad(cantidad) {
        felicidonios += cantidad
    }

    method carreraQueQuiereEstudiar() = carreraQueQuiereEstudiar
    method carrerasRealizadas() = carrerasRealizadas
    method agregarCarrera(carrera) {
        carrerasRealizadas.add(carrera)
    }

    method hijos() = hijos
    method agregarHijos(cantidad) {
        hijos += cantidad
    }

    method plataQueQuiereGanar() = plataQueQuiereGanar

    method cumplirSuenio(suenio) {
        if (!self.sueniosPendientes().cointains(suenio)) {throw new Exception(message= "El suenio no esta pendiente")}
        if (suenio.puedeCumplirlo(self)) {throw new Exception(message="No cumple los requerimientos para cumplir el suenio")}
        suenio.serCumplido(self)
    }


    method cumplirSueniosMultiples(listaDeSuenios) {
        listaDeSuenios.forEach({suenio => self.cumplirSuenio(suenio)})
    }

    method cumplirSuenioElegido() {
        self.cumplirSuenio(tipoDePersona.elegirSuenio(self.sueniosPendientes()))
    }

    method sueniosPendientes() {
        return suenios.filter { suenio => suenio.estaPendiente() }
    }

    method sueniosCumplidos() {
        return suenios.filter { suenio => suenio.estaCumplido()}
    }

    method felicidoniosSueniosPendientes() {
        return self.sueniosPendientes().map({suenio => suenio.felicidad()}).sum()
    }

    method esFeliz() {
        return felicidonios >= self.felicidoniosSueniosPendientes()
    }

    method esAmbiciosa() {
        return self.cantidadSueniosAmbiciosos() >= 3
    }

    method sueniosAmbiciosos() {
        return suenios.filter({ suenio => suenio.esAmbicioso()})
    }

    method cantidadSueniosAmbiciosos() {
        return self.sueniosAmbiciosos().size()
    }
}

object personaRealista {
    method elegirSuenio(listaDeSuenios) {
        listaDeSuenios.max { suenio => suenio.felicidad()}
    }
}

object personaAlocada {
    method elegirSuenio(listaDeSuenios) {
        listaDeSuenios.anyOne()
    }
}

object personaObsesiva {
    method elegirSuenio(listaDeSuenios) {
        listaDeSuenios.head()
    }
}