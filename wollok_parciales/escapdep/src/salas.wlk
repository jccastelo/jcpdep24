class Sala {
    const nombre
    const dificultad

    method nombre() = nombre

    method precio() = 10000 + self.adicional()
    method adicional()

    method esSalaDificil() {
        return dificultad > 7
    }

}

class SalaAnime inherits Sala {
    override method adicional() = 7000
}

class SalaHistoria inherits Sala {
    const basadaEnHechosReales //bool

    override method adicional() = dificultad * 0.314

    override method esSalaDificil() {
        return super() && !basadaEnHechosReales
    }
}

class SalaTerror inherits Sala {
    const sustos

    override method adicional() {
        if (sustos > 5) return sustos * 0.2
        else return 0
    }

    override method esSalaDificil() {
        return super() || sustos > 5
    }
}