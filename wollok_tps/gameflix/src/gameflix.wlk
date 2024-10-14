import src.juegos.*
import src.NoExisteElJuegoException.NoExisteElJuegoException

object gameflix {
  const juegos = #{new JuegoViolento(nombre = "Hollow Knight", precio = 5, categoria = "demo")}
  const clientes = #{}

  method juegosDeCategoria(unaCategoria) {
    return juegos.filter( { unJuego => unJuego.perteneceACategoria(unaCategoria) })
  }

  method juegoQueSeLlama(unNombre) {
    return juegos.findOrElse( { unJuego => unJuego.seLlama(unNombre)}, { throw new NoExisteElJuegoException(nombreDeJuego = unNombre) })
  }

  method juegoRecomendado() {
    return juegos.anyOne()
  }

  method cobrarSuscripciones() {
    clientes.forEach({ unCliente => unCliente.pagarSuscripcion()})
  }



}