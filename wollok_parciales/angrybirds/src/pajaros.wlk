class Pajaro {
    var ira

    method fuerza() = ira * 2

    method enojarse() {}

    method tranquilizar() {
        ira -= 5
    }
}

object red inherits Pajaro(ira = 10) {
    var cantidadDeVecesQueSeEnojo = 1

    override method enojarse() {
        cantidadDeVecesQueSeEnojo += 1
    }

    override method fuerza() = ira * 10 * cantidadDeVecesQueSeEnojo
}

object bomb inherits Pajaro(ira = 20) {
    var topeDeFuerza = 9000

    method topeDeFuerza(nuevaFuerza) {
        topeDeFuerza = nuevaFuerza
    }

    override method fuerza() {
        return super().max(topeDeFuerza)
    }
}

object chuck inherits Pajaro(ira=5) {
    var velocidadActual = 60

    override method enojarse() {
        velocidadActual = velocidadActual * 2
    }

    override method fuerza() {
        if (velocidadActual <= 80) return 150
        return 150 + 5 * (velocidadActual - 80)
    }

    override method tranquilizar() {}
}

object terence inherits Pajaro(ira=10) {
    var cantidadDeVecesQueSeEnojo = 1
    var multiplicador = 2

    method multiplicador(nuevoMultiplicador) {
        multiplicador = nuevoMultiplicador
    }

    override method enojarse() {
        cantidadDeVecesQueSeEnojo += 1
    }

    override method fuerza() = ira * multiplicador * cantidadDeVecesQueSeEnojo
}

object matilda inherits Pajaro(ira=5) {
    const huevos = []

    override method fuerza() = 2 * ira * self.fuerzaDeSusHuevos()

    method fuerzaDeSusHuevos() {
        return huevos.sum({huevo => huevo.fuerzaDelHuevo()})
    }

    override method enojarse() {
        const huevo = new Huevo(peso=2)
        huevos.add(huevo)
    }
}

class Huevo {
    const peso

    method fuerzaDelHuevo() = peso
}