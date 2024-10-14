class NivelLimitado {
    const limite

    method puedeAgregarAlCarrito(tamanio) {
        return tamanio < limite
    }
}

const bronce = new NivelLimitado(limite = 1)
const plata = new NivelLimitado(limite = 5)

object oro {
    method puedeAgregarAlCarrito(tamanio) = true
}