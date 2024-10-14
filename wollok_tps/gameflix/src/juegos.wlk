class Juego {
    const nombre
    const precio
    const categoria

    method perteneceACategoria(unaCategoria) {
        return categoria == unaCategoria
    }

    method seLlama(unNombre) {
        return nombre == unNombre
    }

    method afectarA(unCliente, unasHoras)

    method saleMenosQue(unaCantidad) {
        return precio < unaCantidad
    }
}

class JuegoViolento inherits Juego {

    override method afectarA(unCliente, unasHoras) {
        unCliente.bajarHumor(10 * unasHoras)
    }
}

class Moba inherits Juego {
    override method afectarA(unCliente, unasHoras) {
        unCliente.pagar(30)
    }
}

class JuegoDeTerror inherits Juego {
    override method afectarA(unCliente, unasHoras) {
        //TO DO
    }

}

class JuegoEstrategico inherits Juego {
    override method afectarA(unCliente, unasHoras) {
        unCliente.aumentarHumor(5 * unasHoras)
    }
}