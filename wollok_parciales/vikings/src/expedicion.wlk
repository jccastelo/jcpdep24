import src.vikingos.*
import src.Zonas.*
import src.castaSocial.*
import src.NoPuedoAgregarVikingoException.NoPuedoAgregarVikingoException

class Expedicion {
    const vikingos = []
    const zonasInvadidas = []

    method subirVikingo(vikingo) {
        if (vikingo.esProductivo()) {
            vikingos.add(vikingo)
        } else {
            throw new NoPuedoAgregarVikingoException(message = "¡El vikingo no puede ser agregado a la expedicion ya que no es productivo!")
        }
    }

    method valeLaPena() {
        return zonasInvadidas.all({zona => zona.valeLaPena(self.cantidadDeVikingos())})
    }

    method cantidadDeVikingos() {
        return vikingos.size()
    }

    method listaBotines() {
        return zonasInvadidas.map({zona => zona.botin()})
    }

    method botinTotal() {
        return self.listaBotines().sum()
    }

    method repartirOro() {
        vikingos.forEach({vikingo => vikingo.sumarOro(self.cantidadDeOroCorrespondiente())})
    }

    method cantidadDeOroCorrespondiente() {
        return self.botinTotal() / self.cantidadDeVikingos()
    }
}