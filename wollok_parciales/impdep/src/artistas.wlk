import src.excepciones.NoPuedoRecategorizarException

class Artista {
    var experiencia
    var cantidadDePeliculasQueActuo
    var ahorros

    method sueldo() {
        return experiencia.dinero(cantidadDePeliculasQueActuo)
    }

    method recategorizarExperiencia() {
        experiencia = experiencia.recategorizar(cantidadDePeliculasQueActuo)
    }

    method actuar() {
        cantidadDePeliculasQueActuo += 1
        ahorros += self.sueldo()
    }
}

object amateur {
    method dinero(cantidadDePeliculas) {
        return 10000
    }

    method recategorizar(cantidadDePeliculas) {
        if (cantidadDePeliculas > 10) return establecida
        else return self
    }
}

object establecida {

    method nivelDeFama(cantidadDePeliculas) {
        return cantidadDePeliculas / 2
    }
    method dinero(cantidadDePeliculas) {
        const fama = self.nivelDeFama(cantidadDePeliculas)
        if (fama < 15) return 15000
        else return 5000 * fama
    }

    method recategorizar(cantidadDePeliculas) {
        if (self.nivelDeFama(cantidadDePeliculas) > 10) return estrella
        else return self
    }
}

object estrella {
    method dinero(cantidadDePeliculas) {
        return 30000 * cantidadDePeliculas
    }

    method recategorizar(cantidadDePeliculas) {
        throw new NoPuedoRecategorizarException()
    }
}

