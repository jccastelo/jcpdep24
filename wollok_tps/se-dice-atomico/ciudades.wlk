import centrales.*

object springfield {
    const vientos = 10 //m/s
    const riqueza = 0.9 //90%
    var necesidadEnergetica = 20 //millones de kWh
    const centrales = #{}

    method vientos() = vientos
    method riqueza() = riqueza
    method necesidadEnergetica() = necesidadEnergetica
    method centrales() = centrales

    method setNecesidadEnergetica(cantidad) {
        necesidadEnergetica = cantidad
    }

    method instalarCentral(unaCentral) {
        self.agregarA(centrales, unaCentral)
    }

    method agregarA(coleccion, unValor) {
        coleccion.add(unValor)
    }

    method centralesContaminantes() {
        return centrales.filter({ unaCentral => unaCentral.contamina() })
    }

    method suministroEnergetico() {
        return centrales.sum({ unaCentral => unaCentral.produccionEnergetica(self)})
    }

    method cubrioNecesidades() {
        return self.suministroEnergetico() >= necesidadEnergetica
    }

    method aporteDeContaminantes() {
        return self.centralesContaminantes().sum({ unaCentral => unaCentral.produccionEnergetica(self)})
    }

    method todoContamina() {
        return centrales.all({ unaCentral => unaCentral.contamina()})
    }

    method estaAlHorno() {
        return self.aporteDeContaminantes() >= (necesidadEnergetica * 0.5) or self.todoContamina()
    }

    method centralMasProductora() {
        return centrales.max({ unaCentral => unaCentral.produccionEnergetica(self)})
    }
}

object albuquerque {
    const caudal = 150 //l/s
    var central = centralhidroelectrica

    method caudal() = caudal
    method central() = central

    method centralMasProductora() {
        return central
    }
}