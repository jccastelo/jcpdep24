class CastaSocial {
    method esProductivo(cantidadDeArmas) = true

    method siguienteCastaSocial()

    method cantidadArmasAlAscender() = 0
    method cantidadHijosAlAscender() = 0
    method cantidadHectareasAlAscender() = 0
}

object jarl inherits CastaSocial {
    
    override method esProductivo(cantidadDeArmas) {
        return cantidadDeArmas == 0
    }

    override method siguienteCastaSocial() {
        return karl
    }
}

object karl inherits CastaSocial {
    override method siguienteCastaSocial() {
        return thrall
    }

    override method cantidadArmasAlAscender() = 10
    override method cantidadHijosAlAscender() = 2
    override method cantidadHectareasAlAscender() = 2
}

object thrall inherits CastaSocial {
    override method siguienteCastaSocial() {
        return self
    }
}