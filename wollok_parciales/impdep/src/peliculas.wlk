import src.artistas.*

class Pelicula {
    const nombre
    const elenco = []

    method nombre() = nombre
    method elenco() = elenco

    method presupuesto() {
        return self.sumaSueldos() * 1.7
    }

    method sumaSueldos() {
        return elenco.sum({actor => actor.sueldo()})
    }

    method ganancias() {
        return self.recaudacion() - self.presupuesto()
    }

    method recaudacion() {
        return 1000000 + self.extraPorCategoria()
    }

    method extraPorCategoria()

    method rodar() {
        elenco.forEach({actor => actor.actuar()})
    }

    method esEconomica() {
        return self.presupuesto() < 500000
    }
}

class Accion inherits Pelicula {
    const vidriosRotos

    override method presupuesto() {
        return super() + vidriosRotos * 1000
    }

    override method extraPorCategoria() {
        return elenco.size() * 50000
    }
}

class Drama inherits Pelicula {
    override method extraPorCategoria() {
        return nombre.size() * 100000
    }
}

class Terror inherits Pelicula {
    const cantidadDeCuchos

    override method extraPorCategoria() {
        return cantidadDeCuchos * 20000
    }
}

class Comedia inherits Pelicula {
    override method extraPorCategoria() = 0
}