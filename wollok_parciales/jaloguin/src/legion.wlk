import src.personas.*
import src.elemento.*

class Legion {
    const ninios = []

    method capacidadGrupalParaAsustar() {
        return ninios.sum({ninio => ninio.capacidadParaAsustar()})
    }

    method caramelosDelGrupo() {
        return ninios.sum({ninio => ninio.caramelos()})
    }

    method lider() {
        return ninios.max({ninio => ninio.capacidadParaAsustar()})
    }

    method asustar(unAdulto) {
        if (!unAdulto.seAsusta(self.capacidadGrupalParaAsustar())) {
            throw new Exception(message="El adulto no fue asustado")}
        self.lider().sumarCaramelos(1)
    }
}