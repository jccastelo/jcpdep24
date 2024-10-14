class Cupon {
    var fueUsado = false //bool
    const porcentaje

    method estaDisponible() = !fueUsado
    method usar() {
        fueUsado = true
    }
    method porcentaje() = porcentaje

    method precioConElDescuentoAplicado(unPrecio) {
        return unPrecio * (1 - porcentaje)
    }
}