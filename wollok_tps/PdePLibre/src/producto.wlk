class Producto {
    var nombre
    const precioBase

    method precio() {
        return precioBase * 1.21
    }

    method nombreEnOferta() {
        return "SUPER OFERTA " + nombre
    }
}

class Mueble inherits Producto {
    override method precio() {
        return super() + 1000
    }
}

class Indumentaria inherits Producto {
    var esDeTemporada // bool

    override method precio() = if (esDeTemporada) { return super() * 1.1} else {return super()}
}

class Ganga inherits Producto {
    override method precio() = 0

    override method nombreEnOferta() {
        return super() + ", COMPRAME POR FAVOR"
    }
}