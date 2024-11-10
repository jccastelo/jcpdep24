class Elemento {
    var sustos

    method sustos(nuevaCantidad) {
        sustos = nuevaCantidad
    }

    method cuantoAsusta() = sustos
}

const maquillaje = new Elemento(sustos=3)
const trajeTierno = new Elemento(sustos=2)
const trajeTerrorifico = new Elemento(sustos=5)