import src.pajaros.*
import src.cerditos.*

object islaPajaros {
    const pajaros = #{red, bomb, chuck, terence, matilda}

    method pajarosFuertes() {
        return pajaros.filter({pajaro => pajaro.fuerza() > 50})
    }

    method fuerzaDeLaIsla() {
        return self.pajarosFuertes().sum({pajaro => pajaro.fuerza()})
    }

    method sesionManejoDeIra() {
        pajaros.forEach({pajaro => pajaro.tranquilizar()})
    }

    method invasionDeCerditos(cantidadDeCerditos) {
        (cantidadDeCerditos.div(100)).times(pajaros.forEach({pajaro => pajaro.enojarse()}))
    }

    method fiestaSorpresa(listaDeHomenajeados) {
        listaDeHomenajeados.intersection(pajaros).forEach({pajaro => pajaro.enojarse()})
    }

    method serieDeEventosDesafortunados(cantidadDeCerditos, listaDeHomenajeados) {
        self.sesionManejoDeIra()
        self.invasionDeCerditos(cantidadDeCerditos)
        self.fiestaSorpresa(listaDeHomenajeados)
    }

    method atacar(islaCerdito) {
        const obstaculos = islaCerdito.obstaculos()
        pajaros.forEach({pajaro => islaCerdito.derribar(obstaculos.head(), pajaro.fuerza())})
    }
}

object islaCerditos {
    const obstaculos = []

    method obstaculos() = obstaculos

    method derribar(obstaculo, fuerzaDelPajaro) {
        if (obstaculo.puedeSerDerribado(fuerzaDelPajaro))
            obstaculos.remove(obstaculo)
    }

    method estaLibreDeObstaculos() = obstaculos.size()
}