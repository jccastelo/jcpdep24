import src.artistas.*
import src.peliculas.*

object imPdep {
    const artistas = #{}
    const peliculas = #{}

    method artistas() = artistas
    method peliculas() = peliculas

    method agregarPelicula(pelicula) {
        peliculas.add(pelicula)
        artistas.addAll(pelicula.elenco())
    }

    method artistaMejorPago() {
        return artistas.max({artista => artista.sueldo()})
    }

    method peliculasEconomicas() {
        return peliculas.filter({pelicula => pelicula.esEconomica()})
    }

    method nombresPeliculasEconomicas() {
        return self.peliculasEconomicas().map({pelicula => pelicula.nombre()})
    }

    method gananciasPeliculasEconomicas() {
        return self.peliculasEconomicas().sum({pelicula => pelicula.ganancias()})
    }

    method recategorizarATodosLosArtistas() {
        artistas.forEach({artista => artista.recategorizarExperiencia()})
    }
}