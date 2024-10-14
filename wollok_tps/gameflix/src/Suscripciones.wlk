object premium {
    const precio = 50

    method precio () = precio

    method puedeJugar(unJuego) {
        return true
    }
}

object base {
    const precio = 25

    method precio() = precio

    method puedeJugar(unJuego) {
        return unJuego.saleMenosQue(30)
    }
}

object infantil {
    const precio = 10

    method precio() = precio

    method puedeJugar(unJuego) {
        return unJuego.perteneceACategoria("Infantil")
    }
}

object prueba {
    const precio = 0

    method precio() = precio

    method puedeJugar(unJuego) {
        return unJuego.perteneceACategoria("Demo")
    }
}