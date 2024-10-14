class Capital {
    const defensores
    const factorDeRiqueza

    method valeLaPena(cantidadDeVikingos) {
        return (self.botin() / 3) >= cantidadDeVikingos
    }

    method botin() {
        return defensores * factorDeRiqueza
    }
}

class Aldea {
    const iglesias

    method valeLaPena(cantidadDeVikingos) {
        return self.saciaSedDeSaqueo()
    }

    method saciaSedDeSaqueo() {
        return self.botin() >= 15
    }

    method botin() {
        return self.cantidadDeCrucifijos()
    }

    method cantidadDeCrucifijos() {
        return iglesias
    }
}

class AldeaAmurallada inherits Aldea {
    const cantidadMinimaDeVikingos

    override method valeLaPena(cantidadDeVikingos) {
        return (cantidadDeVikingos >= cantidadMinimaDeVikingos) && self.saciaSedDeSaqueo()
    }
}