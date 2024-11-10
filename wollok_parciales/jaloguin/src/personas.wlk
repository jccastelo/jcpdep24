import src.elemento.*

class Ninio {
    const elementos = [] //trajes y maquillajes
    const actitud
    var caramelos

    method elementos() = elementos

    method caramelos() = caramelos
    method sumarCaramelos(cantidad) {
        caramelos += cantidad
    }

    method capacidadParaAsustar() {
        return self.sumatoriaElementos() * actitud
    }

    method sumatoriaElementos() {
        return elementos.sum({elemento => elemento.cuantoAsusta()})
    }

    method asustar(adulto) {
        if (!adulto.seAsusta(self.capacidadParaAsustar())) {
            throw new Exception(message="El adulto no fue asustado")}
        self.sumarCaramelos(1)
    }

    method comerCaramelos(cantidad) {
        if (cantidad > caramelos) {
            throw new Exception(message="No tiene esa cantidad de caramelos para comer")
        }
        caramelos -= cantidad
    }
}

class Adulto {
    const cantidadNiniosQueIntentaronAsustarlo

    method tolerancia() = 10 * cantidadNiniosQueIntentaronAsustarlo

    method seAsusta(capacidadDeSustoDelNinio) {
        return self.tolerancia() < capacidadDeSustoDelNinio
    }
}

class Abuelo inherits Adulto {
    override method seAsusta(capacidadDeSustoDelNinio) = true
}

class AdultoNecio inherits Adulto {
    override method seAsusta(capacidadDeSustoDelNinio) = false
}