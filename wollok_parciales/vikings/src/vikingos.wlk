import src.castaSocial.*

class Vikingo {
    var castaSocial
    var armas
    var oro = 0

    method castaSocial() = castaSocial
    method armas() = armas

    method sumarArmas(cantidad) {
        armas += cantidad
    }

    method sumarOro(cantidad) {
        oro += cantidad
    }

    method esProductivo()

    method tieneArmas() {
        return armas > 0
    }

    method ascenderSocialmente() {
        castaSocial = castaSocial.siguienteCastaSocial()
    }
}

class Soldado inherits Vikingo{
    var property vidasCobradas
    
    override method esProductivo() {
        return (vidasCobradas > 20) && self.tieneArmas() && self.castaSocial().esProductivo(self.armas())
    }

    override method ascenderSocialmente() {
        super()
        self.sumarArmas(self.castaSocial().cantidadArmasAlAscender())
    }
}

class Granjero inherits Vikingo {
    var hijos
    var hectareas

    method sumarHijos(cantidad) {
        hijos += cantidad
    }
    method sumarHectareas(cantidad){ 
        hectareas += cantidad
    }

    override method esProductivo() {
        return self.tieneMasHectareasQueHijos() && self.castaSocial().esProductivo(self.armas())
    }

    method tieneMasHectareasQueHijos() {
        return hectareas * 2 >= hijos
    }

    override method ascenderSocialmente() {
        super()
        self.sumarHijos(self.castaSocial().cantidadHijosAlAscender())
        self.sumarHectareas(self.castaSocial().cantidadHectareasAlAscender())
    }
}